import 'dart:async';

import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/foundation.dart';

class const RunInfo<O extends PartOutput>({
  final O? data,
  required final Duration runDuration,
  final ({Object error, StackTrace stackTrace})? error,
});

abstract class const PartImplementation<
  I extends PartInput,
  O extends PartOutput
>({required final bool completed}) {
  @protected
  FutureOr<O> runInternal(I inputData);

  @nonVirtual
  Future<RunInfo<O>> run(I data) => compute((data) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await runInternal(data);
      return .new(data: result, runDuration: stopwatch.elapsed);
    } catch (err, st) {
      return .new(
        runDuration: stopwatch.elapsed,
        error: (error: err, stackTrace: st),
      );
    } finally {
      stopwatch.stop();
    }
  }, data);
}
