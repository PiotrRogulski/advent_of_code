import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ListInput<List<int>>;
typedef _O = NumericOutput<int>;

class Y2023D9 extends DayData<_I> {
  const Y2023D9() : super(year: 2023, day: 9);

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map((l) => l.split(' ').map(int.parse).toList())
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
    return NumericOutput(
      inputData.values
          .map(
            (l) => l
                .iterate((l) => l.diff.toList())
                .takeUntil((l) => l.every((e) => e == 0))
                .map((l) => l.last)
                .sum,
          )
          .sum,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .map(
            (l) => l
                .iterate((l) => l.diff.toList())
                .takeUntil((l) => l.every((e) => e == 0))
                .map((l) => l.first)
                .toList()
                .reversed
                .fold(0, (a, b) => b - a),
          )
          .sum,
    );
  }
}
