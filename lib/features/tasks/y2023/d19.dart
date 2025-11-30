import 'dart:math';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _Part = ({int x, int m, int a, int s});
typedef _Predicate = ({String variable, _Op op, int value});
typedef _Condition = ({_Predicate? pred, String target});
typedef _Range = ({int start, int end});

typedef _I =
    ObjectInput<({Map<String, List<_Condition>> workflows, List<_Part> parts})>;
typedef _O = NumericOutput<int>;

class Y2023D19 extends DayData<_I> {
  const Y2023D19() : super(2023, 19, parts: const {1: _P1(), 2: _P2()});

  static final _workflowRegex = RegExp(r'^(?<label>\w+)\{(?<rules>.+)}$');
  static final _partRegex = RegExp(
    r'^\{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}$',
  );

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (l) => (
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
                              [final cond, final target] => (
                                pred: (
                                  variable: cond[0],
                                  op: _Op.fromSymbol(cond[1]),
                                  value: int.parse(cond.substring(2)),
                                ),
                                target: target,
                              ),
                              [final target] => (pred: null, target: target),
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
                  (m) => (
                    x: int.parse(m.namedGroup('x')!),
                    m: int.parse(m.namedGroup('m')!),
                    a: int.parse(m.namedGroup('a')!),
                    s: int.parse(m.namedGroup('s')!),
                  ),
                )
                .toList(),
          ),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.parts
        .where((part) {
          bool? status;
          var workflow = 'in';
          while (status == null) {
            final rules = inputData.value.workflows[workflow]!;
            final rule = rules.firstWhere((r) => r.pred(part));
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

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    _run(inputData.value.workflows, 'in', {
      'x': (start: 1, end: 4001),
      'm': (start: 1, end: 4001),
      'a': (start: 1, end: 4001),
      's': (start: 1, end: 4001),
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
            final (:pred, :target) = rule;
            switch (pred) {
              case null:
                return runRec(target, newRanges);
              case (:final variable, :final op, :final value):
                final range = newRanges[variable]!.merge(switch (op) {
                  .lt => (start: 1, end: value),
                  .gt => (start: value + 1, end: 4001),
                });
                final reverseRange = newRanges[variable]!.merge(switch (op) {
                  .lt => (start: value, end: 4001),
                  .gt => (start: 1, end: value + 1),
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

enum _Op {
  gt('>'),
  lt('<');

  const _Op(this.symbol);
  factory _Op.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;

  bool call(int a, int b) => switch (this) {
    gt => a > b,
    lt => a < b,
  };
}

extension on _Predicate? {
  bool call(_Part part) => switch (this) {
    null => true,
    (:final variable, :final op, :final value) => switch (variable) {
      'x' => op(part.x, value),
      'm' => op(part.m, value),
      'a' => op(part.a, value),
      's' => op(part.s, value),
      _ => throw StateError('Invalid variable: $variable'),
    },
  };
}

extension on _Range {
  _Range merge(_Range other) =>
      (start: max(start, other.start), end: min(end, other.end));
}
