import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = RawStringInput;
typedef _O = NumericOutput<int>;

class Y2024D3 extends DayData<_I> {
  const Y2024D3() : super(2024, 3, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(rawData);
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  static final _validInstructionRegex = RegExp(r'mul\((\d+),(\d+)\)');

  @override
  _O runInternal(_I inputData) => _O(
    _validInstructionRegex
        .allMatches(inputData.value)
        .map((m) => int.parse(m[1]!) * int.parse(m[2]!))
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static final _mulRegex = RegExp(r'(mul)\((\d+),(\d+)\)');
  static final _doRegex = RegExp(r'(do)\(\)');
  static final _dontRegex = RegExp(r"(don't)\(\)");

  @override
  _O runInternal(_I inputData) => _O(
    [
      ..._mulRegex.allMatches(inputData.value),
      ..._doRegex.allMatches(inputData.value),
      ..._dontRegex.allMatches(inputData.value),
    ].sortedBy((m) => m.start).fold(
      (sum: 0, enabled: true),
      (state, match) => (
        sum:
            state.sum +
            switch (match[1]) {
              'mul' when state.enabled =>
                int.parse(match[2]!) * int.parse(match[3]!),
              _ => 0,
            },
        enabled: switch (match[1]) {
          'do' => true,
          "don't" => false,
          _ => state.enabled,
        },
      ),
    ).sum,
  );
}
