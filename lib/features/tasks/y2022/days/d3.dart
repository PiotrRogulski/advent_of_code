import 'package:advent_of_code/common/extensions/set.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef _I = ListInput<String>;
typedef _O = NumericOutput<int>;

class Y2022D3 extends DayData<_I> {
  const Y2022D3() : super(year: 2022, day: 3);

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData.trim().split('\n'),
    );
  }

  @override
  Map<int, PartImplementation<_I, _O>> get parts => {
        1: const _P1(),
        2: const _P2(),
      };
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1();

  @override
  bool get completed => true;

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .map(
            (s) => (s.substring(0, s.length ~/ 2), s.substring(s.length ~/ 2)),
          )
          .map((t) => (t.$1.characters.toSet(), t.$2.characters.toSet()))
          .map((t) => (t.$1 & t.$2).first)
          .map(_charValue(uppercaseBase: 27, lowercaseBase: 1))
          .sum,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2();

  @override
  bool get completed => true;

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .slices(3)
          .map(
            (l) => l
                .map((s) => s.characters.toSet())
                .reduce((acc, e) => acc & e)
                .single,
          )
          .map(_charValue(uppercaseBase: 27, lowercaseBase: 1))
          .sum,
    );
  }
}

int Function(String) _charValue({
  required int uppercaseBase,
  required int lowercaseBase,
}) {
  return (c) {
    return switch ((
      c.compareTo('A') * c.compareTo('Z'),
      c.compareTo('a') * c.compareTo('z'),
    )) {
      (<= 0, _) => c.codeUnitAt(0) - 'A'.codeUnitAt(0) + uppercaseBase,
      (_, <= 0) => c.codeUnitAt(0) - 'a'.codeUnitAt(0) + lowercaseBase,
      _ => throw ArgumentError.value(c, 'c', 'Not a letter'),
    };
  };
}
