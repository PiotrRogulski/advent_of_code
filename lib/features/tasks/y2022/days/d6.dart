import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';

typedef _I = RawStringInput;
typedef _O = NumericOutput<int>;

class Y2022D6 extends DayData<_I> {
  const Y2022D6() : super(year: 2022, day: 6);

  @override
  _I parseInput(String rawData) {
    return RawStringInput(rawData);
  }

  @override
  Map<int, PartImplementation<_I, _O>> get parts => {
        1: const _P1(),
        2: const _P2(),
      };
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _findSignal(inputData, windowSize: 4);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _findSignal(inputData, windowSize: 14);
  }
}

_O _findSignal(_I inputData, {required int windowSize}) {
  return NumericOutput(
    inputData.value.characters
            .windowed(windowSize)
            .toList()
            .indexWhere((e) => e.toSet().length == e.length) +
        windowSize,
  );
}
