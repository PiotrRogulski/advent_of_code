import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _Cell = ({int r, int c, _Pipe cell});

typedef _I = MatrixInput<_Pipe>;
typedef _O = NumericOutput<int>;

class Y2023D10 extends DayData<_I> {
  const Y2023D10() : super(2023, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      dense: true,
      Matrix.fromList(
        rawData
            .split('\n')
            .map((l) => l.split('').map(_Pipe.fromSymbol).toList())
            .toList(),
      ),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      _cycle(
            inputData.matrix.cells.firstWhere((c) => c.cell == _Pipe.unknown),
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
      matrix.cells.firstWhere((c) => c.cell == _Pipe.unknown),
      matrix,
    ).map((e) => (e.r, e.c));
    for (final index in matrix.indexes.toSet().difference(cycle.toSet())) {
      matrix.set(index.$1, index.$2, _Pipe.empty);
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

  Iterable<(int, int)> adjacent(int c, int r) {
    final diffs = switch (this) {
      empty => <(int, int)>[],
      vertical => [(0, -1), (0, 1)],
      horizontal => [(-1, 0), (1, 0)],
      topLeft => [(0, 1), (1, 0)],
      topRight => [(0, 1), (-1, 0)],
      bottomLeft => [(0, -1), (1, 0)],
      bottomRight => [(0, -1), (-1, 0)],
      unknown => [(0, -1), (0, 1), (-1, 0), (1, 0)],
    };
    return diffs.map((d) => (c + d.$1, r + d.$2));
  }
}

Iterable<_Cell> _cycle(_Cell start, Matrix<_Pipe> matrix) sync* {
  var current = start;
  final visited = <_Cell>{};
  while (true) {
    yield current;
    visited.add(current);
    final adjacent = current.cell
        .adjacent(current.c, current.r)
        .where((c) => matrix.isIndexInBounds(c.$2, c.$1))
        .map((c) => (r: c.$2, c: c.$1, cell: matrix(c.$2, c.$1)))
        .where((c) => !visited.contains(c) && _canConnect(current, c));
    if (adjacent.isEmpty) {
      break;
    }
    current = adjacent.first;
  }
}

bool _canConnect(_Cell from, _Cell to) {
  final (r: r1, c: c1, cell: cell1) = from;
  final (r: r2, c: c2, cell: cell2) = to;

  return cell1.adjacent(c1, r1).contains((c2, r2)) &&
      cell2.adjacent(c2, r2).contains((c1, r1));
}
