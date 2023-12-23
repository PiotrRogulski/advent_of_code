import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ListInput<List<int>>;
typedef _O = NumericOutput<int>;

class Y2022D1 extends DayData<_I> {
  const Y2022D1() : super(2022, 1, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n\n')
          .map((e) => e.split('\n').map(int.parse).toList())
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values.map((e) => e.sum).max,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values.map((e) => e.sum).sortedBy<num>((e) => -e).take(3).sum,
    );
  }
}
