import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = ListInput<(String, String)>;
typedef _O = NumericOutput<int>;

class Y2022D2 extends DayData<_I> {
  const Y2022D2() : super(year: 2022, day: 2);

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .trim()
          .split('\n')
          .map((e) => e.split(' '))
          .map((l) => (l[0], l[1]))
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
          .map(
            (t) => (
              _Shape.fromOpponentSymbol(t.$1),
              _Shape.fromYourSymbol(t.$2),
            ),
          )
          .map(_mapRoundScore)
          .sum,
    );
  }

  int _mapRoundScore((_Shape, _Shape) t) {
    final (opponent, your) = t;
    final diff = (opponent.index - your.index) % 3;
    final roundOutcomeScore = switch (diff) {
      1 => 0,
      2 => 6,
      _ => 3,
    };
    return roundOutcomeScore + your.score;
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.values
          .map(
            (t) => (
              _Shape.fromOpponentSymbol(t.$1),
              _ExpectedOutcome.fromSymbol(t.$2),
            ),
          )
          .map(_mapRoundScore)
          .sum,
    );
  }

  int _mapRoundScore((_Shape, _ExpectedOutcome) t) {
    final (opponent, outcome) = t;
    final diff = switch (outcome) {
      _ExpectedOutcome.youLose => 2,
      _ExpectedOutcome.draw => 0,
      _ExpectedOutcome.youWin => 1,
    };
    final yourIndex = (opponent.index + diff) % 3;
    final your = _Shape.values[yourIndex];
    return outcome.score + your.score;
  }
}

enum _Shape {
  rock(1, your: 'X', opponent: 'A'),
  paper(2, your: 'Y', opponent: 'B'),
  scissors(3, your: 'Z', opponent: 'C');

  const _Shape(this.score, {required this.your, required this.opponent});
  factory _Shape.fromYourSymbol(String symbol) =>
      values.firstWhere((e) => e.your == symbol);
  factory _Shape.fromOpponentSymbol(String symbol) =>
      values.firstWhere((e) => e.opponent == symbol);

  final int score;
  final String your;
  final String opponent;
}

enum _ExpectedOutcome {
  youLose('X', 0),
  draw('Y', 3),
  youWin('Z', 6);

  const _ExpectedOutcome(this.symbol, this.score);
  factory _ExpectedOutcome.fromSymbol(String symbol) =>
      values.firstWhere((e) => e.symbol == symbol);

  final String symbol;
  final int score;
}
