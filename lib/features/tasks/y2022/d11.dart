import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

typedef _WorryLevel = int;

class _Monkey {
  _Monkey({
    required this.div,
    required this.id,
    required this.ifFalse,
    required this.ifTrue,
    required this.items,
    required this.op,
    required this.inspectionCount,
  });

  final _WorryLevel div;
  final int id;
  final int ifFalse;
  final int ifTrue;
  final List<_WorryLevel> items;
  final _Operation op;
  int inspectionCount;
}

typedef _I = ListInput<_Monkey>;
typedef _O = NumericOutput<int>;

class Y2022D11 extends DayData<_I> {
  const Y2022D11() : super(2022, 11, parts: const {1: _P1(), 2: _P2()});

  static final _monkeyRegex = RegExp(
    r'Monkey (?<id>\d+):\n {2}Starting items: (?<items>.+?)\n {2}Operation: new = (?<op>.+?)\n {2}Test: divisible by (?<div>\d+)\n {4}If true: throw to monkey (?<true>\d+)\n {4}If false: throw to monkey (?<false>\d+)',
  );

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n\n')
          .map(_monkeyRegex.firstMatch)
          .nonNulls
          .map(
            (m) => _Monkey(
              id: int.parse(m.namedGroup('id')!),
              items:
                  m
                      .namedGroup('items')!
                      .split(', ')
                      .map(_WorryLevel.parse)
                      .toList(),
              op: switch (m.namedGroup('op')!.split(' ')) {
                ['old', '+', final value] => _Add(_WorryLevel.parse(value)),
                ['old', '*', 'old'] => const _Square(),
                ['old', '*', final value] => _Multiply(
                  _WorryLevel.parse(value),
                ),
                _ => throw UnimplementedError(),
              },
              div: _WorryLevel.parse(m.namedGroup('div')!),
              ifTrue: int.parse(m.namedGroup('true')!),
              ifFalse: int.parse(m.namedGroup('false')!),
              inspectionCount: 0,
            ),
          )
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _run(inputData, 20, 3);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _run(inputData, 10000, 1);
  }
}

const _ringValue = 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19;

_O _run(_I inputData, int roundCount, _WorryLevel divisor) {
  final monkeys = inputData.values;
  for (var i = 0; i < roundCount; i++) {
    _evalRound(monkeys, divisor: divisor);
  }
  return NumericOutput(
    monkeys
        .map((e) => e.inspectionCount)
        .sortedBy<num>((e) => -e)
        .take(2)
        .apply((l) => l.first * l.last),
  );
}

void _evalRound(List<_Monkey> monkeys, {required _WorryLevel divisor}) {
  for (final monkey in monkeys) {
    monkey.inspectionCount += monkey.items.length;
    while (monkey.items.isNotEmpty) {
      final item = monkey.items.removeAt(0);
      final newWorryLevel = (monkey.op.eval(item) ~/ divisor) % _ringValue;
      final targetMonkey = switch (newWorryLevel % monkey.div == 0) {
        true => monkey.ifTrue,
        false => monkey.ifFalse,
      };
      monkeys[targetMonkey].items.add(newWorryLevel);
    }
  }
}

sealed class _Operation with EquatableMixin {
  const _Operation();

  _WorryLevel eval(_WorryLevel old) => switch (this) {
    _Add(:final value) => value + old,
    _Multiply(:final value) => value * old,
    _Square() => old * old,
  };
}

class _Add extends _Operation {
  const _Add(this.value);

  final _WorryLevel value;

  @override
  List<Object?> get props => [value];
}

class _Multiply extends _Operation {
  const _Multiply(this.value);

  final _WorryLevel value;

  @override
  List<Object?> get props => [value];
}

class _Square extends _Operation {
  const _Square();

  @override
  List<Object?> get props => [];
}
