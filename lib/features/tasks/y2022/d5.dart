import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:characters/characters.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart' hide IndexedIterableExtension;

class const _Move({
  required final int quantity,
  required final int from,
  required final int to,
});
class const _SingleMove({required final int from, required final int to});
typedef _Stack = List<String>;
class const _Input({
  required final List<_Stack> stacks,
  required final List<_Move> moves,
});

typedef _I = ObjectInput<_Input>;
typedef _O = StringOutput;

class const Y2022D5() extends DayData<_I> {
  this : super(2022, 5, parts: const {1: _P1(), 2: _P2()});

  static final _moveRegex = RegExp(
    r'move (?<quantity>\d+) from (?<from>\d+) to (?<to>\d+)',
  );

  @override
  _I parseInput(String rawData) => .new(
    stringifier: _inputToString,
    rawData
        .split('\n\n')
        .apply(
          (l) => .new(
            stacks: l[0]
                .split('\n')
                .reversed
                .skip(1)
                .map(
                  (l) =>
                      l.characters.whereIndexed((index, _) => index % 4 == 1),
                )
                .zip()
                .map((l) => l.whereNot((c) => c == ' '))
                .map(QueueList.from)
                .toList(),
            moves: l[1]
                .split('\n')
                .map(_moveRegex.firstMatch)
                .nonNulls
                .map(
                  (m) => _Move(
                    quantity: int.parse(m.namedGroup('quantity')!),
                    from: int.parse(m.namedGroup('from')!) - 1,
                    to: int.parse(m.namedGroup('to')!) - 1,
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
  _O runInternal(_I inputData) => .new(
    inputData.value.moves
        .expand(
          (m) => List.filled(m.quantity, _SingleMove(from: m.from, to: m.to)),
        )
        .fold(inputData.value.stacks, _performMove)
        .map((s) => s.last)
        .join(),
  );

  List<_Stack> _performMove(List<_Stack> stacks, _SingleMove move) {
    final _SingleMove(:from, :to) = move;

    return [
      for (final (index, stack) in stacks.indexed)
        if (index == from)
          .from(stack.sublist(0, stack.length - 1))
        else if (index == to)
          .from([...stack, stacks[from].last])
        else
          stack,
    ];
  }
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.moves
        .fold(inputData.value.stacks, _performMove)
        .map((s) => s.last)
        .join(),
  );

  List<_Stack> _performMove(List<_Stack> stacks, _Move move) {
    final _Move(:from, :to, :quantity) = move;

    return [
      for (final (index, stack) in stacks.indexed)
        if (index == from)
          stack.sublist(0, stack.length - quantity)
        else if (index == to)
          [
            ...stack,
            ...stacks[from].skip(stacks[from].length - quantity).take(quantity),
          ]
        else
          stack,
    ];
  }
}

String _inputToString(_Input input) {
  final buffer = StringBuffer()
    ..writeAll(
      input.stacks.mapIndexed((index, s) => '${index + 1}:  ${s.join(' ')}'),
      '\n',
    )
    ..writeln()
    ..writeAll(
      input.moves.map(
        (m) =>
            'move ${m.quantity.toString().padRight(2)} | ${m.from} -> ${m.to}',
      ),
      '\n',
    );
  return buffer.toString();
}
