import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';

typedef _I = ListInput<String>;
typedef _O = NumericOutput<int>;

class Y2025D1 extends DayData<_I> {
  const Y2025D1() : super(2025, 1, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(rawData.split('\n').toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.values.fold((value: 50, count: 0), _rotate).count);

  ({int count, int value}) _rotate(({int count, int value}) acc, String e) {
    final newValue = (acc.value + e.rotation) % 100;
    return (value: newValue, count: acc.count + (newValue == 0 ? 1 : 0));
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values.expand(_expand).fold((value: 50, count: 0), _rotate).count,
  );

  Iterable<String> _expand(String e) sync* {
    final dir = e.characters.first;
    final value = int.parse(e.substring(1));
    final count = (value / 99).ceil();
    if (count == 1) {
      yield e;
      return;
    }
    final lastValue = value - 99 * (count - 1);
    yield '$dir$lastValue';
    for (var i = 0; i < count - 1; i++) {
      yield '$dir${99}';
    }
  }

  ({int count, int value}) _rotate(({int count, int value}) acc, String e) {
    final newRawValue = acc.value + e.rotation;
    final shouldCount =
        acc.value != 0 && (newRawValue >= 100 || newRawValue <= 0);
    return (value: newRawValue % 100, count: acc.count + (shouldCount ? 1 : 0));
  }
}

extension on String {
  int get rotation => switch (characters.first) {
    'L' => -int.parse(substring(1)),
    _ => int.parse(substring(1)),
  };
}
