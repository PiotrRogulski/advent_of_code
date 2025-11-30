import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';

typedef _Cell = ({int r, int c});
typedef _Delta = ({int dr, int dc});
typedef _Move = ({_Dir direction, int steps, String colorHex});

typedef _I = ListInput<_Move>;
typedef _O = NumericOutput<int>;

class Y2023D18 extends DayData<_I> {
  const Y2023D18() : super(2023, 18, parts: const {1: _P1(), 2: _P2()});

  static final _moveRegex = RegExp(
    r'^(?<dir>[UDLR]) (?<steps>\d+) \(#(?<colorHex>[0-9a-f]{6})\)$',
  );

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(_moveRegex.firstMatch)
        .nonNulls
        .map(
          (m) => (
            direction: _Dir.fromSymbol(m.namedGroup('dir')!),
            steps: int.parse(m.namedGroup('steps')!),
            colorHex: m.namedGroup('colorHex')!,
          ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_area(inputData.values));
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    _area(
      inputData.values.map(
        (move) => (
          direction: switch (move.colorHex.characters.last) {
            '0' => .right,
            '1' => .down,
            '2' => .left,
            '3' => .up,
            _ => throw StateError('Invalid colorHex: ${move.colorHex}'),
          },
          steps: .parse(
            move.colorHex.substring(0, move.colorHex.length - 1),
            radix: 16,
          ),
          colorHex: move.colorHex,
        ),
      ),
    ),
  );
}

int _area(Iterable<({String colorHex, _Dir direction, int steps})> points) {
  final (:area, :perimeter, p: _) = points.fold(
    (p: (r: 0, c: 0), perimeter: 0, area: 0),
    (acc, move) {
      final delta = move.direction.delta * move.steps;
      final p = acc.p + delta;
      return (
        p: p,
        perimeter: acc.perimeter + move.steps,
        area: acc.area + p.c * delta.dr,
      );
    },
  );
  return area + perimeter ~/ 2 + 1;
}

enum _Dir {
  up('U'),
  down('D'),
  left('L'),
  right('R');

  const _Dir(this.symbol);
  factory _Dir.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;

  _Delta get delta => switch (this) {
    up => (dr: -1, dc: 0),
    down => (dr: 1, dc: 0),
    left => (dr: 0, dc: -1),
    right => (dr: 0, dc: 1),
  };
}

extension on _Cell {
  _Cell operator +(_Delta delta) => (r: r + delta.dr, c: c + delta.dc);
}

extension on _Delta {
  _Delta operator *(int factor) => (dr: dr * factor, dc: dc * factor);
}
