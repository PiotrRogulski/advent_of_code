import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _I = MatrixInput<int>;
typedef _O = NumericOutput<int>;

class Y2024D10 extends DayData<_I> {
  const Y2024D10() : super(2024, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map((l) => l.split('').map(int.parse).toList())
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .where((c) => c.value == 0)
        .expand(
          (c) => _findTrails(
            inputData.matrix,
            start: c,
          ).uniqueBy((t) => t.last.index),
        )
        .length,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .where((c) => c.value == 0)
        .expand((c) => _findTrails(inputData.matrix, start: c))
        .length,
  );
}

Iterable<Iterable<MatrixCell<int>>> _findTrails(
  Matrix<int> map, {
  required MatrixCell<int> start,
}) {
  if (start.value == 9) {
    return [
      [start],
    ];
  }

  final cellUp = map.maybeCellAtIndex(start.index + (dr: -1, dc: 0));
  final cellDown = map.maybeCellAtIndex(start.index + (dr: 1, dc: 0));
  final cellLeft = map.maybeCellAtIndex(start.index + (dr: 0, dc: -1));
  final cellRight = map.maybeCellAtIndex(start.index + (dr: 0, dc: 1));

  return [
    if (cellUp != null && cellUp.value == start.value + 1)
      for (final trail in _findTrails(map, start: cellUp)) [start, ...trail],

    if (cellDown != null && cellDown.value == start.value + 1)
      for (final trail in _findTrails(map, start: cellDown)) [start, ...trail],

    if (cellLeft != null && cellLeft.value == start.value + 1)
      for (final trail in _findTrails(map, start: cellLeft)) [start, ...trail],

    if (cellRight != null && cellRight.value == start.value + 1)
      for (final trail in _findTrails(map, start: cellRight)) [start, ...trail],
  ];
}
