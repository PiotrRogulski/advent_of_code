import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/foundation.dart';

abstract class PartImplementation<I extends PartInput, O extends PartOutput> {
  const PartImplementation(this.partInfo);

  final ({int year, int day, int part}) partInfo;

  bool get completed;

  @protected
  O runInternal(I inputData);

  I parseInput(String rawData);

  @nonVirtual
  Future<O> run(I data) async {
    final result = await compute(runInternal, data);
    return result;
  }
}
