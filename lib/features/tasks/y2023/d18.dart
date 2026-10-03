import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';

typedef _Cell = MatrixIndex;
typedef _Delta = MatrixIndexDelta;

class const _Move({
  required final _Dir direction,
  required final int steps,
  required final String colorHex,
});

typedef _I = ListInput<_Move>;
typedef _O = NumericOutput<int>;

class const Y2023D18() extends DayData<_I> {
  this : super(2023, 18, parts: const {1: _P1(), 2: _P2()});

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
          (m) => _Move(
            direction: .fromSymbol(m.namedGroup('dir')!),
            steps: .parse(m.namedGroup('steps')!),
            colorHex: m.namedGroup('colorHex')!,
          ),
        )
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(_area(inputData.values));
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    _area(
      inputData.values.map(
        (move) => .new(
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

int _area(Iterable<_Move> points) {
  final (:area, :perimeter, p: _) = points.fold(
    (p: const _Cell(row: 0, column: 0), perimeter: 0, area: 0),
    (acc, move) {
      final delta = move.direction.delta * move.steps;
      final p = acc.p + delta;
      return (
        p: p,
        perimeter: acc.perimeter + move.steps,
        area: acc.area + p.column * delta.dr,
      );
    },
  );
  return area + perimeter ~/ 2 + 1;
}

enum _Dir(final String symbol, final _Delta delta) {
  up('U', .up),
  down('D', .down),
  left('L', .left),
  right('R', .right);

  factory fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  @override
  String toString() => symbol;
}
