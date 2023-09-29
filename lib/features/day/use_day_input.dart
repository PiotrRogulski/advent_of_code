import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

I? useDayInput<I extends PartInput>(DayData<I> dayData) {
  final path = 'assets/inputs/y${dayData.year}/d${dayData.day}.txt';
  final rawInputData = useFuture(
    useMemoized(() => rootBundle.loadString(path), [dayData.year, dayData.day]),
  ).data;

  return switch (rawInputData) {
    final data? => dayData.parseInput(data),
    null => null,
  };
}
