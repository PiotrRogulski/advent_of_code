import 'dart:io';
import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart' hide IndexedIterableExtension;
import 'package:vector_math/vector_math_64.dart';
import 'package:z3/z3.dart';

typedef _Hailstone = ({Vector3 position, Vector3 velocity});

typedef _I = ListInput<_Hailstone>;
typedef _O = NumericOutput<int>;

class Y2023D24 extends DayData<_I> {
  const Y2023D24() : super(2023, 24, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(
          (l) => l
              .split(' @ ')
              .map(
                (e) => e
                    .split(', ')
                    .map(double.parse)
                    .toList()
                    .apply(Tuple3.fromList),
              ),
        )
        .map(
          (l) => (
            position: Vector3(l.first.$1, l.first.$2, l.first.$3),
            velocity: Vector3(l.last.$1, l.last.$2, l.last.$3),
          ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .permutations(2)
        .where((l) => l.first < l.last)
        .where((e) => !_xyParallel(e.first.velocity.xy, e.last.velocity.xy))
        .map((l) => (l: l, t: _intersectT(l.first, l.last)))
        .where((e) => e.t.x > 0 && e.t.y > 0)
        .map((e) => (e.l.first.position + e.l.first.velocity * e.t.x).xy)
        .where((v) => v.x >= 2e14 && v.x <= 4e14 && v.y >= 2e14 && v.y <= 4e14)
        .length,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    if (Platform.isMacOS) {
      libz3Override = .open('libz3.4.15.4.0.dylib');
    }

    final sol = solver();

    final xR = constVar('xR', intSort);
    final yR = constVar('yR', intSort);
    final zR = constVar('zR', intSort);
    final dxR = constVar('dxR', intSort);
    final dyR = constVar('dyR', intSort);
    final dzR = constVar('dzR', intSort);

    for (final (rI, r) in inputData.values.take(3).indexed) {
      final t = constVar('t$rI', intSort);
      for (final (i, (pos, vel)) in [(xR, dxR), (yR, dyR), (zR, dzR)].indexed) {
        sol.add(
          eq(
            pos + vel * t,
            t * intFrom(r.velocity[i].toInt()) + intFrom(r.position[i].toInt()),
          ),
        );
      }
    }

    final model = sol.ensureSat();
    return .new([xR, yR, zR].map(model.evalConst).map((e) => e!.toInt()).sum);
  }
}

extension on _Hailstone {
  bool operator <(_Hailstone other) {
    final thisProps = [...position.storage, ...velocity.storage];
    final otherProps = [...other.position.storage, ...other.velocity.storage];
    for (final (thisProp, otherProp) in (thisProps, otherProps).zip()) {
      final res = thisProp.compareTo(otherProp);
      if (res != 0) {
        return res < 0;
      }
    }
    return false;
  }
}

bool _xyParallel(Vector2 a, Vector2 b) {
  final angleA = atan2(a.y, a.x) % pi;
  final angleB = atan2(b.y, b.x) % pi;
  return angleA == angleB;
}

Vector2 _intersectT(_Hailstone s1, _Hailstone s2) {
  final A = Matrix2.columns(s1.velocity.xy, -s2.velocity.xy);
  final x = Vector2.zero();
  final b = s2.position.xy - s1.position.xy;
  Matrix2.solve(A, x, b);
  return x;
}
