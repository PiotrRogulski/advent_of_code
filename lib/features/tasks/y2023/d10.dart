import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _Cell = MatrixCell<_Pipe>;

typedef _I = MatrixInput<_Pipe>;
typedef _O = NumericOutput<int>;

class Y2023D10 extends DayData<_I> {
  const Y2023D10() : super(2023, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map((l) => l.split('').map(_Pipe.fromSymbol).toList())
          .toList(),
      dense: true,
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      _cycle(
            inputData.matrix.cells.firstWhere((c) => c.value == _Pipe.unknown),
            inputData.matrix,
          ).length ~/
          2,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;

    final cycle = _cycle(
      matrix.cells.firstWhere((c) => c.value == _Pipe.unknown),
      matrix,
    ).map((e) => e.index);
    for (final index in matrix.indexes.toSet().difference(cycle.toSet())) {
      matrix.setIndex(index, _Pipe.empty);
    }

    var count = 0;
    for (var r = 0; r < matrix.rowCount; r++) {
      final row = matrix.rows.elementAt(r).toList();
      Iterable<(int, int)> ranges(RegExp regex) =>
          regex
              .allMatches(row.map((e) => e.symbol).join())
              .map((e) => (e.start, e.end))
              .toList()
              .reversed;
      var countInRow = 0;
      var vBarCount = 0;
      final rangesToRemove = ranges(RegExp('(L-*J)|(F-*7)'));
      for (final (start, end) in rangesToRemove) {
        row.removeRange(start, end);
      }
      final rangesToReplace = ranges(RegExp('(L-*7)|(F-*J)'));
      for (final (start, end) in rangesToReplace) {
        row.replaceRange(start, end, [_Pipe.vertical]);
      }
      for (final cell in row) {
        if (cell == _Pipe.vertical || cell == _Pipe.unknown) {
          vBarCount++;
        }
        if (vBarCount.isOdd && cell == _Pipe.empty) {
          countInRow++;
        }
      }

      count += countInRow;
    }
    return NumericOutput(count);
  }
}

enum _Pipe {
  empty('.', '.'),
  vertical('|', '│'),
  horizontal('-', '─'),
  topLeft('F', '┌'),
  topRight('7', '┐'),
  bottomLeft('L', '└'),
  bottomRight('J', '┘'),
  unknown('S', 'S');

  const _Pipe(this.symbol, this.ascii);
  factory _Pipe.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;
  final String ascii;

  @override
  String toString() => ascii;

  Iterable<MatrixIndex> adjacent(MatrixIndex index) {
    final diffs = switch (this) {
      empty => <MatrixIndexDelta>[],
      vertical => [(dr: -1, dc: 0), (dr: 1, dc: 0)],
      horizontal => [(dr: 0, dc: -1), (dr: 0, dc: 1)],
      topLeft => [(dr: 1, dc: 0), (dr: 0, dc: 1)],
      topRight => [(dr: 1, dc: 0), (dr: 0, dc: -1)],
      bottomLeft => [(dr: -1, dc: 0), (dr: 0, dc: 1)],
      bottomRight => [(dr: -1, dc: 0), (dr: 0, dc: -1)],
      unknown => [
        (dr: 0, dc: -1),
        (dr: 0, dc: 1),
        (dr: -1, dc: 0),
        (dr: 1, dc: 0),
      ],
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
        .map((c) => (index: c, value: matrix.atIndex(c)))
        .where((c) => !visited.contains(c) && _canConnect(current, c));
    if (adjacent.isEmpty) {
      break;
    }
    current = adjacent.first;
  }
}

bool _canConnect(_Cell from, _Cell to) {
  final (index: ix1, value: cell1) = from;
  final (index: ix2, value: cell2) = to;

  return cell1.adjacent(ix1).contains(ix2) && cell2.adjacent(ix2).contains(ix1);
}
