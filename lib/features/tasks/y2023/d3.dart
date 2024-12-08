import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _NumberRun = ({int row, int column, String number});
typedef _Cell<T extends _MapCell> = MatrixCell<T>;

typedef _I = MatrixInput<_MapCell>;
typedef _O = NumericOutput<int>;

class Y2023D3 extends DayData<_I> {
  const Y2023D3() : super(2023, 3, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return MatrixInput(
      Matrix.fromList(
        rawData
            .split('\n')
            .map(
              (l) => [
                for (final c in l.split(''))
                  switch ((c, int.tryParse(c))) {
                    (_, final value?) => _Digit(value),
                    ('.', _) => const _Empty(),
                    _ => _Symbol(c),
                  },
              ],
            )
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
      inputData.matrix.cells
          .whereType<_Cell<_Digit>>()
          .apply(_cellsToNumbers)
          .where((run) => _isAdjacentToSymbol(inputData.matrix, run))
          .map((e) => e.number)
          .map(int.parse)
          .sum,
    );
  }

  bool _isAdjacentToSymbol(Matrix<_MapCell> matrix, _NumberRun run) {
    return [
          (row: run.row, column: run.column - 1),
          (row: run.row, column: run.column + run.number.length),
          ...List.generate(
            run.number.length + 2,
            (index) => (row: run.row - 1, column: run.column + index - 1),
          ),
          ...List.generate(
            run.number.length + 2,
            (index) => (row: run.row + 1, column: run.column + index - 1),
          ),
        ]
        .where(matrix.isIndexInBounds)
        .map(matrix.atIndex)
        .any((cell) => cell is _Symbol);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.matrix.cells
          .whereType<_Cell<_Digit>>()
          .apply(_cellsToNumbers)
          .map(
            (run) => (
              run: run,
              adjacent: _adjacentToGear(inputData.matrix, run),
            ),
          )
          .where((e) => e.adjacent.isAdjacent)
          .groupSetsBy((element) => element.adjacent)
          .values
          .where((e) => e.length == 2)
          .map(
            (e) => e
                .map((e) => e.run.number)
                .map(int.parse)
                .apply((e) => e.first * e.last),
          )
          .sum,
    );
  }

  ({bool isAdjacent, int row, int column}) _adjacentToGear(
    Matrix<_MapCell> matrix,
    _NumberRun run,
  ) {
    return [
          (row: run.row, column: run.column - 1),
          (row: run.row, column: run.column + run.number.length),
          ...List.generate(
            run.number.length + 2,
            (index) => (row: run.row - 1, column: run.column + index - 1),
          ),
          ...List.generate(
            run.number.length + 2,
            (index) => (row: run.row + 1, column: run.column + index - 1),
          ),
        ]
        .where(matrix.isIndexInBounds)
        .map((ix) => (row: ix.row, column: ix.column, cell: matrix.atIndex(ix)))
        .where(
          (e) => switch (e.cell) {
            _Symbol(value: '*') => true,
            _ => false,
          },
        )
        .apply(
          (es) => switch (es.toList()) {
            [] => (isAdjacent: false, row: -1, column: -1),
            [final cell, ...] => (
              isAdjacent: true,
              row: cell.row,
              column: cell.column,
            ),
          },
        );
  }
}

sealed class _MapCell {
  const _MapCell();
}

class _Digit extends _MapCell {
  const _Digit(this.value);

  final int value;

  @override
  String toString() => value.toString();
}

class _Symbol extends _MapCell {
  const _Symbol(this.value);

  final String value;

  @override
  String toString() => value;
}

class _Empty extends _MapCell {
  const _Empty();

  @override
  String toString() => '.';
}

Iterable<_NumberRun> _cellsToNumbers(Iterable<_Cell<_Digit>> cells) {
  return cells
      .fold(<_NumberRun>[], (previousValue, cell) {
        final currentRun = previousValue.lastOrNull;

        if (currentRun != null &&
            currentRun.row == cell.index.row &&
            currentRun.column == cell.index.column - 1) {
          return [
            ...previousValue.take(previousValue.length - 1),
            (
              row: cell.index.row,
              column: cell.index.column,
              number: currentRun.number + cell.value.value.toString(),
            ),
          ];
        }

        return [
          ...previousValue,
          (
            row: cell.index.row,
            column: cell.index.column,
            number: cell.value.value.toString(),
          ),
        ];
      })
      .map(
        (e) => (
          row: e.row,
          column: e.column - e.number.length + 1,
          number: e.number,
        ),
      );
}
