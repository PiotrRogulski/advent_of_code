import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ListInput<List<int>>;
typedef _O = NumericOutput<int>;

class const Y2022D1() extends DayData<_I> {
  this : super(2022, 1, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .map((e) => e.split('\n').map(int.parse).toList())
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(inputData.values.map((e) => e.sum).max);
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.values.map((e) => e.sum).sortedBy((e) => -e).take(3).sum);
}
