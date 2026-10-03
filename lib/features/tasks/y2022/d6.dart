import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:more/collection.dart';

typedef _I = RawStringInput;
typedef _O = NumericOutput<int>;

class const Y2022D6() extends DayData<_I> {
  this : super(2022, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(rawData);
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => _findSignal(inputData, windowSize: 4);
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => _findSignal(inputData, windowSize: 14);
}

_O _findSignal(_I inputData, {required int windowSize}) => .new(
  inputData.value.characters
          .window(windowSize)
          .toList()
          .indexWhere((e) => e.toSet().length == e.length) +
      windowSize,
);
