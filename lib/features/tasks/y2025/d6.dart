import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/extensions/iterable.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

class const _Problem({
  required final List<int> operands,
  required final String operation,
});
class const _Input({
  required final List<_Problem> part1,
  required final List<_Problem> part2,
});
typedef _I = ObjectInput<_Input>;
typedef _O = NumericOutput<int>;

class const Y2025D6() extends DayData<_I> {
  this : super(2025, 6, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    .new(
      part1: rawData
          .split('\n')
          .map((l) => l.trim().split(RegExp(r'\s+')))
          .zip()
          .map(
            (l) => _Problem(
              operands: l.take(l.length - 1).map(int.parse).toList(),
              operation: l.last,
            ),
          )
          .toList(),
      part2: rawData
          .split('\n')
          .map((l) => l.characters)
          .zip()
          .toList()
          .reversed
          .map((l) => l.join())
          .splitBefore((e) => e.trim().isEmpty)
          .map((ls) => ls.where((l) => l.trim().isNotEmpty))
          .map(
            (e) => _Problem(
              operands: e
                  .map((l) => int.parse(l.substring(0, l.length - 1).trim()))
                  .toList(),
              operation: e.last.characters.last,
            ),
          )
          .toList(),
    ),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.value.part1.map(_calculate).sum);
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.value.part2.map(_calculate).sum);
}

int _calculate(_Problem problem) => switch (problem.operation) {
  '*' => problem.operands.product,
  '+' => problem.operands.sum,
  final op => throw UnsupportedError('Unknown operation $op'),
};
