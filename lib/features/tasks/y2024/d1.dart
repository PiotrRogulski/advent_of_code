import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart' hide IterableExtension;
import 'package:more/more.dart';

typedef _I = ObjectInput<(List<int>, List<int>)>;
typedef _O = NumericOutput<int>;

class Y2024D1 extends DayData<_I> {
  const Y2024D1() : super(2024, 1, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map((l) => l.split(RegExp(' +')).map(int.parse))
        .zip()
        .apply((xs) => (xs.first, xs.last)),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.value
        .apply((xs) => [xs.$1.sorted(), xs.$2.sorted()])
        .zip()
        .map((xs) => (xs.first - xs.last).abs())
        .sum
        .toInt(),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.value
        .apply((xs) => xs.$1.map((x) => x * xs.$2.count((y) => y == x)))
        .sum,
  );
}
