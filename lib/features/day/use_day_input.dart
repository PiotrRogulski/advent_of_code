import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

({I example, I full})? useDayInput<I extends PartInput>(DayData<I> dayData) {
  final examplePath = 'assets/inputs/y${dayData.year}/d${dayData.day}.example';
  final fullInputPath = 'assets/inputs/y${dayData.year}/d${dayData.day}';

  final snapshot = useFuture(
    useMemoized(
      () => (
        rootBundle
            .loadString(examplePath)
            .then((d) => compute(dayData.parseInput, d.trim())),
        rootBundle
            .loadString(fullInputPath)
            .then((d) => compute(dayData.parseInput, d.trim())),
      ).wait.then((t) => (example: t.$1, full: t.$2)),
      [dayData.year, dayData.day],
    ),
  );

  return snapshot.data;
}
