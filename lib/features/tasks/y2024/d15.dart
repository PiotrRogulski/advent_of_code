import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ObjectInput<({Matrix<_Entity> map, List<_Move> moves})>;
typedef _O = NumericOutput<int>;

class Y2024D15 extends DayData<_I> {
  const Y2024D15() : super(2024, 15, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (p) => (
            map: .fromList(
              p.first
                  .split('\n')
                  .map((l) => l.split('').map(_Entity.fromSymbol).toList())
                  .toList(),
            ),
            moves: p.last
                .replaceAll('\n', '')
                .split('')
                .map(_Move.fromSymbol)
                .toList(),
          ),
        ),
    stringifier: (d) {
      final b = StringBuffer()..writeln('Map:');
      for (final row in d.map.rows) {
        b.writeln(row.join());
      }
      b
        ..writeln()
        ..writeln('Moves:')
        ..writeln(d.moves.join());
      return b.toString();
    },
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.moves
        .fold(inputData.value.map.copy(), _performMove)
        .cells
        .where((c) => c.value == .box)
        .map((c) => c.index.row * 100 + c.index.column)
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.moves
        .fold(
          Matrix.fromList([
            for (final row in inputData.value.map.rows)
              [
                for (final c in row)
                  ...switch (c) {
                    .box => [_Entity2.boxL, _Entity2.boxR],
                    .robot => [_Entity2.robot, _Entity2.empty],
                    .empty => [_Entity2.empty, _Entity2.empty],
                    .wall => [_Entity2.wall, _Entity2.wall],
                  },
              ],
          ]),
          _performMove2,
        )
        .cells
        .where((c) => c.value == .boxL)
        .map((c) => c.index.row * 100 + c.index.column)
        .sum,
  );
}

Matrix<_Entity> _performMove(Matrix<_Entity> map, _Move move) {
  final robotIx = map.cells.firstWhere((c) => c.value == .robot).index;

  final rowCount = map.rowCount;
  final columnCount = map.columnCount;

  final cellsInLine = switch (move) {
    .right => map.rows[robotIx.row].skip(robotIx.column + 1),
    .left => map.rows[robotIx.row].reversed.skip(columnCount - robotIx.column),
    .down => map.columns[robotIx.column].skip(robotIx.row + 1),
    .up => map.columns[robotIx.column].reversed.skip(rowCount - robotIx.row),
  }.takeWhile((c) => c != .wall);

  if (cellsInLine.isEmpty || cellsInLine.every((c) => c == .box)) {
    return map;
  }

  final cellsToMove = cellsInLine.takeUntil((c) => c == .empty);

  if (cellsToMove.first == .empty) {
    return map
      ..setIndex(robotIx, .empty)
      ..setIndex(robotIx + move.diff, .robot);
  }

  return map
    ..setIndex(robotIx + move.diff * cellsToMove.length, .box)
    ..setIndex(robotIx + move.diff, .robot)
    ..setIndex(robotIx, .empty);
}

Matrix<_Entity2> _performMove2(Matrix<_Entity2> map, _Move move) {
  final robot = map.cells.firstWhere((c) => c.value == .robot).index;
  final dir = move.diff;

  if (move case .left || .right) {
    final box = robot
        .iterate((r) => r + dir)
        .skip(1)
        .firstWhere(
          (r) => ![_Entity2.boxL, _Entity2.boxR].contains(map.atIndex(r)),
        );
    if (map.atIndex(box) == .empty) {
      var push = box + (-move.diff);
      while (push != robot) {
        map
          ..setIndex(push + dir, map.atIndex(push))
          ..setIndex(push, .empty);
        push += -dir;
      }
      map
        ..setIndex(robot + dir, .robot)
        ..setIndex(robot, .empty);
    }
  } else {
    final box = robot + dir;
    switch (map.atIndex(box)) {
      case .boxL || .boxR when _canPush(map, box, dir):
        _push(map, box, dir);
        map
          ..setIndex(robot + dir, .robot)
          ..setIndex(robot, .empty);
      case .empty:
        map
          ..setIndex(robot + dir, .robot)
          ..setIndex(robot, .empty);
      default:
    }
  }

  return map;
}

bool _canPush(Matrix<_Entity2> map, MatrixIndex box, MatrixIndexDelta dir) {
  final side = switch (map.atIndex(box)) {
    .boxL => box.right,
    .boxR => box.left,
    _ => throw Exception(),
  };

  final canPush1 = switch (map.atIndex(box + dir)) {
    .empty => true,
    .boxL || .boxR => _canPush(map, box + dir, dir),
    _ => false,
  };
  final canPush2 = switch (map.atIndex(side + dir)) {
    .empty => true,
    .boxL || .boxR => _canPush(map, side + dir, dir),
    _ => false,
  };

  return canPush1 && canPush2;
}

void _push(Matrix<_Entity2> map, MatrixIndex box, MatrixIndexDelta dir) {
  final side = switch (map.atIndex(box)) {
    .boxL => box.right,
    .boxR => box.left,
    _ => throw Exception(),
  };

  if (map.atIndex(box + dir) case .boxL || .boxR) {
    _push(map, box + dir, dir);
  }
  if (map.atIndex(side + dir) case .boxL || .boxR) {
    _push(map, side + dir, dir);
  }

  map
    ..setIndex(box + dir, map.atIndex(box))
    ..setIndex(side + dir, map.atIndex(side))
    ..setIndex(box, .empty)
    ..setIndex(side, .empty);
}

enum _Entity {
  wall('#'),
  box('O'),
  robot('@'),
  empty('.');

  const _Entity(this.symbol);
  factory _Entity.fromSymbol(String symbol) =>
      values.firstWhere((e) => e.symbol == symbol);

  final String symbol;

  @override
  String toString() => symbol;
}

enum _Entity2 {
  wall('#'),
  boxL('['),
  boxR(']'),
  robot('@'),
  empty('.');

  const _Entity2(this.symbol);

  final String symbol;

  @override
  String toString() => symbol;
}

enum _Move {
  up('^'),
  down('v'),
  left('<'),
  right('>');

  const _Move(this.symbol);
  factory _Move.fromSymbol(String symbol) =>
      values.firstWhere((e) => e.symbol == symbol);

  final String symbol;

  @override
  String toString() => symbol;

  MatrixIndexDelta get diff => switch (this) {
    up => (dr: -1, dc: 0),
    down => (dr: 1, dc: 0),
    left => (dr: 0, dc: -1),
    right => (dr: 0, dc: 1),
  };
}
