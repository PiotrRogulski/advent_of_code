import 'package:advent_of_code/features/day_task/part_implementation.dart';
import 'package:advent_of_code/features/day_task/part_input.dart';
import 'package:advent_of_code/features/day_task/part_output.dart';
import 'package:meta/meta.dart';

@immutable
class AdventData {
  const AdventData({
    required this.years,
  });

  final Map<int, YearData> years;
}

@immutable
class YearData {
  const YearData({
    required this.days,
  });

  final Map<int, DayData> days;

  double get progress =>
      days.values.where((day) => day.complete || day.inProgress).length / 25;

  double get completeProgress =>
      days.values.where((day) => day.complete).length / 25;
}

@immutable
class DayData {
  const DayData({
    required this.parts,
  });

  final Map<int, PartData> parts;

  bool get complete => parts.values.every((part) => part.completed);

  bool get inProgress => parts.isNotEmpty;
}

@immutable
class PartData<I extends PartInput, O extends PartOutput> {
  const PartData({
    required this.completed,
    required this.implementationBuilder,
  });

  final bool completed;
  final PartImplementation<I, O> Function(String) implementationBuilder;
}
