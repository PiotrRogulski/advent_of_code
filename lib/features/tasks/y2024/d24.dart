import 'dart:async';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

class const _Equation({
  required final String arg1,
  required final String arg2,
  required final _Op op,
  required final String target,
});
class const _Input({
  required final List<({String name, int value})> initialValues,
  required final List<_Equation> equations,
});

typedef _I = ObjectInput<_Input>;
typedef _O = StringOutput;

class const Y2024D24() extends DayData<_I> {
  this : super(2024, 24, parts: const {1: _P1(), 2: _P2()});

  static final _initRegex = RegExp(r'(?<name>\w+): (?<value>\d+)');
  static final _eqRegex = RegExp(
    r'(?<arg1>\w+) (?<op>\w+) (?<arg2>\w+) -> (?<target>\w+)',
  );

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (p) => .new(
            initialValues: p.first
                .split('\n')
                .map(_initRegex.firstMatch)
                .nonNulls
                .map(
                  (m) => (
                    name: m.namedGroup('name')!,
                    value: int.parse(m.namedGroup('value')!),
                  ),
                )
                .toList(),
            equations: p.last
                .split('\n')
                .map(_eqRegex.firstMatch)
                .nonNulls
                .map(
                  (m) => _Equation(
                    arg1: m.namedGroup('arg1')!,
                    arg2: m.namedGroup('arg2')!,
                    op: .fromString(m.namedGroup('op')!),
                    target: m.namedGroup('target')!,
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
  Future<_O> runInternal(_I inputData) => inputData.value.equations
      .fold(
        {
          for (final eq in inputData.value.equations)
            eq.target: Completer<int>(),
          for (final (:name, :value) in inputData.value.initialValues)
            name: Completer<int>()..complete(value),
        },
        (completers, eq) {
          _setupEquation(eq, completers);
          return completers;
        },
      )
      .entries
      .where((e) => e.key.startsWith('z'))
      .sortedBy((e) => e.key)
      .map((e) => e.value.future)
      .wait
      .then((bits) => int.parse(bits.reversed.join(), radix: 2).toString())
      .then(_O.new);
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final g = inputData.value.equations.fold(
      Graph<String, _Op>(isDirected: true),
      (graph, eq) => graph
        ..addEdge(eq.arg1, eq.target, value: eq.op)
        ..addEdge(eq.arg2, eq.target, value: eq.op),
    );
    // Used as output
    // ignore: avoid_print
    print(
      g.toDot(
        edgeLabel: (e) => e.value.symbol,
        edgeAttributes: (e) => {
          'fontcolor': switch (e.value) {
            .and => 'red',
            .xor => 'blue',
            .or => 'green',
          },
          'color': switch (e.value) {
            .and => 'red',
            .xor => 'blue',
            .or => 'green',
          },
        },
      ),
    );

    return const .new('Just look at the graph bruh');
  }
}

enum _Op {
  and,
  xor,
  or;

  factory fromString(String s) => values.byName(s.toLowerCase());

  String get symbol => switch (this) {
    and => '&',
    xor => '^',
    or => '|',
  };

  @override
  String toString() => name.toUpperCase();
}

Future<void> _setupEquation(
  _Equation eq,
  Map<String, Completer<int>> completers,
) async {
  final arg1 = await completers[eq.arg1]!.future;
  final arg2 = await completers[eq.arg2]!.future;

  completers[eq.target]!.complete(switch (eq.op) {
    .and => arg1 & arg2,
    .xor => arg1 ^ arg2,
    .or => arg1 | arg2,
  });
}
