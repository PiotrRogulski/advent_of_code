import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:collection/collection.dart';

class Y2022D1P1
    extends PartImplementation<ListInput<List<int>>, NumericOutput<int>> {
  const Y2022D1P1() : super((year: 2022, day: 1, part: 1));

  @override
  bool get completed => false;

  @override
  ListInput<List<int>> parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n\n')
          .map((e) => e.split('\n').map(int.parse).toList())
          .toList(),
    );
  }

  @override
  NumericOutput<int> runInternal(ListInput<List<int>> inputData) {
    return NumericOutput(
      inputData.values.map((e) => e.sum).max,
    );
  }
}

class Y2022D1P2
    extends PartImplementation<ListInput<List<int>>, NumericOutput<int>> {
  const Y2022D1P2() : super((year: 2022, day: 1, part: 2));

  @override
  bool get completed => false;

  @override
  ListInput<List<int>> parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n\n')
          .map((e) => e.split('\n').map(int.parse).toList())
          .toList(),
    );
  }

  @override
  NumericOutput<int> runInternal(ListInput<List<int>> inputData) {
    return NumericOutput(
      inputData.values.map((e) => e.sum).sortedBy<num>((e) => -e).take(3).sum,
    );
  }
}
