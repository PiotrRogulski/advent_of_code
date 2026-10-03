import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/widgets.dart';

class const YearData(final Map<int, DayData> days, {required final int count}) {
  double get progress =>
      days.values.where((day) => day.complete || day.inProgress).length / count;

  double get completeProgress =>
      days.values.where((day) => day.complete).length / count;
}

abstract class const DayData<I extends PartInput>(
  final int year,
  final int day, {
  required final Map<int, PartImplementation<I, PartOutput>> parts,
}) {
  I parseInput(String rawData);

  bool get complete => parts.values.every((part) => part.completed);

  bool get inProgress => parts.isNotEmpty;
}

final class const DayVisualizer<I extends PartInput>({
  final Map<int, PartVisualizer<I>>? parts,
  final PartVisualizer<I>? commonVisualizer,
}) {
  PartVisualizer<I>? resolvePart(int part) => parts?[part];
}

class const PartVisualizer<I extends PartInput>(
  final Widget Function(I input) _builder,
) {
  Widget call(I input) =>
      KeyedSubtree(key: GlobalObjectKey(this), child: _builder(input));
}
