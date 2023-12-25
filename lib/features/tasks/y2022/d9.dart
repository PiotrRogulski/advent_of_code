import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';

typedef _I = ListInput<({_Move move, int count})>;
typedef _O = NumericOutput<int>;

typedef _Point = ({int x, int y});
const _origin = (x: 0, y: 0);

typedef _StepAccumulator = ({List<_Point> rope, Set<_Point> tailHistory});

class Y2022D9 extends DayData<_I> {
  const Y2022D9() : super(2022, 9, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map((l) => l.split(' '))
          .map(
            (l) => (
              move: _Move.fromSymbol(l[0]),
              count: int.parse(l[1]),
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
    return _run(inputData, 2);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _run(inputData, 10);
  }
}

_O _run(_I inputData, int ropeLength) {
  return NumericOutput(
    inputData.values
        .expand((element) => List.filled(element.count, element.move))
        .fold(
          (rope: List.filled(ropeLength, _origin), tailHistory: {_origin}),
          _performMove,
        )
        .tailHistory
        .length,
  );
}

_StepAccumulator _performMove(_StepAccumulator acc, _Move move) {
  final (:rope, :tailHistory) = acc;
  final [head, ...tail] = rope;
  final newRope = [
    switch (move) {
      _Move.right => (x: head.x + 1, y: head.y),
      _Move.left => (x: head.x - 1, y: head.y),
      _Move.up => (x: head.x, y: head.y + 1),
      _Move.down => (x: head.x, y: head.y - 1),
    },
  ];
  for (final link in tail) {
    final prevLink = newRope.last;
    final dX = link.x - prevLink.x;
    final dY = link.y - prevLink.y;

    newRope.add(
      switch ((dX: dX, dY: dY, distSq: dX * dX + dY * dY)) {
        (dX: _, dY: _, distSq: < 4) => link,
        (dX: 0, dY: _, distSq: _) => (x: link.x, y: link.y - dY.sign),
        (dX: _, dY: 0, distSq: _) => (x: link.x - dX.sign, y: link.y),
        _ => (x: link.x - dX.sign, y: link.y - dY.sign),
      },
    );
  }

  return (
    rope: newRope,
    tailHistory: {...tailHistory, newRope.last},
  );
}

enum _Move {
  right('R'),
  left('L'),
  up('U'),
  down('D');

  const _Move(this.symbol);

  factory _Move.fromSymbol(String symbol) =>
      values.firstWhere((e) => e.symbol == symbol);

  final String symbol;
}
