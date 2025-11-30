import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef _Lens = ({String label, int focal});

typedef _I = ListInput<String>;
typedef _O = NumericOutput<int>;

class Y2023D15 extends DayData<_I> {
  const Y2023D15() : super(2023, 15, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return .new(rawData.split(','));
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return .new(inputData.values.map(_hash).sum);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static final _lensRegex = RegExp(r'^(?<label>\w+)(?:-|=(?<focal>\d+))$');

  @override
  _O runInternal(_I inputData) {
    return .new(
      inputData.values
          .fold(Map.fromEntries(.generate(256, (i) => .new(i, <_Lens>[]))), (
            acc,
            e,
          ) {
            final m = _lensRegex.firstMatch(e)!;
            final label = m.namedGroup('label')!;
            final lenses = acc[_hash(label)]!;
            final i = lenses.indexWhere((e) => e.label == label);
            if (m.namedGroup('focal') case final focal?) {
              final lens = (label: label, focal: int.parse(focal));
              if (i != -1) {
                lenses[i] = lens;
              } else {
                lenses.add(lens);
              }
            } else {
              if (i != -1) {
                lenses.removeAt(i);
              }
            }
            return acc;
          })
          .entries
          .expand(
            (e) =>
                e.value.mapIndexed((i, l) => (e.key + 1) * (i + 1) * l.focal),
          )
          .sum,
    );
  }
}

int _hash(String s) {
  return s.characters.fold<int>(
    0,
    (value, element) => (value + element.codeUnitAt(0)) * 17 % 256,
  );
}
