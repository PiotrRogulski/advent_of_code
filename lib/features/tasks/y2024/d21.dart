import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<String>;
typedef _O = NumericOutput<int>;

class Y2024D21 extends DayData<_I> {
  const Y2024D21() : super(2024, 21, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(rawData.split('\n'));
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map((i) => _findLength(i, 2, 0) * int.parse(i.substring(0, 3)))
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .map((i) => _findLength(i, 25, 0) * int.parse(i.substring(0, 3)))
        .sum,
  );
}

final _memo = <(String, int, int), int>{};

int _findLength(String input, int limit, int depth) =>
    _memo.putIfAbsent((input, limit, depth), () {
      final keypad = depth == 0 ? _numpad : _dirpad;
      final emptySpace = keypad.indexOf('');
      final chars = input.characters;
      return chars.fold((current: keypad.indexOf('A'), length: 0), (acc, c) {
        final next = keypad.indexOf(c);
        final paths = _paths(acc.current, next, emptySpace);
        return (
          current: next,
          length:
              acc.length +
              (depth == limit
                  ? paths.first.length
                  : paths.map((p) => _findLength(p, limit, depth + 1)).min),
        );
      }).length;
    });

List<String> _paths(MatrixIndex start, MatrixIndex end, MatrixIndex empty) => [
  for (final p in _expandMove(end - start).characters.permutations().unique(
    equals: listEquals,
    hashCode: Object.hashAll,
  ))
    if (!p
        .fold([start], (acc, c) => acc..add(acc.last + c.delta))
        .contains(empty))
      '${p.join()}A',
].apply((p) => p.isEmpty ? ['A'] : p);

String _expandMove(MatrixIndexDelta d) =>
    '${switch (d.dc) {
      < 0 => '<' * -d.dc,
      > 0 => '>' * d.dc,
      _ => '',
    }}${switch (d.dr) {
      < 0 => '^' * -d.dr,
      > 0 => 'v' * d.dr,
      _ => '',
    }}';

final _numpad = Matrix.fromList([
  ['7', '8', '9'],
  ['4', '5', '6'],
  ['1', '2', '3'],
  ['', '0', 'A'],
]);

final _dirpad = Matrix.fromList([
  ['', '^', 'A'],
  ['<', 'v', '>'],
]);

extension on String {
  MatrixIndexDelta get delta => switch (this) {
    '^' => (dr: -1, dc: 0),
    'v' => (dr: 1, dc: 0),
    '<' => (dr: 0, dc: -1),
    '>' => (dr: 0, dc: 1),
    _ => throw UnsupportedError('Invalid direction character: $this'),
  };
}
