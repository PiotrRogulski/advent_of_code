import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _Cell = MatrixCell<_Pipe>;

typedef _I = MatrixInput<_Pipe>;
typedef _O = NumericOutput<int>;

class const Y2023D10() extends DayData<_I> {
  this : super(2023, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((l) => l.split('').map(_Pipe.fromSymbol).toList())
        .toList(),
    dense: true,
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    _cycle(
          inputData.matrix.cells.firstWhere((c) => c.value == .unknown),
          inputData.matrix,
        ).length ~/
        2,
  );
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;

    final cycle = _cycle(
      matrix.cells.firstWhere((c) => c.value == .unknown),
      matrix,
    ).map((e) => e.index);
    for (final index in matrix.indexes.toSet().difference(cycle.toSet())) {
      matrix.setIndex(index, .empty);
    }

    var count = 0;
    for (var r = 0; r < matrix.rowCount; r++) {
      final row = matrix.rows.elementAt(r).toList();
      Iterable<(int, int)> ranges(RegExp regex) => regex
          .allMatches(row.map((e) => e.symbol).join())
          .map((e) => (e.start, e.end))
          .toList()
          .reversed;
      var countInRow = 0;
      var vBarCount = 0;
      final rangesToRemove = ranges(.new('(L-*J)|(F-*7)'));
      for (final (start, end) in rangesToRemove) {
        row.removeRange(start, end);
      }
      final rangesToReplace = ranges(.new('(L-*7)|(F-*J)'));
      for (final (start, end) in rangesToReplace) {
        row.replaceRange(start, end, [_Pipe.vertical]);
      }
      for (final cell in row) {
        if (cell case .vertical || .unknown) {
          vBarCount++;
        }
        if (vBarCount.isOdd && cell == .empty) {
          countInRow++;
        }
      }

      count += countInRow;
    }
    return NumericOutput(count);
  }
}

enum _Pipe(final String symbol, final String ascii) {
  empty('.', '.'),
  vertical('|', '│'),
  horizontal('-', '─'),
  topLeft('F', '┌'),
  topRight('7', '┐'),
  bottomLeft('L', '└'),
  bottomRight('J', '┘'),
  unknown('S', 'S');

  factory fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  @override
  String toString() => ascii;

  Iterable<MatrixIndex> adjacent(MatrixIndex index) {
    final List<MatrixIndexDelta> diffs = switch (this) {
      empty => [],
      vertical => [.up, .down],
      horizontal => [.left, .right],
      topLeft => [.down, .right],
      topRight => [.down, .left],
      bottomLeft => [.up, .right],
      bottomRight => [.up, .left],
      unknown => [.up, .down, .left, .right],
    };
    return diffs.map((d) => index + d);
  }
}

Iterable<_Cell> _cycle(_Cell start, Matrix<_Pipe> matrix) sync* {
  var current = start;
  final visited = <_Cell>{};
  while (true) {
    yield current;
    visited.add(current);
    final adjacent = current.value
        .adjacent(current.index)
        .where(matrix.isIndexInBounds)
        .map((c) => _Cell(index: c, value: matrix.atIndex(c)))
        .where((c) => !visited.contains(c) && _canConnect(current, c));
    if (adjacent.isEmpty) {
      break;
    }
    current = adjacent.first;
  }
}

bool _canConnect(_Cell from, _Cell to) {
  final _Cell(index: ix1, value: cell1) = from;
  final _Cell(index: ix2, value: cell2) = to;

  return cell1.adjacent(ix1).contains(ix2) && cell2.adjacent(ix2).contains(ix1);
}
