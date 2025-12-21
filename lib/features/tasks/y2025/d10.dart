import 'dart:io';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart' hide IndexedIterableExtension;
import 'package:more/comparator.dart';
import 'package:z3/z3.dart';

typedef _Machine = ({
  ({String diagram, int bits}) target,
  List<({List<int> ids, int mask})> buttons,
  List<int> joltageRequirements,
});
typedef _I = ListInput<_Machine>;
typedef _O = NumericOutput<int>;

class Y2025D10 extends DayData<_I> {
  const Y2025D10() : super(2025, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(
          (l) => l
              .split(' ')
              .apply(
                (p) => (
                  target: p.first
                      .removePrefix('[')
                      .removeSuffix(']')
                      .apply(
                        (diagram) => (
                          diagram: diagram,
                          bits: diagram.characters
                              .map((c) => c == '#')
                              .indexed
                              .where((e) => e.$2)
                              .map((e) => e.$1)
                              .fold(0, (mask, pos) => mask | 1 << pos),
                        ),
                      ),
                  buttons: p
                      .skipLast(1)
                      .skip(1)
                      .map(
                        (b) => b
                            .removePrefix('(')
                            .removeSuffix(')')
                            .split(',')
                            .map(int.parse)
                            .toList(),
                      )
                      .map(
                        (ids) => (
                          ids: ids,
                          mask: ids.fold(0, (mask, pos) => mask | 1 << pos),
                        ),
                      )
                      .toList(),
                  joltageRequirements: p.last
                      .removePrefix('{')
                      .removeSuffix('}')
                      .split(',')
                      .map(int.parse)
                      .toList(),
                ),
              ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map(
          (e) => e.buttons
              .powerSet()
              .where(
                (b) => b.fold(0, (acc, btn) => acc ^ btn.mask) == e.target.bits,
              )
              .smallest(1, comparator: keyOf((e) => e.length))
              .first
              .length,
        )
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(inputData.values.map(_solve).sum);

  int _solve(_Machine machine) {
    if (Platform.isMacOS) {
      libz3Override = .open('libz3.4.15.4.0.dylib');
    }

    final opt = optimize();

    final btnVars = [
      for (final i in 0.to(machine.buttons.length)) constVar('btn$i', intSort),
    ];
    for (final btn in btnVars) {
      opt.add(btn >= 0);
    }

    for (final (i, req) in machine.joltageRequirements.indexed) {
      final linkedButtons = machine.buttons.indexed.where(
        (btn) => btn.$2.ids.contains(i),
      );
      opt.add(
        eq(
          addN([for (final (linked, _) in linkedButtons) btnVars[linked]]),
          intFrom(req),
        ),
      );
    }

    final total = constVar('total', intSort);
    opt
      ..add(total >= 0)
      ..add(eq(total, addN(btnVars)))
      ..minimize(total)
      ..check();
    return opt.getObjectives().single.upperBound.rational.toInt();
  }
}
