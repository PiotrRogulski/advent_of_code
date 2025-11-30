import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef _I = ListInput<String>;
typedef _O = NumericOutput<int>;

class Y2022D3 extends DayData<_I> {
  const Y2022D3() : super(2022, 3, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(rawData.split('\n'));
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map((s) => (s.substring(0, s.length ~/ 2), s.substring(s.length ~/ 2)))
        .map((t) => (t.$1.characters.toSet(), t.$2.characters.toSet()))
        .map((t) => (t.$1 & t.$2).first)
        .map(_charValue)
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .slices(3)
        .map(
          (l) => l
              .map((s) => s.characters.toSet())
              .reduce((acc, e) => acc & e)
              .single,
        )
        .map(_charValue)
        .sum,
  );
}

int _charValue(String c) => switch ((
  c.compareTo('A') * c.compareTo('Z'),
  c.compareTo('a') * c.compareTo('z'),
)) {
  (<= 0, _) => c.codeUnitAt(0) - 'A'.codeUnitAt(0) + 27,
  (_, <= 0) => c.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1,
  _ => throw ArgumentError.value(c, 'c', 'Not a letter'),
};
