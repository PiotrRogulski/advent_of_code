import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

class const _Part({
  required final int x,
  required final int m,
  required final int a,
  required final int s,
});

class const _Predicate({
  required final String variable,
  required final _Op op,
  required final int value,
}) {
  bool call(_Part part) => switch (variable) {
    'x' => op(part.x, value),
    'm' => op(part.m, value),
    'a' => op(part.a, value),
    's' => op(part.s, value),
    _ => throw StateError('Invalid variable: $variable'),
  };
}

class const _Condition({
  required final _Predicate? pred,
  required final String target,
});

class const _Range({required final int start, required final int end}) {
  _Range merge(_Range other) =>
      .new(start: max(start, other.start), end: min(end, other.end));
}

class const _Input({
  required final Map<String, List<_Condition>> workflows,
  required final List<_Part> parts,
});

typedef _I = ObjectInput<_Input>;
typedef _O = NumericOutput<int>;

class const Y2023D19() extends DayData<_I> {
  this : super(2023, 19, parts: const {1: _P1(), 2: _P2()});

  static final _workflowRegex = RegExp(r'^(?<label>\w+)\{(?<rules>.+)}$');
  static final _partRegex = RegExp(
    r'^\{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}$',
  );

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (l) => .new(
            workflows: .fromEntries(
              l.first
                  .split('\n')
                  .map(_workflowRegex.firstMatch)
                  .nonNulls
                  .map(
                    (m) => .new(
                      m.namedGroup('label')!,
                      m
                          .namedGroup('rules')!
                          .split(',')
                          .map(
                            (r) => switch (r.split(':')) {
                              [final cond, final target] => _Condition(
                                pred: .new(
                                  variable: cond[0],
                                  op: _Op.fromSymbol(cond[1]),
                                  value: int.parse(cond.substring(2)),
                                ),
                                target: target,
                              ),
                              [final target] => _Condition(
                                pred: null,
                                target: target,
                              ),
                              _ => throw StateError('Invalid condition: $r'),
                            },
                          )
                          .toList(),
                    ),
                  ),
            ),
            parts: l.last
                .split('\n')
                .map(_partRegex.firstMatch)
                .nonNulls
                .map(
                  (m) => _Part(
                    x: .parse(m.namedGroup('x')!),
                    m: .parse(m.namedGroup('m')!),
                    a: .parse(m.namedGroup('a')!),
                    s: .parse(m.namedGroup('s')!),
                  ),
                )
                .toList(),
          ),
        ),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.parts
        .where((part) {
          bool? status;
          var workflow = 'in';
          while (status == null) {
            final rules = inputData.value.workflows[workflow]!;
            final rule = rules.firstWhere((r) => r.pred?.call(part) ?? true);
            switch (rule.target) {
              case 'R':
                status = false;
              case 'A':
                status = true;
              case final target:
                workflow = target;
            }
          }
          return status;
        })
        .map((part) => part.x + part.m + part.a + part.s)
        .sum,
  );
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    _run(inputData.value.workflows, 'in', const {
      'x': .new(start: 1, end: 4001),
      'm': .new(start: 1, end: 4001),
      'a': .new(start: 1, end: 4001),
      's': .new(start: 1, end: 4001),
    }),
  );

  int _run(
    Map<String, List<_Condition>> workflows,
    String target,
    Map<String, _Range> ranges,
  ) {
    int runRec(String target, Map<String, _Range> ranges) {
      switch (target) {
        case 'R':
          return 0;
        case 'A':
          return ranges.values.map((r) => r.end - r.start).product;
        default:
          final newRanges = {...ranges};
          return workflows[target]!.map((rule) {
            final _Condition(:pred, :target) = rule;
            switch (pred) {
              case null:
                return runRec(target, newRanges);
              case _Predicate(:final variable, :final op, :final value):
                final range = newRanges[variable]!.merge(switch (op) {
                  .lt => .new(start: 1, end: value),
                  .gt => .new(start: value + 1, end: 4001),
                });
                final reverseRange = newRanges[variable]!.merge(switch (op) {
                  .lt => .new(start: value, end: 4001),
                  .gt => .new(start: 1, end: value + 1),
                });
                newRanges[variable] = range;
                final res = runRec(target, newRanges);
                newRanges[variable] = reverseRange;
                return res;
            }
          }).sum;
      }
    }

    return runRec(target, ranges);
  }
}

enum _Op(final String symbol) {
  gt('>'),
  lt('<');

  factory fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  @override
  String toString() => symbol;

  bool call(int a, int b) => switch (this) {
    gt => a > b,
    lt => a < b,
  };
}
