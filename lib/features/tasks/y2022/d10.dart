import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<Command>;
typedef _O = StringOutput;

class const Y2022D10() extends DayData<_I> {
  this : super(2022, 10, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map(
          (l) => switch (l.split(' ')) {
            ['addx', final x] => AddX(int.parse(x)),
            ['noop'] => const Noop(),
            _ => throw UnimplementedError(),
          },
        )
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .expand(
          (cmd) => switch (cmd) {
            Noop() => [cmd],
            AddX() => [const Noop(), cmd],
          },
        )
        .fold(
          [1],
          (xs, cmd) => [
            ...xs,
            switch (cmd) {
              Noop() => xs.last,
              AddX(:final x) => xs.last + x,
            },
          ],
        )
        .whereIndexed((i, _) => i % 40 == 19)
        .mapIndexed((index, x) => x * (20 + index * 40))
        .sum
        .toString(),
  );
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values
        .expand(
          (cmd) => switch (cmd) {
            Noop() => [cmd],
            AddX() => [const Noop(), cmd],
          },
        )
        .fold(
          [1],
          (xs, cmd) => [
            ...xs,
            switch (cmd) {
              Noop() => xs.last,
              AddX(:final x) => xs.last + x,
            },
          ],
        )
        .mapIndexed(
          (index, x) => switch ((x - index % 40).abs()) {
            <= 1 => '#',
            _ => ' ',
          },
        )
        .take(240)
        .chunked(40)
        .map((e) => e.join())
        .join('\n'),
  );
}

sealed class const Command();

class const AddX(final int x) extends Command;

class const Noop() extends Command;
