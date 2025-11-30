import 'dart:async';

import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/foundation.dart';

typedef RunInfo<O extends PartOutput> = ({
  O? data,
  Duration runDuration,
  ({Object error, StackTrace stackTrace})? error,
});

abstract class PartImplementation<I extends PartInput, O extends PartOutput> {
  const PartImplementation({required this.completed});

  final bool completed;

  @protected
  FutureOr<O> runInternal(I inputData);

  @nonVirtual
  Future<RunInfo<O>> run(I data) => compute((data) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await runInternal(data);
      return (data: result, runDuration: stopwatch.elapsed, error: null);
    } catch (err, st) {
      return (
        data: null,
        runDuration: stopwatch.elapsed,
        error: (error: err, stackTrace: st),
      );
    } finally {
      stopwatch.stop();
    }
  }, data);
}
