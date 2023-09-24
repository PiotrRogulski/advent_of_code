import 'package:advent_of_code/features/day_task/part_input.dart';
import 'package:advent_of_code/features/day_task/part_output.dart';
import 'package:flutter/foundation.dart';

abstract class PartImplementation<I extends PartInput, O extends PartOutput> {
  const PartImplementation();

  @protected
  O runInternal(I inputData);

  @protected
  I parseInput(String rawData);

  @nonVirtual
  Future<O> run(String rawData) async {
    final inputData = parseInput(rawData);
    final result = await compute(runInternal, inputData);
    return result;
  }
}
