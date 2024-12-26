import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2024D6 extends DayData<_I> {
  const Y2024D6() : super(2024, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map(
          (l) =>
              l
                  .split('')
                  .map(
                    (c) => switch (c) {
                      '.' => _Tile.empty,
                      '#' => _Tile.obstacle,
                      '^' => _Tile.start,
                      _ => throw ArgumentError('Invalid tile: $c'),
                    },
                  )
                  .toList(),
        )
        .toList(),
    dense: true,
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
            .firstWhere((c) => c.value == _Tile.start)
            .apply(
              (c) => (
                matrix: inputData.matrix.copy()..setIndex(c.index, _Tile.empty),
                position: (position: c.index, direction: _Direction.up),
                visited: <MatrixIndex>{},
              ),
            )
            .iterate(
              (d) => (
                matrix: d.matrix,
                position: d.position
                    .apply((p) => p.position + p.direction.positionDelta)
                    .apply(
                      (nextP) => switch (d.matrix.maybeAtIndex(nextP)) {
                        _Tile.obstacle => (
                          position: d.position.position,
                          direction: d.position.direction.turnRight,
                        ),
                        _ => (position: nextP, direction: d.position.direction),
                      },
                    ),
                visited:
                    d.visited..add((
                      row: d.position.position.row,
                      column: d.position.position.column,
                    )),
              ),
            )
            .firstWhere((d) => !d.matrix.isIndexInBounds(d.position.position))
            .visited
            .length -
        1,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .firstWhere((c) => c.value == _Tile.start)
        .apply(
          (c) => (
            matrix: inputData.matrix.copy()..setIndex(c.index, _Tile.empty),
            position: (position: c.index, direction: _Direction.up),
            visited: <MatrixIndex>{},
          ),
        )
        .iterate(
          (d) => (
            matrix: d.matrix,
            position: d.position
                .apply((p) => p.position + p.direction.positionDelta)
                .apply(
                  (nextP) => switch (d.matrix.maybeAtIndex(nextP)) {
                    _Tile.obstacle => (
                      position: d.position.position,
                      direction: d.position.direction.turnRight,
                    ),
                    _ => (position: nextP, direction: d.position.direction),
                  },
                ),
            visited:
                d.visited..add((
                  row: d.position.position.row,
                  column: d.position.position.column,
                )),
          ),
        )
        .firstWhere((d) => !d.matrix.isIndexInBounds(d.position.position))
        .visited
        .where(
          (p) =>
              inputData.matrix.isIndexInBounds(p) &&
              inputData.matrix.atIndex(p) != _Tile.start,
        )
        .where(hasLoop.bind1(inputData.matrix))
        .length,
  );
}

bool hasLoop(MatrixIndex newObstacle, Matrix<_Tile> matrix) {
  var position = matrix.cells.firstWhere((c) => c.value == _Tile.start).index;
  var direction = _Direction.up;
  final visited = <(MatrixIndex, _Direction)>{};
  while (true) {
    if (visited.contains((position, direction))) {
      return true;
    }
    visited.add((position, direction));
    if (!matrix.isIndexInBounds(position)) {
      return false;
    }
    final nextPosition = position + direction.positionDelta;
    final nextTile = matrix.maybeAtIndex(nextPosition);
    if (nextTile == _Tile.obstacle || nextPosition == newObstacle) {
      direction = direction.turnRight;
    } else {
      position = nextPosition;
    }
  }
}

enum _Tile {
  empty,
  obstacle,
  start;

  @override
  String toString() => switch (this) {
    empty => '.',
    obstacle => '#',
    start => '^',
  };
}

enum _Direction {
  up,
  down,
  left,
  right;

  _Direction get turnRight => switch (this) {
    up => right,
    right => down,
    down => left,
    left => up,
  };

  MatrixIndexDelta get positionDelta => switch (this) {
    up => (dr: -1, dc: 0),
    down => (dr: 1, dc: 0),
    left => (dr: 0, dc: -1),
    right => (dr: 0, dc: 1),
  };
}
