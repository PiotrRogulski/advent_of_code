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
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n\n')
        .apply(
          (p) => (
            map: Matrix.fromList(
              p.first
                  .split('\n')
                  .map((l) => l.split('').map(_Entity.fromSymbol).toList())
                  .toList(),
            ),
            moves:
                p.last
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
  _O runInternal(_I inputData) => _O(
    inputData.value.moves
        .fold(inputData.value.map.copy(), _performMove)
        .cells
        .where((c) => c.value == _Entity.box)
        .map((c) => c.index.row * 100 + c.index.column)
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.value.moves
        .fold(
          Matrix.fromList([
            for (final row in inputData.value.map.rows)
              [
                for (final c in row)
                  ...switch (c) {
                    _Entity.box => [_Entity2.boxL, _Entity2.boxR],
                    _Entity.robot => [_Entity2.robot, _Entity2.empty],
                    _Entity.empty => [_Entity2.empty, _Entity2.empty],
                    _Entity.wall => [_Entity2.wall, _Entity2.wall],
                  },
              ],
          ]),
          _performMove2,
        )
        .cells
        .where((c) => c.value == _Entity2.boxL)
        .map((c) => c.index.row * 100 + c.index.column)
        .sum,
  );
}

Matrix<_Entity> _performMove(Matrix<_Entity> map, _Move move) {
  final robotIx = map.cells.firstWhere((c) => c.value == _Entity.robot).index;

  final rowCount = map.rowCount;
  final columnCount = map.columnCount;

  final cellsInLine = switch (move) {
    _Move.right => map.rows[robotIx.row].skip(robotIx.column + 1),
    _Move.left => map.rows[robotIx.row].reversed.skip(
      columnCount - robotIx.column,
    ),
    _Move.down => map.columns[robotIx.column].skip(robotIx.row + 1),
    _Move.up => map.columns[robotIx.column].reversed.skip(
      rowCount - robotIx.row,
    ),
  }.takeWhile((c) => c != _Entity.wall);

  if (cellsInLine.isEmpty || cellsInLine.every((c) => c == _Entity.box)) {
    return map;
  }

  final cellsToMove = cellsInLine.takeUntil((c) => c == _Entity.empty);

  if (cellsToMove.first == _Entity.empty) {
    return map
      ..setIndex(robotIx, _Entity.empty)
      ..setIndex(robotIx + move.diff, _Entity.robot);
  }

  return map
    ..setIndex(robotIx + move.diff * cellsToMove.length, _Entity.box)
    ..setIndex(robotIx + move.diff, _Entity.robot)
    ..setIndex(robotIx, _Entity.empty);
}

Matrix<_Entity2> _performMove2(Matrix<_Entity2> map, _Move move) {
  final robot = map.cells.firstWhere((c) => c.value == _Entity2.robot).index;
  final dir = move.diff;

  if (move case _Move.left || _Move.right) {
    final box = robot
        .iterate((r) => r + dir)
        .skip(1)
        .firstWhere(
          (r) => ![_Entity2.boxL, _Entity2.boxR].contains(map.atIndex(r)),
        );
    if (map.atIndex(box) == _Entity2.empty) {
      var push = box + (-move.diff);
      while (push != robot) {
        map
          ..setIndex(push + dir, map.atIndex(push))
          ..setIndex(push, _Entity2.empty);
        push += -dir;
      }
      map
        ..setIndex(robot + dir, _Entity2.robot)
        ..setIndex(robot, _Entity2.empty);
    }
  } else {
    final box = robot + dir;
    switch (map.atIndex(box)) {
      case _Entity2.boxL || _Entity2.boxR when _canPush(map, box, dir):
        _push(map, box, dir);
        map
          ..setIndex(robot + dir, _Entity2.robot)
          ..setIndex(robot, _Entity2.empty);
      case _Entity2.empty:
        map
          ..setIndex(robot + dir, _Entity2.robot)
          ..setIndex(robot, _Entity2.empty);
      default:
    }
  }

  return map;
}

bool _canPush(Matrix<_Entity2> map, MatrixIndex box, MatrixIndexDelta dir) {
  final side = switch (map.atIndex(box)) {
    _Entity2.boxL => box + (dr: 0, dc: 1),
    _Entity2.boxR => box + (dr: 0, dc: -1),
    _ => throw Exception(),
  };

  final canPush1 = switch (map.atIndex(box + dir)) {
    _Entity2.empty => true,
    _Entity2.boxL || _Entity2.boxR => _canPush(map, box + dir, dir),
    _ => false,
  };
  final canPush2 = switch (map.atIndex(side + dir)) {
    _Entity2.empty => true,
    _Entity2.boxL || _Entity2.boxR => _canPush(map, side + dir, dir),
    _ => false,
  };

  return canPush1 && canPush2;
}

void _push(Matrix<_Entity2> map, MatrixIndex box, MatrixIndexDelta dir) {
  final side = switch (map.atIndex(box)) {
    _Entity2.boxL => box + (dr: 0, dc: 1),
    _Entity2.boxR => box + (dr: 0, dc: -1),
    _ => throw Exception(),
  };

  if (map.atIndex(box + dir) case _Entity2.boxL || _Entity2.boxR) {
    _push(map, box + dir, dir);
  }
  if (map.atIndex(side + dir) case _Entity2.boxL || _Entity2.boxR) {
    _push(map, side + dir, dir);
  }

  map
    ..setIndex(box + dir, map.atIndex(box))
    ..setIndex(side + dir, map.atIndex(side))
    ..setIndex(box, _Entity2.empty)
    ..setIndex(side, _Entity2.empty);
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
