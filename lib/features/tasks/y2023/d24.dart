import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:dio/dio.dart';
import 'package:more/more.dart';
import 'package:vector_math/vector_math_64.dart';

typedef _Hailstone = ({Vector3 position, Vector3 velocity});

typedef _I = ListInput<_Hailstone>;
typedef _O = NumericOutput<int>;

class Y2023D24 extends DayData<_I> {
  const Y2023D24() : super(2023, 24, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return .new(
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
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return .new(
      inputData.values
          .permutations(2)
          .where((l) => l.first < l.last)
          .where((e) => !_xyParallel(e.first.velocity.xy, e.last.velocity.xy))
          .map((l) => (l: l, t: _intersectT(l.first, l.last)))
          .where((e) => e.t.x > 0 && e.t.y > 0)
          .map((e) => (e.l.first.position + e.l.first.velocity * e.t.x).xy)
          .where(
            (v) => v.x >= 2e14 && v.x <= 4e14 && v.y >= 2e14 && v.y <= 4e14,
          )
          .length,
    );
  }
}

/// Part 2 was solved in Mathematica and deployed as a cloud function:
/// ```wolfram
/// Total[({xR, yR, zR} /. Solve[{
///   {xR, yR, zR} + {dxR, dyR, dzR} * t1 == {#x1, #y1, #z1} + {#dx1, #dy1, #dz1} * t1,
///   {xR, yR, zR} + {dxR, dyR, dzR} * t2 == {#x2, #y2, #z2} + {#dx2, #dy2, #dz2} * t2,
///   {xR, yR, zR} + {dxR, dyR, dzR} * t3 == {#x3, #y3, #z3} + {#dx3, #dy3, #dz3} * t3
/// }, {xR, yR, zR, dxR, dyR, dzR, t1, t2, t3}])[[1]]]&
/// ```
class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  Future<_O> runInternal(_I inputData) async {
    final dio = Dio();
    final r = await dio.get<String>(
      'https://www.wolframcloud.com/obj/79cacc8c-941c-488d-abf7-3c36b517095c',
      queryParameters: {
        'x1': inputData.values[0].position.x,
        'y1': inputData.values[0].position.y,
        'z1': inputData.values[0].position.z,
        'x2': inputData.values[1].position.x,
        'y2': inputData.values[1].position.y,
        'z2': inputData.values[1].position.z,
        'x3': inputData.values[2].position.x,
        'y3': inputData.values[2].position.y,
        'z3': inputData.values[2].position.z,
        'dx1': inputData.values[0].velocity.x,
        'dy1': inputData.values[0].velocity.y,
        'dz1': inputData.values[0].velocity.z,
        'dx2': inputData.values[1].velocity.x,
        'dy2': inputData.values[1].velocity.y,
        'dz2': inputData.values[1].velocity.z,
        'dx3': inputData.values[2].velocity.x,
        'dy3': inputData.values[2].velocity.y,
        'dz3': inputData.values[2].velocity.z,
      },
    );
    return .new(.parse(r.data!));
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
