import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef _I = ListInput<String>;
typedef _O = NumericOutput<int>;

class Y2023D1 extends DayData<_I> {
  const Y2023D1() : super(2023, 1, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData.split('\n'),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _run(
      inputData,
      (l) => l.characters.map(int.tryParse).nonNulls,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static final _digitNameRegex =
      RegExp(r'^(one|two|three|four|five|six|seven|eight|nine|ten|\d)');
  static int digitNameToNumber(String string) => switch (string) {
        'one' => 1,
        'two' => 2,
        'three' => 3,
        'four' => 4,
        'five' => 5,
        'six' => 6,
        'seven' => 7,
        'eight' => 8,
        'nine' => 9,
        _ => int.parse(string),
      };

  @override
  _O runInternal(_I inputData) {
    return _run(
      inputData,
      (l) => List.generate(
        l.length,
        (i) => _digitNameRegex.firstMatch(l.substring(i))?.group(0),
      ).nonNulls.map(digitNameToNumber),
    );
  }
}

_O _run(_I inputData, Iterable<int> Function(String line) digitExtractor) {
  return NumericOutput(
    inputData.values
        .map(digitExtractor)
        .map((numbers) => 10 * numbers.first + numbers.last)
        .sum,
  );
}
