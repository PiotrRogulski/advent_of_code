import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart' hide IndexedIterableExtension;

typedef _I = ListInput<List<int>>;
typedef _O = NumericOutput<int>;

class Y2025D3 extends DayData<_I> {
  const Y2025D3() : super(2025, 3, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((l) => l.split('').map(int.parse).toList())
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map(
          (line) => line
              .combinations(2, repetitions: false)
              .map((e) => 10 * e[0] + e[1])
              .max,
        )
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map(
          (line) => 0.to(12).reversed.fold(
            (value: 0, start: 0),
            (acc, e) => acc.start
                .to(line.length - e)
                .fold(
                  (largest: 0, i: acc.start),
                  (acc, i) =>
                      line[i] > acc.largest ? (largest: line[i], i: i) : acc,
                )
                .apply(
                  (e) => (value: acc.value * 10 + e.largest, start: e.i + 1),
                ),
          ).value,
        )
        .sum,
  );
}
