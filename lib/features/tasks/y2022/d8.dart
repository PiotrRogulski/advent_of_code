import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef _I = MatrixInput<int>;
typedef _O = NumericOutput<int>;

class Y2022D8 extends DayData<_I> {
  const Y2022D8() : super(2022, 8, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return .new(
      rawData
          .split('\n')
          .map((l) => l.characters.map(int.parse).toList())
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return .new(
      inputData.matrix.indexes.where((t) {
        final (:row, :column) = t;
        return _isVisibleFromOutside(row, column, inputData.matrix);
      }).length,
    );
  }

  bool _isVisibleFromOutside(int row, int column, Matrix<int> matrix) {
    final theRow = matrix.rows.elementAt(row);
    final theColumn = matrix.columns.elementAt(column);

    final height = matrix.at(row, column);

    return theRow.take(column).every((e) => e < height) ||
        theRow.skip(column + 1).every((e) => e < height) ||
        theColumn.take(row).every((e) => e < height) ||
        theColumn.skip(row + 1).every((e) => e < height);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return .new(
      inputData.matrix.indexes.map((t) {
        final (:row, :column) = t;
        return _calculateScenicScore(row, column, inputData.matrix);
      }).max,
    );
  }

  int _calculateScenicScore(int row, int column, Matrix<int> matrix) {
    if (row == 0 ||
        column == 0 ||
        row == matrix.rowCount - 1 ||
        column == matrix.columnCount - 1) {
      return 0;
    }

    final theRow = matrix.rows.elementAt(row);
    final theColumn = matrix.columns.elementAt(column);

    final left = theRow.take(column).toList().reversed;
    final right = theRow.skip(column + 1);
    final up = theColumn.take(row).toList().reversed;
    final down = theColumn.skip(row + 1);

    bool test(int e) => e < matrix.at(row, column);

    final leftScore = switch (left.every(test)) {
      true => left.length,
      false => left.takeWhile(test).length + 1,
    };
    final rightScore = switch (right.every(test)) {
      true => right.length,
      false => right.takeWhile(test).length + 1,
    };
    final upScore = switch (up.every(test)) {
      true => up.length,
      false => up.takeWhile(test).length + 1,
    };
    final downScore = switch (down.every(test)) {
      true => down.length,
      false => down.takeWhile(test).length + 1,
    };

    return leftScore * rightScore * upScore * downScore;
  }
}
