import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _Subset = ({int red, int green, int blue});

typedef _Game = ({int index, Iterable<_Subset> subsets});

typedef _I = ListInput<_Game>;
typedef _O = NumericOutput<int>;

class Y2023D2 extends DayData<_I> {
  const Y2023D2() : super(2023, 2, parts: const {1: _P1(), 2: _P2()});

  static final _gameRegex = RegExp(r'Game (?<index>\d+): (?<subsets>.+)');
  static RegExp _subsetColorEntry(String color) =>
      RegExp('(?<count>\\d+) $color');

  static int _extractColorCount(String color, String s) {
    return int.parse(
      _subsetColorEntry(color).firstMatch(s)?.namedGroup('count') ?? '0',
    );
  }

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map(_gameRegex.firstMatch)
          .nonNulls
          .map(
            (m) => (
              index: int.parse(m.namedGroup('index')!),
              subsets: m
                  .namedGroup('subsets')!
                  .split('; ')
                  .map(
                    (s) => (
                      red: _extractColorCount('red', s),
                      green: _extractColorCount('green', s),
                      blue: _extractColorCount('blue', s),
                    ),
                  ),
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
    return NumericOutput(
      inputData.values
          .where(
            (game) => game.subsets.every(
              (subset) =>
                  subset.red <= 12 && subset.green <= 13 && subset.blue <= 14,
            ),
          )
          .map((game) => game.index)
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
          .map(
            (game) =>
                game.subsets.map((subset) => subset.red).max *
                game.subsets.map((subset) => subset.green).max *
                game.subsets.map((subset) => subset.blue).max,
          )
          .sum,
    );
  }
}
