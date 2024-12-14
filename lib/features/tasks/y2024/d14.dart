import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ListInput<_Robot>;
typedef _O = NumericOutput<int>;

typedef _Robot = ({({int x, int y}) position, ({int dx, int dy}) velocity});

class Y2024D14 extends DayData<_I> {
  const Y2024D14() : super(2024, 14, parts: const {1: _P1(), 2: _P2()});

  static final robotRegex = RegExp(
    r'p=(?<px>\d+),(?<py>\d+) v=(?<vx>(\d|-)+),(?<vy>(\d|-)+)',
  );

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map(robotRegex.firstMatch)
        .nonNulls
        .map(
          (m) => (
            position: (
              x: int.parse(m.namedGroup('px')!),
              y: int.parse(m.namedGroup('py')!),
            ),
            velocity: (
              dx: int.parse(m.namedGroup('vx')!),
              dy: int.parse(m.namedGroup('vy')!),
            ),
          ),
        )
        .toList(),
  );
}

const _boardSize = (width: 101, height: 103);

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values
        .map((r) => (r.position + r.velocity * 100).ensureInBounds(_boardSize))
        .groupListsBy(
          (p) => switch ((
            p.x.compareTo(_boardSize.width ~/ 2),
            p.y.compareTo(_boardSize.height ~/ 2),
          )) {
            (< 0, < 0) => _Quadrant.topLeft,
            (> 0, < 0) => _Quadrant.topRight,
            (< 0, > 0) => _Quadrant.bottomLeft,
            (> 0, > 0) => _Quadrant.bottomRight,
            _ => _Quadrant.none,
          },
        )
        .entries
        .whereNot((e) => e.key == _Quadrant.none)
        .map((e) => e.value.length)
        .product,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    1
        .iterate((n) => n + 1)
        .map(
          (i) => (
            i: i,
            counts:
                inputData.values
                    .map(
                      (r) => (r.position + r.velocity * i).ensureInBounds(
                        _boardSize,
                      ),
                    )
                    .toMultiset()
                    .counts
                    .toSet(),
          ),
        )
        .firstWhere((s) => s.counts.length == 1 && s.counts.single == 1)
        .i,
  );
}

extension on ({int x, int y}) {
  ({int x, int y}) operator +(({int dx, int dy}) other) => (
    x: x + other.dx,
    y: y + other.dy,
  );

  ({int x, int y}) ensureInBounds(({int width, int height}) bounds) => (
    x: (x % bounds.width + bounds.width) % bounds.width,
    y: (y % bounds.height + bounds.height) % bounds.height,
  );
}

extension on ({int dx, int dy}) {
  ({int dx, int dy}) operator *(int other) => (dx: dx * other, dy: dy * other);
}

enum _Quadrant { topLeft, topRight, bottomLeft, bottomRight, none }
