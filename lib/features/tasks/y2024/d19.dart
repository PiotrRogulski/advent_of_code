import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ObjectInput<({List<String> patterns, List<String> designs})>;
typedef _O = NumericOutput<int>;

class Y2024D19 extends DayData<_I> {
  const Y2024D19() : super(2024, 19, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n\n')
        .apply(
          (p) => (patterns: p.first.split(', '), designs: p.last.split('\n')),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.value.designs.count(
      (design) => _solve(design, inputData.value.patterns) != 0,
    ),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.value.designs
        .map((design) => _solve(design, inputData.value.patterns))
        .sum,
  );
}

final _memo = <String, int>{};

int _solve(String design, List<String> patterns) => _memo.putIfAbsent(
  design,
  () => switch (design) {
    '' => 1,
    _ =>
      patterns
          .where(design.startsWith)
          .map((pattern) => _solve(design.substring(pattern.length), patterns))
          .sum,
  },
);
