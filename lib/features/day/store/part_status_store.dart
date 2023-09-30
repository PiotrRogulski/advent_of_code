import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:mobx/mobx.dart';

part 'part_status_store.g.dart';

class PartStatusStore = _PartStatusStore with _$PartStatusStore;

abstract class _PartStatusStore with Store {
  _PartStatusStore({
    required this.part,
  });

  final PartImplementation part;

  @readonly
  var _running = false;

  final _runs = ObservableList<({PartOutput data, Duration runDuration})>();

  @computed
  List<({PartOutput data, Duration runDuration})> get runs => _runs.toList();

  @action
  Future<void> run(PartInput data) async {
    _running = true;
    final result = await part.run(data);
    _runs.insert(0, result);
    _running = false;
  }
}
