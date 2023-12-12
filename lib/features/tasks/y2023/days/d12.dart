import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

typedef _SpringRecord = ({List<_Part> parts, List<int> damaged});

typedef _I = ListInput<_SpringRecord>;
typedef _O = NumericOutput<int>;

class Y2023D12 extends DayData<_I> {
  const Y2023D12() : super(year: 2023, day: 12);

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map((l) => l.split(' '))
          .map(
            (l) => (
              parts: l.first.split('').map(_Part.fromSymbol).toList(),
              damaged: l.last.split(',').map(int.parse).toList(),
            ),
          )
          .toList(),
    );
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
    return _O(
      inputData.values.map((e) => _s(e.parts.join(), null, e.damaged)).sum,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(
      inputData.values
          .map(
            (e) => _s(
              IterableX.generate(5, (_) => e.parts)
                  .intersperse([_Part.unknown])
                  .flattened
                  .join(),
              null,
              IterableX.generate(5, (_) => e.damaged).flattened.toList(),
            ),
          )
          .sum,
    );
  }
}

enum _Part {
  ok('.'),
  damaged('#'),
  unknown('?');

  const _Part(this.symbol);
  factory _Part.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}

final _memo = <(String, int?, String), int>{};

int _s(String s, int? currentRun, List<int> remain) {
  if (_memo[(s, currentRun, remain.join())] case final memoized?) {
    return memoized;
  }
  if (s.isEmpty) {
    return switch ((currentRun, remain)) {
      (null, []) => 1,
      (final withinRun?, [final remain]) when withinRun == remain => 1,
      _ => 0,
    };
  }
  final possible = s.characters
      .where((e) => e == _Part.damaged.symbol || e == _Part.unknown.symbol)
      .length;
  if ((currentRun != null &&
          (remain.isEmpty || possible + currentRun < remain.sum)) ||
      (currentRun == null && possible < remain.sum)) {
    return 0;
  }

  if (s[0] == _Part.ok.symbol &&
      currentRun != null &&
      currentRun != remain[0]) {
    return 0;
  }

  final first = s[0];
  final rest = s.substring(1);

  final ret = [
    if (first == _Part.ok.symbol && currentRun != null)
      _s(rest, null, remain.sublist(1)),
    if (first == _Part.unknown.symbol &&
        currentRun != null &&
        currentRun == remain[0])
      _s(rest, null, remain.sublist(1)),
    if ((first == _Part.damaged.symbol || first == _Part.unknown.symbol) &&
        currentRun != null)
      _s(rest, currentRun + 1, remain),
    if ((first == _Part.damaged.symbol || first == _Part.unknown.symbol) &&
        currentRun == null)
      _s(rest, 1, remain),
    if ((first == _Part.unknown.symbol || first == _Part.ok.symbol) &&
        currentRun == null)
      _s(rest, null, remain),
  ].sum;

  _memo[(s, currentRun, remain.join())] = ret;
  return ret;
}
