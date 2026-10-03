import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

class const _Position({required final int x, required final int y}) {
  _Position operator +(_Velocity other) =>
      .new(x: x + other.dx, y: y + other.dy);

  _Position ensureInBounds(({int width, int height}) bounds) => .new(
    x: (x % bounds.width + bounds.width) % bounds.width,
    y: (y % bounds.height + bounds.height) % bounds.height,
  );
}

class const _Velocity({required final int dx, required final int dy}) {
  _Velocity operator *(int other) => .new(dx: dx * other, dy: dy * other);
}

class const _Robot({
  required final _Position position,
  required final _Velocity velocity,
});

typedef _I = ListInput<_Robot>;
typedef _O = NumericOutput<int>;

class const Y2024D14() extends DayData<_I> {
  this : super(2024, 14, parts: const {1: _P1(), 2: _P2()});

  static final robotRegex = RegExp(
    r'p=(?<px>\d+),(?<py>\d+) v=(?<vx>([\d\-])+),(?<vy>([\d\-])+)',
  );

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(robotRegex.firstMatch)
        .nonNulls
        .map(
          (m) => _Robot(
            position: .new(
              x: .parse(m.namedGroup('px')!),
              y: .parse(m.namedGroup('py')!),
            ),
            velocity: .new(
              dx: .parse(m.namedGroup('vx')!),
              dy: .parse(m.namedGroup('vy')!),
            ),
          ),
        )
        .toList(),
  );
}

const _boardSize = (width: 101, height: 103);

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map((r) => (r.position + r.velocity * 100).ensureInBounds(_boardSize))
        .groupListsBy<_Quadrant>(
          (p) => switch ((
            p.x.compareTo(_boardSize.width ~/ 2),
            p.y.compareTo(_boardSize.height ~/ 2),
          )) {
            (< 0, < 0) => .topLeft,
            (> 0, < 0) => .topRight,
            (< 0, > 0) => .bottomLeft,
            (> 0, > 0) => .bottomRight,
            _ => .none,
          },
        )
        .entries
        .whereNot((e) => e.key == .none)
        .map((e) => e.value.length)
        .product,
  );
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    1
        .iterate((n) => n + 1)
        .map(
          (i) => (
            i: i,
            counts: inputData.values
                .map(
                  (r) =>
                      (r.position + r.velocity * i).ensureInBounds(_boardSize),
                )
                .toMultiset()
                .elementCounts
                .toSet(),
          ),
        )
        .firstWhere((s) => s.counts.length == 1 && s.counts.single == 1)
        .i,
  );
}

enum _Quadrant() {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  none,
}
