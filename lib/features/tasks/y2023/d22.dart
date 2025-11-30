import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';

typedef _Brick = ({
  _Coord from,
  _Coord to,
  List<int> supports,
  List<int> supportedBy,
});
typedef _Coord = ({int x, int y, int z});

typedef _I = ListInput<_Brick>;
typedef _O = NumericOutput<int>;

class Y2023D22 extends DayData<_I> {
  const Y2023D22() : super(2023, 22, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map((l) => l.split('~'))
          .map(
            (l) => (
              from: l.first
                  .split(',')
                  .map(int.parse)
                  .toList()
                  .apply((l) => (x: l[0], y: l[1], z: l[2])),
              to: l.last
                  .split(',')
                  .map(int.parse)
                  .toList()
                  .apply((l) => (x: l[0], y: l[1], z: l[2])),
              supports: <int>[],
              supportedBy: <int>[],
            ),
          )
          .sortedBy((b) => b.from.z)
          .fold((bricks: <_Brick>[], maxZReached: 1), (acc, brick) {
            final diff = brick.to.z - brick.from.z;
            brick = (
              from: brick.from.apply(
                (c) => (x: c.x, y: c.y, z: acc.maxZReached + 1),
              ),
              to: brick.to.apply(
                (c) => (x: c.x, y: c.y, z: acc.maxZReached + 1 + diff),
              ),
              supports: brick.supports,
              supportedBy: brick.supportedBy,
            );

            while (true) {
              var canMoveDown = true;

              brick = (
                from: brick.from.apply((c) => (x: c.x, y: c.y, z: c.z - 1)),
                to: brick.to.apply((c) => (x: c.x, y: c.y, z: c.z - 1)),
                supports: brick.supports,
                supportedBy: brick.supportedBy,
              );

              for (final i in 0.to(acc.bricks.length).reversed) {
                if (acc.bricks[i].to.z < brick.from.z) {
                  continue;
                }
                final collision = _hasCollision(brick, acc.bricks[i]);
                if (collision) {
                  canMoveDown = false;
                  final len = acc.bricks.length;
                  acc.bricks[i].supports.add(len);
                  brick.supportedBy.add(i);
                }
              }

              if (!canMoveDown) {
                brick = (
                  from: brick.from.apply((c) => (x: c.x, y: c.y, z: c.z + 1)),
                  to: brick.to.apply((c) => (x: c.x, y: c.y, z: c.z + 1)),
                  supports: brick.supports,
                  supportedBy: brick.supportedBy,
                );
                break;
              }

              if (brick.from.z == 1) {
                break;
              }
            }

            final newMaxZReached = max(acc.maxZReached, brick.to.z);
            return (
              bricks: acc.bricks..add(brick),
              maxZReached: newMaxZReached,
            );
          })
          .bricks,
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final bricks = inputData.values;
    return _O(
      bricks.count(
        (b) => b.supports.every((i) => bricks[i].supportedBy.length > 1),
      ),
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final bricks = inputData.values;
    return _O(
      bricks.mapIndexed((i, b) {
        if (b.supports.isEmpty) {
          return 0;
        }

        final fallenIndexes = <int>{};
        final q = PriorityQueue<({int prio, int z})>(
          naturalComparable<num>.keyOf((e) => e.prio),
        )..add((prio: i, z: b.to.z));

        while (q.isNotEmpty) {
          final idx = q.removeFirst().prio;
          fallenIndexes.add(idx);
          for (final supportedIdx in bricks[idx].supports) {
            final supportedBrick = bricks[supportedIdx];
            if (supportedBrick.supportedBy.every(fallenIndexes.contains)) {
              q.add((prio: supportedIdx, z: supportedBrick.to.z));
            }
          }
        }

        return fallenIndexes.length - 1;
      }).sum,
    );
  }
}

extension on _Brick {
  Iterable<_Coord> get cubes sync* {
    for (var x = from.x; x <= to.x; x++) {
      for (var y = from.y; y <= to.y; y++) {
        for (var z = from.z; z <= to.z; z++) {
          yield (x: x, y: y, z: z);
        }
      }
    }
  }
}

bool _hasCollision(_Brick a, _Brick b) {
  final aCubes = a.cubes.toSet();
  final bCubes = b.cubes.toSet();
  return aCubes.intersection(bCubes).isNotEmpty;
}
