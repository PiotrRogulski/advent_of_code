import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:mobx/mobx.dart';

part 'part_status_store.g.dart';

class PartStatusStore = _PartStatusStore with _$PartStatusStore;

abstract class _PartStatusStore with Store {
  _PartStatusStore({
    required this.part,
    required this.data,
  });

  final PartImplementation part;
  final PartInput data;

  @readonly
  var _running = false;

  @readonly
  PartOutput? _output;

  @action
  Future<void> run() async {
    _running = true;
    _output = await part.run(data);
    _running = false;
  }
}
