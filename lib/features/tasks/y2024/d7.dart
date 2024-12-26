import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ListInput<({int number, List<int> operands})>;
typedef _O = NumericOutput<int>;

class Y2024D7 extends DayData<_I> {
  const Y2024D7() : super(2024, 7, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map(
          (l) => l
              .split(': ')
              .apply(
                (p) => (
                  number: int.parse(p.first),
                  operands: p.last.split(' ').map(int.parse).toList(),
                ),
              ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values
        .where(
          (x) =>
              _findSolutions(
                x.number,
                x.operands.reversed.toList(),
                allowConcatenation: false,
              ).isNotEmpty,
        )
        .map((x) => x.number)
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values
        .where(
          (x) =>
              _findSolutions(
                x.number,
                x.operands.reversed.toList(),
                allowConcatenation: true,
              ).isNotEmpty,
        )
        .map((x) => x.number)
        .sum,
  );
}

enum _Operator { add, multiply, concatenate }

List<List<_Operator>> _findSolutions(
  int number,
  List<int> operands, {
  required bool allowConcatenation,
}) {
  if (operands.length < 2) {
    return [];
  }

  if (operands case [final first, final second]) {
    if (first + second == number) {
      return [
        [_Operator.add],
      ];
    } else if (first * second == number) {
      return [
        [_Operator.multiply],
      ];
    } else if (allowConcatenation && '$number' == '$second$first') {
      return [
        [_Operator.concatenate],
      ];
    } else {
      return [];
    }
  }

  final [operand, ...rest] = operands;

  return [
    if (number % operand == 0)
      for (final solution in _findSolutions(
        number ~/ operand,
        rest,
        allowConcatenation: allowConcatenation,
      ))
        [_Operator.multiply, ...solution],
    if (number - operand > 0)
      for (final solution in _findSolutions(
        number - operand,
        rest,
        allowConcatenation: allowConcatenation,
      ))
        [_Operator.add, ...solution],
    if (allowConcatenation && '$number'.endsWith('$operand'))
      for (final solution in _findSolutions(
        int.tryParse('$number'.removeSuffix('$operand')) ?? 0,
        rest,
        allowConcatenation: allowConcatenation,
      ))
        [_Operator.concatenate, ...solution],
  ];
}
