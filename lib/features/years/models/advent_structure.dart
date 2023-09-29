import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:meta/meta.dart';

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
abstract class DayData<I extends PartInput> {
  const DayData({required this.year, required this.day});

  final int year;
  final int day;

  Map<int, PartImplementation<I, PartOutput>> get parts;

  I parseInput(String rawData);

  bool get complete => parts.values.every((part) => part.completed);

  bool get inProgress => parts.isNotEmpty;
}
