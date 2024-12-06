import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

typedef _Position = ({int row, int column});

class Y2024D6 extends DayData<_I> {
  const Y2024D6() : super(2024, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => MatrixInput(
    Matrix.fromList(
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
    ),
    dense: true,
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.matrix.cells
            .firstWhere((c) => c.cell == _Tile.start)
            .apply(
              (c) => (
                matrix:
                    inputData.matrix.copy()..set(c.row, c.column, _Tile.empty),
                position: (
                  position: (row: c.row, column: c.column),
                  direction: _Direction.up,
                ),
                visited: <_Position>{},
              ),
            )
            .iterate(
              (d) => (
                matrix: d.matrix,
                position: d.position
                    .apply((p) => p.position + p.direction.positionDelta)
                    .apply(
                      (nextP) => switch (d.matrix.maybeAt(
                        nextP.row,
                        nextP.column,
                      )) {
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
            .firstWhere(
              (d) =>
                  !d.matrix.isIndexInBounds(
                    d.position.position.row,
                    d.position.position.column,
                  ),
            )
            .visited
            .length -
        1,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.matrix.cells
        .firstWhere((c) => c.cell == _Tile.start)
        .apply(
          (c) => (
            matrix: inputData.matrix.copy()..set(c.row, c.column, _Tile.empty),
            position: (
              position: (row: c.row, column: c.column),
              direction: _Direction.up,
            ),
            visited: <_Position>{},
          ),
        )
        .iterate(
          (d) => (
            matrix: d.matrix,
            position: d.position
                .apply((p) => p.position + p.direction.positionDelta)
                .apply(
                  (nextP) => switch (d.matrix.maybeAt(
                    nextP.row,
                    nextP.column,
                  )) {
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
        .firstWhere(
          (d) =>
              !d.matrix.isIndexInBounds(
                d.position.position.row,
                d.position.position.column,
              ),
        )
        .visited
        .where(
          (p) =>
              inputData.matrix.isIndexInBounds(p.row, p.column) &&
              inputData.matrix.at(p.row, p.column) != _Tile.start,
        )
        .where((p) => hasLoop(p, inputData.matrix))
        .length,
  );
}

bool hasLoop(_Position newObstacle, Matrix<_Tile> matrix) {
  final initialCell = matrix.cells.firstWhere((c) => c.cell == _Tile.start);
  var position = (row: initialCell.row, column: initialCell.column);
  var direction = _Direction.up;
  final visited = <(_Position, _Direction)>{};
  while (true) {
    if (visited.contains((position, direction))) {
      return true;
    }
    visited.add((position, direction));
    if (!matrix.isIndexInBounds(position.row, position.column)) {
      return false;
    }
    final nextPosition = position + direction.positionDelta;
    final nextTile = matrix.maybeAt(nextPosition.row, nextPosition.column);
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

  _Position get positionDelta => switch (this) {
    up => (row: -1, column: 0),
    down => (row: 1, column: 0),
    left => (row: 0, column: -1),
    right => (row: 0, column: 1),
  };
}

extension on _Position {
  _Position operator +(_Position other) => (
    row: row + other.row,
    column: column + other.column,
  );
}
