import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/widgets.dart';

class YearData {
  const YearData(this.days, {required this.count});

  final Map<int, DayData> days;
  final int count;

  double get progress =>
      days.values.where((day) => day.complete || day.inProgress).length / count;

  double get completeProgress =>
      days.values.where((day) => day.complete).length / count;
}

abstract class DayData<I extends PartInput> {
  const DayData(this.year, this.day, {required this.parts});

  final int year;
  final int day;
  final Map<int, PartImplementation<I, PartOutput>> parts;

  I parseInput(String rawData);

  bool get complete => parts.values.every((part) => part.completed);

  bool get inProgress => parts.isNotEmpty;
}

abstract class DayVisualizer<I extends PartInput> {
  const DayVisualizer(this.year, this.day, {this.parts, this.commonVisualizer});

  final int year;
  final int day;
  final Map<int, PartVisualizer<I>>? parts;
  final PartVisualizer<I>? commonVisualizer;

  PartVisualizer<I>? resolvePart(int part) => parts?[part];
}

class PartVisualizer<I extends PartInput> {
  const PartVisualizer(this._builder);

  final Widget Function(I input) _builder;

  Widget call(I input) => _builder(input);
}
