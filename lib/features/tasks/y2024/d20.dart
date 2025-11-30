import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart' hide IndexedIterableExtension;

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2024D20 extends DayData<_I> {
  const Y2024D20() : super(2024, 20, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map((l) => l.split('').map(_Tile.fromSymbol).toList())
        .toList(),
    dense: true,
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    _findCheats(
      inputData.matrix,
      dijkstraSearch(
        startVertices: [inputData.matrix.start],
        successorsOf: inputData.matrix.successorsOf,
        targetPredicate: inputData.matrix.isEnd,
      ).last,
    ).count((e) => e.savedTime >= 100),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static const toSave = 100;
  static const cheatLength = 20;

  @override
  _O runInternal(_I inputData) => _O(
    dijkstraSearch(
      startVertices: [inputData.matrix.start],
      successorsOf: inputData.matrix.successorsOf,
      targetPredicate: inputData.matrix.isEnd,
    ).last.vertices.apply(
      (path) => path
          .skipLast(toSave)
          .expandIndexed(
            (i, v) => path
                .skip(i + toSave)
                .whereIndexed(
                  (j, u) => (u - v)
                      .apply((d) => d.dc.abs() + d.dr.abs())
                      .apply((dist) => dist <= cheatLength && dist <= j),
                ),
          )
          .length,
    ),
  );
}

enum _Tile {
  track('.'),
  wall('#'),
  start('S'),
  end('E');

  const _Tile(this.symbol);
  factory _Tile.fromSymbol(String symbol) =>
      values.firstWhere((tile) => tile.symbol == symbol);

  final String symbol;

  @override
  String toString() => symbol;
}

typedef _Ix = MatrixIndex;

Iterable<({_Ix cheatIndex, int savedTime})> _findCheats(
  Matrix<_Tile> map,
  Path<_Ix, num> path,
) {
  ({_Ix cheatIndex, int savedTime})? tryGetCheat(_Ix index, _Ix n1, _Ix n2) =>
      switch ((n1, n2).mapBoth(path.vertices.maybeIndexOf)) {
        (final ix1?, final ix2?)
            when map.isWalkable(n1) && map.isWalkable(n2) =>
          (cheatIndex: index, savedTime: ((ix1 - ix2).abs() - 2)),
        _ => null,
      };

  return [
    for (final c in map.cells.where((c) => c.value == _Tile.wall)) ...[
      tryGetCheat(c.index, c.index.up, c.index.down),
      tryGetCheat(c.index, c.index.left, c.index.right),
    ],
  ].nonNulls;
}

extension on Matrix<_Tile> {
  MatrixIndex get start =>
      cells.firstWhere((c) => c.value == _Tile.start).index;

  bool isEnd(MatrixIndex index) => atIndex(index) == _Tile.end;

  Iterable<MatrixIndex> successorsOf(MatrixIndex index) => [
    index.up,
    index.down,
    index.left,
    index.right,
  ].where((v) => isIndexInBounds(v) && atIndex(v) != _Tile.wall);

  bool isWalkable(MatrixIndex index) => switch (maybeAtIndex(index)) {
    null || _Tile.wall => false,
    _ => true,
  };
}
