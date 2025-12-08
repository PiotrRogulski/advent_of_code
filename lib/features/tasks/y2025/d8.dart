import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _JunctionBox = ({int x, int y, int z});
typedef _I = ListInput<_JunctionBox>;
typedef _O = NumericOutput<int>;

class Y2025D8 extends DayData<_I> {
  const Y2025D8() : super(2025, 8, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(
          (l) => l
              .split(',')
              .apply(
                (l) => (
                  x: int.parse(l[0]),
                  y: int.parse(l[1]),
                  z: int.parse(l[2]),
                ),
              ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_connect(inputData.values, count: 1000));

  int _connect(List<_JunctionBox> boxes, {required int count}) {
    final connected = boxes.map((b) => {b}).toSet();

    for (final [a, b] in _pairs(boxes).take(count)) {
      _mergeSets(connected, a, b);
    }

    return connected
        .sortedBy((s) => -s.length)
        .take(3)
        .map((s) => s.length)
        .product;
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_connect(inputData.values));

  int _connect(List<_JunctionBox> boxes) {
    final connected = boxes.map((b) => {b}).toSet();

    for (final [a, b] in _pairs(boxes)) {
      _mergeSets(connected, a, b);

      if (connected.length == 1) {
        return a.x * b.x;
      }
    }

    throw StateError('No solution found');
  }
}

Iterable<List<_JunctionBox>> _pairs(Iterable<_JunctionBox> boxes) =>
    boxes.combinations(2).sortedBy((p) => distSq(p.first, p.last));

void _mergeSets<T>(Set<Set<T>> sets, T a, T b) {
  final setWithA = sets.firstWhere((s) => s.contains(a));
  final setWithB = sets.firstWhere((s) => s.contains(b));

  sets
    ..remove(setWithA)
    ..remove(setWithB)
    ..add({...setWithA, ...setWithB});
}

int distSq(_JunctionBox a, _JunctionBox b) =>
    (a.x - b.x).sq + (a.y - b.y).sq + (a.z - b.z).sq;

extension on int {
  int get sq => this * this;
}
