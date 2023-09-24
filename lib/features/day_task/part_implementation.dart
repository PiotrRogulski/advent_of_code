import 'package:advent_of_code/features/day_task/part_input.dart';
import 'package:advent_of_code/features/day_task/part_output.dart';

abstract class PartImplementation<I extends PartInput, O extends PartOutput> {
  const PartImplementation(this.inputData);

  final I inputData;

  O run();
}
