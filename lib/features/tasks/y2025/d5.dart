import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ObjectInput<({List<(int, int)> ranges, List<int> ingredients})>;
typedef _O = NumericOutput<int>;

class Y2025D5 extends DayData<_I> {
  const Y2025D5() : super(2025, 5, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (l) => (
            ranges: l.first
                .split('\n')
                .map(
                  (l) => l
                      .split('-')
                      .map(int.parse)
                      .toList()
                      .apply(Tuple2.fromList),
                )
                .toList(),
            ingredients: l.last.split('\n').map(int.parse).toList(),
          ),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.ingredients.count(
      (i) => inputData.value.ranges.any((r) => r.$1 <= i && i <= r.$2),
    ),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.ranges
        .apply(_combineRanges)
        .map((r) => r.$2 - r.$1 + 1)
        .sum,
  );

  List<(int, int)> _combineRanges(List<(int, int)> ranges) {
    final sorted = ranges.sortedBy((e) => e.$1);
    final result = <(int, int)>[];
    var current = sorted.first;
    for (final next in sorted.skip(1)) {
      if (next.$1 <= current.$2) {
        current = (current.$1, max(current.$2, next.$2));
      } else {
        result.add(current);
        current = next;
      }
    }
    result.add(current);
    return result;
  }
}
