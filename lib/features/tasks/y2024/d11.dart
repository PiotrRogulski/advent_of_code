import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ListInput<int>;
typedef _O = NumericOutput<int>;

class Y2024D11 extends DayData<_I> {
  const Y2024D11() : super(2024, 11, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      .new(rawData.split(' ').map(int.parse).toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.values.map(_blink.bind1(25)).sum);
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.values.map(_blink.bind1(75)).sum);
}

final _memo = <(int, int), int>{};

int _blink(int value, int count) {
  if (count < 1) {
    return 1;
  }

  return _memo.putIfAbsent(
    (value, count),
    () => switch (value.toString()) {
      '0' => _blink(1, count - 1),
      final str && String(:final length) when length.isEven =>
        _blink(.parse(str.substring(0, length ~/ 2)), count - 1) +
            _blink(.parse(str.substring(length ~/ 2)), count - 1),
      _ => _blink(value * 2024, count - 1),
    },
  );
}
