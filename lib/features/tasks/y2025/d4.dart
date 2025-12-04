import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _I = MatrixInput<String>;
typedef _O = NumericOutput<int>;

class Y2025D4 extends DayData<_I> {
  const Y2025D4() : super(2025, 4, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      .new(rawData.split('\n').map((l) => l.split('')).toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.matrix.cells
        .where(
          (c) =>
              c.value == '@' &&
              inputData.matrix
                      .neighborsOfIndex(c.index)
                      .where((c) => c.value == '@')
                      .length <
                  4,
        )
        .length,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_removeRolls(inputData.matrix));

  int _removeRolls(Matrix<String> matrix, {int removed = 0}) {
    final m = matrix.copy();

    final toRemove = m.cells
        .where(
          (c) =>
              c.value == '@' &&
              m.neighborsOfIndex(c.index).where((c) => c.value == '@').length <
                  4,
        )
        .toList();

    if (toRemove.isEmpty) {
      return removed;
    }
    for (final cell in toRemove) {
      m.setIndex(cell.index, '.');
    }
    return _removeRolls(m, removed: removed + toRemove.length);
  }
}
