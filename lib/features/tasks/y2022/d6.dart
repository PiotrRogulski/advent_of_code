import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';
import 'package:more/collection.dart';

typedef _I = RawStringInput;
typedef _O = NumericOutput<int>;

class Y2022D6 extends DayData<_I> {
  const Y2022D6() : super(2022, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return .new(rawData);
  }
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
  return .new(
    inputData.value.characters
            .window(windowSize)
            .toList()
            .indexWhere((e) => e.toSet().length == e.length) +
        windowSize,
  );
}
