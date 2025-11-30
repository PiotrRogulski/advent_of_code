import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I =
    ObjectInput<({Iterable<(int, int)> rules, List<List<int>> updates})>;
typedef _O = NumericOutput<int>;

class Y2024D5 extends DayData<_I> {
  const Y2024D5() : super(2024, 5, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n\n')
        .apply(
          (d) => (
            rules: d.first
                .split('\n')
                .map(
                  (l) => l
                      .split('|')
                      .apply((p) => (int.parse(p.first), int.parse(p.last))),
                )
                .toSet(),
            updates: d.last
                .split('\n')
                .map((l) => l.split(',').map(int.parse).toList())
                .toList(),
          ),
        ),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.apply(
      (i) =>
          i.updates.where(i.rules.isOrdered).map((u) => u[u.length ~/ 2]).sum,
    ),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.value.apply(
      (i) => i.updates
          .whereNot(i.rules.isOrdered)
          .map(
            (u) => iterate(u.toList(), (u) {
              final invalidIndex = 0
                  .to(u.length)
                  .firstWhere(
                    (index) => u
                        .sublist(index + 1)
                        .any((y) => i.rules.contains((y, u[index]))),
                  );
              final indexToMove = 0
                  .to(u.length)
                  .reversed
                  .firstWhere(
                    (index) => i.rules.contains((u[index], u[invalidIndex])),
                  );
              return u..insert(indexToMove, u.removeAt(invalidIndex));
            }).firstWhere(i.rules.isOrdered),
          )
          .map((u) => u[u.length ~/ 2])
          .sum,
    ),
  );
}

extension on Iterable<(int, int)> {
  bool isOrdered(List<int> update) => update
      .mapIndexed(
        (i, x) => update.sublist(i + 1).every((y) => !contains((y, x))),
      )
      .every((e) => e);
}
