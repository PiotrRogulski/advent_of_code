import 'dart:math';

import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _Card = ({int index, Set<int> winning, Set<int> yours});

typedef _I = ListInput<_Card>;
typedef _O = NumericOutput<int>;

class Y2023D4 extends DayData<_I> {
  const Y2023D4() : super(year: 2023, day: 4);

  static final _cardRegex =
      RegExp(r'^Card +(?<index>\d+): +(?<winning>.+) +[|] +(?<yours>.+)$');

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map(_cardRegex.firstMatch)
          .nonNulls
          .map(
            (m) => (
              index: int.parse(m.namedGroup('index')!),
              winning: m
                  .namedGroup('winning')!
                  .split(RegExp(' +'))
                  .map(int.parse)
                  .toSet(),
              yours: m
                  .namedGroup('yours')!
                  .split(RegExp(' +'))
                  .map(int.parse)
                  .toSet(),
            ),
          )
          .toList(),
    );
  }

  @override
  Map<int, PartImplementation<_I, _O>> get parts => {
        1: const _P1(),
        2: const _P2(),
      };
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .map((e) => e.winning.intersection(e.yours).length)
          .map((e) => pow(2, e - 1).toInt())
          .sum,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
              .fold(<int, int>{}, (additionalCards, card) {
                final newAdditionalCards = Map.fromEntries(
                  List.generate(
                    card.winning.intersection(card.yours).length,
                    (i) => MapEntry(
                      card.index + i + 1,
                      (additionalCards[card.index] ?? 0) +
                          1 +
                          (additionalCards[card.index + i + 1] ?? 0),
                    ),
                  ),
                );
                return {
                  ...additionalCards,
                  ...newAdditionalCards,
                };
              })
              .values
              .sum +
          inputData.values.length,
    );
  }
}
