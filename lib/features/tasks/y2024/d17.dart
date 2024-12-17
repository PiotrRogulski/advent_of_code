import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/more.dart';

typedef _I =
    ObjectInput<({({int A, int B, int C}) registers, List<int> program})>;
typedef _O = StringOutput;

typedef _ComputerState =
    ({int A, int B, int C, int pointer, List<int> output, List<int> program});

class Y2024D17 extends DayData<_I> {
  const Y2024D17() : super(2024, 17, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n\n')
        .apply(
          (d) => (
            registers: d.first
                .split('\n')
                .apply(
                  (regs) => (
                    A: int.parse(regs[0].substring(12)),
                    B: int.parse(regs[1].substring(12)),
                    C: int.parse(regs[2].substring(12)),
                  ),
                ),
            program: d.last.substring(9).split(',').map(int.parse).toList(),
          ),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    _compute(
      inputData.value.apply(
        (d) => (
          A: d.registers.A,
          B: d.registers.B,
          C: d.registers.C,
          pointer: 0,
          output: [],
          program: d.program,
        ),
      ),
    ).output.join(','),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final g = inputData.value.program;

    late int solution, operand, b, c, w;

    bool solve(int pointer, int acc) {
      if (pointer < 0) {
        solution = acc;
        return true;
      }

      for (final d in 0.to(8)) {
        var (a, i) = (acc << 3 | d, 0);
        loop:
        while (i < g.length) {
          switch (g[i + 1]) {
            case <= 3:
              operand = g[i + 1];
            case 4:
              operand = a;
            case 5:
              operand = b;
            case 6:
              operand = c;
          }
          switch (_Op.fromOpcode(g[i])) {
            case _Op.adv:
              a >>= operand;
            case _Op.bxl:
              b ^= g[i + 1];
            case _Op.bst:
              b = operand & 7;
            case _Op.jnz:
              if (a != 0) {
                i = g[i + 1] - 2;
              }
            case _Op.bxc:
              b ^= c;
            case _Op.out:
              w = operand & 7;
              break loop;
            case _Op.bdv:
              b = a >> operand;
            case _Op.cdv:
              c = a >> operand;
          }
          i += 2;
        }
        if (w == g[pointer] && solve(pointer - 1, acc << 3 | d)) {
          return true;
        }
      }
      return false;
    }

    solve(g.length - 1, 0);

    return _O(solution.toString());
  }
}

_ComputerState _compute(_ComputerState initialState) {
  var state = initialState;

  while (state.pointer < state.program.length) {
    state = switch (_Op.fromOpcode(state.program[state.pointer])) {
      _Op.adv => state.setA(state.A >> state.getComboValue()).advance(),
      _Op.bxl => state.setB(state.B ^ state.getLiteralValue()).advance(),
      _Op.bst => state.setB(state.getComboValue() & 7).advance(),
      _Op.jnz =>
        state.A == 0
            ? state.advance()
            : state.setPointer(state.getLiteralValue()),
      _Op.bxc => state.setB(state.B ^ state.C).advance(),
      _Op.out => state.addOutput(state.getComboValue() & 7).advance(),
      _Op.bdv => state.setB(state.A >> state.getComboValue()).advance(),
      _Op.cdv => state.setC(state.A >> state.getComboValue()).advance(),
    };
  }

  return state;
}

enum _Op {
  adv(0),
  bxl(1),
  bst(2),
  jnz(3),
  bxc(4),
  out(5),
  bdv(6),
  cdv(7);

  const _Op(this.opcode);
  factory _Op.fromOpcode(int opcode) =>
      values.firstWhere((op) => op.opcode == opcode);

  final int opcode;
}

extension on _ComputerState {
  int getComboValue() => switch (program[pointer + 1]) {
    (0 || 1 || 2 || 3) && final operand => operand,
    4 => A,
    5 => B,
    6 => C,
    final operand =>
      throw ArgumentError.value(operand, 'Invalid combo operand'),
  };

  int getLiteralValue() => program[pointer + 1];

  _ComputerState setA(int value) => (
    A: value,
    B: B,
    C: C,
    pointer: pointer,
    output: output,
    program: program,
  );

  _ComputerState setB(int value) => (
    A: A,
    B: value,
    C: C,
    pointer: pointer,
    output: output,
    program: program,
  );

  _ComputerState setC(int value) => (
    A: A,
    B: B,
    C: value,
    pointer: pointer,
    output: output,
    program: program,
  );

  _ComputerState setPointer(int value) => (
    A: A,
    B: B,
    C: C,
    pointer: value,
    output: output,
    program: program,
  );

  _ComputerState advance() => setPointer(pointer + 2);

  _ComputerState addOutput(int value) => (
    A: A,
    B: B,
    C: C,
    pointer: pointer,
    output: [...output, value],
    program: program,
  );
}
