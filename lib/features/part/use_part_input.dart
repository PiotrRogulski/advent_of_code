import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

I? usePartInput<I extends PartInput>(PartImplementation<I, dynamic> part) {
  final path = 'assets/inputs/y${part.partInfo.year}/d${part.partInfo.day}.txt';
  final rawInputData = useFuture(
    useMemoized(() => rootBundle.loadString(path), [part.partInfo]),
  ).data;

  return switch (rawInputData) {
    final data? => part.parseInput(data),
    null => null,
  };
}
