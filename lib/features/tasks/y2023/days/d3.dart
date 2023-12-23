import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _NumberRun = ({int r, int c, String number});
typedef _Cell<T extends _MapCell> = ({int r, int c, T cell});

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
              (l) => l
                  .split('')
                  .map(
                    (c) => switch ((c, int.tryParse(c))) {
                      (_, final value?) => _Digit(value),
                      ('.', _) => const _Empty(),
                      _ => _Symbol(c),
                    },
                  )
                  .toList(),
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
      (r: run.r, c: run.c - 1),
      (r: run.r, c: run.c + run.number.length),
      ...List.generate(
        run.number.length + 2,
        (index) => (r: run.r - 1, c: run.c + index - 1),
      ),
      ...List.generate(
        run.number.length + 2,
        (index) => (r: run.r + 1, c: run.c + index - 1),
      ),
    ]
        .where((ix) => matrix.isIndexInBounds(ix.r, ix.c))
        .map((ix) => matrix(ix.r, ix.c))
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
            (run) =>
                (run: run, adjacent: _adjacentToGear(inputData.matrix, run)),
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

  ({bool isAdjacent, int r, int c}) _adjacentToGear(
    Matrix<_MapCell> matrix,
    _NumberRun run,
  ) {
    return [
      (r: run.r, c: run.c - 1),
      (r: run.r, c: run.c + run.number.length),
      ...List.generate(
        run.number.length + 2,
        (index) => (r: run.r - 1, c: run.c + index - 1),
      ),
      ...List.generate(
        run.number.length + 2,
        (index) => (r: run.r + 1, c: run.c + index - 1),
      ),
    ]
        .where((ix) => matrix.isIndexInBounds(ix.r, ix.c))
        .map((ix) => (r: ix.r, c: ix.c, cell: matrix(ix.r, ix.c)))
        .where(
          (e) => switch (e.cell) { _Symbol(value: '*') => true, _ => false },
        )
        .apply(
          (es) => switch (es.toList()) {
            [] => (isAdjacent: false, r: -1, c: -1),
            [final cell, ...] => (isAdjacent: true, r: cell.r, c: cell.c),
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
  return cells.fold(<_NumberRun>[], (previousValue, element) {
    final currentRun = previousValue.lastOrNull;

    if (currentRun != null &&
        currentRun.r == element.r &&
        currentRun.c == element.c - 1) {
      return [
        ...previousValue.take(previousValue.length - 1),
        (
          r: element.r,
          c: element.c,
          number: currentRun.number + element.cell.value.toString()
        ),
      ];
    }

    return [
      ...previousValue,
      (r: element.r, c: element.c, number: element.cell.value.toString()),
    ];
  }).map((e) => (r: e.r, c: e.c - e.number.length + 1, number: e.number));
}
