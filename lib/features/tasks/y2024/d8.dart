import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<String?>;
typedef _O = NumericOutput<int>;

class Y2024D8 extends DayData<_I> {
  const Y2024D8() : super(2024, 8, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      _I(rawData.split('\n').map((l) => l.split('')).toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .groupListsBy((c) => c.value)
        .entries
        .whereNot((e) => e.key == '.')
        .map((e) => e.value)
        .expand(_findNodes)
        .toSet()
        .where(inputData.matrix.isIndexInBounds)
        .length,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .groupListsBy((c) => c.value)
        .entries
        .whereNot((e) => e.key == '.')
        .map((e) => e.value)
        .expand(
          (cells) => _findNodesUnlimited(
            cells,
            boundsChecker: inputData.matrix.isIndexInBounds,
          ),
        )
        .toSet()
        .where(inputData.matrix.isIndexInBounds)
        .length,
  );
}

Iterable<MatrixIndex> _findNodes(Iterable<MatrixCell<String?>> cells) => {
  for (final [MatrixCell(index: c1), MatrixCell(index: c2)] in cells
      .combinations(2)) ...[c1 + (c1 - c2), c2 + (c2 - c1)],
};

Iterable<MatrixIndex> _findNodesUnlimited(
  Iterable<MatrixCell<String?>> cells, {
  required Predicate1<MatrixIndex> boundsChecker,
}) => {
  for (final [MatrixCell(index: c1), MatrixCell(index: c2)] in cells
      .combinations(2)) ...[
    ...c1.iterate((c) => c + (c1 - c2)).takeWhile(boundsChecker),
    ...c2.iterate((c) => c + (c2 - c1)).takeWhile(boundsChecker),
  ],
};
