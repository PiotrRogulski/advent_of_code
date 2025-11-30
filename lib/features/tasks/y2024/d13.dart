import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:vector_math/vector_math_64.dart';

typedef _I = ListInput<_ClawMachine>;
typedef _O = NumericOutput<int>;

typedef _ClawMachine = ({
  ({double dx, double dy}) buttonA,
  ({double dx, double dy}) buttonB,
  ({double x, double y}) prize,
});

class Y2024D13 extends DayData<_I> {
  const Y2024D13() : super(2024, 13, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n\n')
        .map(_clawRegex.firstMatch)
        .nonNulls
        .map(
          (m) => (
            buttonA: (
              dx: double.parse(m.namedGroup('ax')!),
              dy: double.parse(m.namedGroup('ay')!),
            ),
            buttonB: (
              dx: double.parse(m.namedGroup('bx')!),
              dy: double.parse(m.namedGroup('by')!),
            ),
            prize: (
              x: double.parse(m.namedGroup('x')!),
              y: double.parse(m.namedGroup('y')!),
            ),
          ),
        )
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(inputData.values.map(_solveMachine).sum);
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values
        .map((m) => _solveMachine(m, offset: 10_000_000_000_000))
        .sum,
  );
}

final _clawRegex = RegExp(
  r'Button A: X\+(?<ax>\d+), Y\+(?<ay>\d+)\n'
  r'Button B: X\+(?<bx>\d+), Y\+(?<by>\d+)\n'
  r'Prize: X=(?<x>\d+), Y=(?<y>\d+)',
  multiLine: true,
);

int _solveMachine(_ClawMachine machine, {double offset = 0}) {
  final A = Matrix2(
    machine.buttonA.dx,
    machine.buttonA.dy,
    machine.buttonB.dx,
    machine.buttonB.dy,
  );
  final b = Vector2(offset + machine.prize.x, offset + machine.prize.y);
  final x = Vector2.zero();
  Matrix2.solve(A, x, b);

  if (_isCloseToIntegral(x.x) && _isCloseToIntegral(x.y)) {
    return x.x.round() * 3 + x.y.round();
  } else {
    return 0;
  }
}

bool _isCloseToIntegral(double x) => (x - x.round()).abs() < 0.001;
