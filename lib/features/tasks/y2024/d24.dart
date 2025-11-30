import 'dart:async';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I =
    ObjectInput<
      ({
        List<({String name, int value})> initialValues,
        List<_Equation> equations,
      })
    >;
typedef _O = StringOutput;

typedef _Equation = ({String arg1, String arg2, _Op op, String target});

class Y2024D24 extends DayData<_I> {
  const Y2024D24() : super(2024, 24, parts: const {1: _P1(), 2: _P2()});

  static final _initRegex = RegExp(r'(?<name>\w+): (?<value>\d+)');
  static final _eqRegex = RegExp(
    r'(?<arg1>\w+) (?<op>\w+) (?<arg2>\w+) -> (?<target>\w+)',
  );

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n\n')
        .apply(
          (p) => (
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
                  (m) => (
                    arg1: m.namedGroup('arg1')!,
                    arg2: m.namedGroup('arg2')!,
                    op: _Op.fromString(m.namedGroup('op')!),
                    target: m.namedGroup('target')!,
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

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final g = inputData.value.equations.fold(
      Graph<String, _Op>.directed(),
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
            _Op.and => 'red',
            _Op.xor => 'blue',
            _Op.or => 'green',
          },
          'color': switch (e.value) {
            _Op.and => 'red',
            _Op.xor => 'blue',
            _Op.or => 'green',
          },
        },
      ),
    );

    return const _O('Just look at the graph bruh');
  }
}

enum _Op {
  and,
  xor,
  or;

  factory _Op.fromString(String s) => values.byName(s.toLowerCase());

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
    _Op.and => arg1 & arg2,
    _Op.xor => arg1 ^ arg2,
    _Op.or => arg1 | arg2,
  });
}
