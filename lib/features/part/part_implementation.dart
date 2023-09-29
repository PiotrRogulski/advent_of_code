import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/foundation.dart';

abstract class PartImplementation<I extends PartInput, O extends PartOutput> {
  const PartImplementation();

  bool get completed;

  @protected
  O runInternal(I inputData);

  @nonVirtual
  Future<({O data, Duration runDuration})> run(I data) async {
    final stopwatch = Stopwatch()..start();
    final result = await compute(runInternal, data);
    stopwatch.stop();
    return (
      data: result,
      runDuration: stopwatch.elapsed,
    );
  }
}
