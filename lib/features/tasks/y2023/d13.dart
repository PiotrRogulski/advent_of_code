import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<List<String>>;
typedef _O = NumericOutput<int>;

class Y2023D13 extends DayData<_I> {
  const Y2023D13() : super(2023, 13, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData.split('\n\n').map((e) => e.split('\n').toList()).toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(inputData.values.map(_findReflection).sum);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(
      inputData.values
          .map((e) => _findReflection(e, allowMismatches: true))
          .sum,
    );
  }
}

int? _findReflectionInDim(List<String> input, {bool allowMismatches = false}) {
  final columnCount = input.first.length;

  return 0.to(columnCount - 1).firstWhereOrNull((col1) {
    final mismatches = 0.to(columnCount).map((col2) {
      final a = col1 - col2;
      final b = col1 + 1 + col2;
      if (a < 0 || b >= columnCount) {
        return 0;
      }
      return input.where((row) => row[a] != row[b]).length;
    }).sum;
    return mismatches == (allowMismatches ? 1 : 0);
  });
}

int _findReflection(List<String> input, {bool allowMismatches = false}) {
  final vertical = _findReflectionInDim(
    input,
    allowMismatches: allowMismatches,
  );
  if (vertical != null) {
    return vertical + 1;
  }

  final horizontal = _findReflectionInDim(
    input.map((l) => l.characters).zip().map((e) => e.join()).toList(),
    allowMismatches: allowMismatches,
  );
  if (horizontal != null) {
    return 100 * (horizontal + 1);
  }

  throw StateError('No reflection found');
}
