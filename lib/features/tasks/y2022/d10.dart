import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<Command>;
typedef _O = StringOutput;

class Y2022D10 extends DayData<_I> {
  const Y2022D10() : super(2022, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData.split('\n').map((l) {
        return switch (l.split(' ')) {
          ['addx', final x] => AddX(int.parse(x)),
          ['noop'] => const Noop(),
          _ => throw UnimplementedError(),
        };
      }).toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return StringOutput(
      inputData.values
          .expand((cmd) {
            return switch (cmd) {
              Noop() => [cmd],
              AddX() => [const Noop(), cmd],
            };
          })
          .fold([1], (xs, cmd) {
            return [
              ...xs,
              switch (cmd) {
                Noop() => xs.last,
                AddX(:final x) => xs.last + x,
              },
            ];
          })
          .whereIndexed((i, _) => i % 40 == 19)
          .mapIndexed((index, x) => x * (20 + index * 40))
          .sum
          .toString(),
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return StringOutput(
      inputData.values
          .expand((cmd) {
            return switch (cmd) {
              Noop() => [cmd],
              AddX() => [const Noop(), cmd],
            };
          })
          .fold([1], (xs, cmd) {
            return [
              ...xs,
              switch (cmd) {
                Noop() => xs.last,
                AddX(:final x) => xs.last + x,
              },
            ];
          })
          .mapIndexed((index, x) {
            return switch ((x - index % 40).abs()) {
              <= 1 => '#',
              _ => ' ',
            };
          })
          .take(240)
          .chunked(40)
          .map((e) => e.join())
          .join('\n'),
    );
  }
}

sealed class Command {
  const Command();
}

class AddX extends Command {
  const AddX(this.x);

  final int x;
}

class Noop extends Command {
  const Noop();
}
