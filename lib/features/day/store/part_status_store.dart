import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:dispose_scope/dispose_scope.dart';
import 'package:rxdart/rxdart.dart';

class PartStatusStore {
  PartStatusStore({required this.part}) {
    _running.disposedBy(_scope);
    _runs.disposedBy(_scope);
  }

  final PartImplementation part;

  final _running = BehaviorSubject.seeded(false);
  ValueStream<bool> get running => _running.stream;

  final _runs = BehaviorSubject.seeded(<RunInfo>[]);
  ValueStream<List<RunInfo>> get runs => _runs.stream;

  final _scope = DisposeScope();

  Future<void> run(PartInput data) async {
    _running.add(true);
    final result = await part.run(data);
    _runs.add([result, ..._runs.value]);
    _running.add(false);
  }

  Future<void> dispose() => _scope.dispose();
}
