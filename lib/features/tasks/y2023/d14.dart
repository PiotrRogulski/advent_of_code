import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = MatrixInput<_Cell>;
typedef _O = NumericOutput<int>;

class Y2023D14 extends DayData<_I> {
  const Y2023D14() : super(2023, 14, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map((e) => e.split('').map(_Cell.fromSymbol).toList())
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(
      inputData.matrix.columns
          .map(
            (c) => c.indexed
                .where((e) => e.$2 == _Cell.round)
                .map(
                  (e) => (
                    index: e.$1,
                    emptySpacesAbove:
                        c
                            .take(e.$1)
                            .toList()
                            .reversed
                            .takeWhile((e) => e != _Cell.cube)
                            .where((e) => e == _Cell.empty)
                            .length,
                  ),
                ),
          )
          .flattened
          .map((e) => e.index - e.emptySpacesAbove)
          .map((e) => inputData.matrix.columnCount - e)
          .sum,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    var matrix = inputData.matrix.copy();
    final memo = <String, ({int cycle, int result})>{};
    var index = 1;
    while (true) {
      for (final _ in [0, 1, 2, 3]) {
        _slide(matrix);
        matrix = _rotate(matrix);
      }
      final key = matrix.toString();
      if (memo[key] case final value?) {
        final n = index - value.cycle;
        final entry = memo.values.firstWhereOrNull(
          (e) => e.cycle >= value.cycle && (1_000_000_000 - e.cycle) % n == 0,
        );
        if (entry != null) {
          return _O(entry.result);
        }
      }
      memo[key] = (cycle: index, result: _calcScore(matrix));
      index++;
    }
  }
}

enum _Cell {
  empty('.'),
  round('O'),
  cube('#');

  const _Cell(this.symbol);
  factory _Cell.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}

void _slide(Matrix<_Cell> matrix) {
  for (var j = 0; j < matrix.columnCount; j++) {
    var ci = 0;
    for (var i = 0; i < matrix.rowCount; i++) {
      if (matrix.at(i, j) == _Cell.cube) {
        ci = i + 1;
      }
      if (matrix.at(i, j) == _Cell.round) {
        matrix
          ..set(i, j, _Cell.empty)
          ..set(ci, j, _Cell.round);
        ci++;
      }
    }
  }
}

Matrix<_Cell> _rotate(Matrix<_Cell> matrix) {
  final newMatrix = matrix.copy();
  for (var i = 0; i < matrix.rowCount; i++) {
    for (var j = 0; j < matrix.columnCount; j++) {
      newMatrix.set(j, matrix.rowCount - i - 1, matrix.at(i, j));
    }
  }
  return newMatrix;
}

int _calcScore(Matrix<_Cell> matrix) {
  return matrix.rows
      .mapIndexed(
        (rowIndex, r) =>
            r.where((c) => c == _Cell.round).length *
            (matrix.rowCount - rowIndex),
      )
      .sum;
}
