import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _HandWithBid = ({List<_Card> hand, int bid});

typedef _I = ListInput<_HandWithBid>;
typedef _O = NumericOutput<int>;

class Y2023D7 extends DayData<_I> {
  const Y2023D7() : super(2023, 7, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return ListInput(
      rawData
          .split('\n')
          .map((l) => l.split(' '))
          .map(
            (l) => (
              hand: l.first.split('').map(_Card.fromSymbol).toList(),
              bid: int.parse(l.last),
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
          .sorted(_compareHands)
          .mapIndexed((index, hand) => (index + 1) * hand.bid)
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
          .sorted((h1, h2) => _compareHands(h1, h2, sortJokersLast: true))
          .mapIndexed((index, hand) => (index + 1) * hand.bid)
          .sum,
    );
  }
}

enum _Card implements Comparable<_Card> {
  n2('2'),
  n3('3'),
  n4('4'),
  n5('5'),
  n6('6'),
  n7('7'),
  n8('8'),
  n9('9'),
  t('T'),
  j('J'),
  q('Q'),
  k('K'),
  a('A');

  const _Card(this.symbol);
  factory _Card.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  int compareTo(_Card other) => index.compareTo(other.index);

  @override
  String toString() => symbol;
}

enum _HandType implements Comparable<_HandType> {
  highCard,
  onePair,
  twoPair,
  threeOfAKind,
  fullHouse,
  fourOfAKind,
  fiveOfAKind;

  @override
  int compareTo(_HandType other) => index.compareTo(other.index);
}

int _compareHands(
  _HandWithBid hand1,
  _HandWithBid hand2, {
  bool sortJokersLast = false,
}) {
  final type1 = (sortJokersLast ? _getHandTypeWithJokers : _getHandType)(
    hand1.hand,
  );
  final type2 = (sortJokersLast ? _getHandTypeWithJokers : _getHandType)(
    hand2.hand,
  );
  if (type1 != type2) {
    return type1.compareTo(type2);
  }

  final card = (
    hand1.hand,
    hand2.hand,
  ).zip().firstWhereOrNull((pair) => pair.$1 != pair.$2);
  return switch (card) {
    null => 0,
    (_Card.j, _) when sortJokersLast => -1,
    (_, _Card.j) when sortJokersLast => 1,
    (final c1, final c2) => c1.compareTo(c2),
  };
}

_HandType _getHandType(List<_Card> hand, [_Card jokerValue = _Card.j]) {
  final counts = hand.fold(
    <_Card, int>{},
    (map, card) =>
        map..update(
          card == _Card.j ? jokerValue : card,
          (v) => v + 1,
          ifAbsent: () => 1,
        ),
  );
  final values = counts.values.toList()..sort();
  if (values.last == 5) {
    return _HandType.fiveOfAKind;
  } else if (values.last == 4) {
    return _HandType.fourOfAKind;
  } else if (values.last == 3) {
    if (values[values.length - 2] == 2) {
      return _HandType.fullHouse;
    } else {
      return _HandType.threeOfAKind;
    }
  } else if (values.last == 2) {
    if (values[values.length - 2] == 2) {
      return _HandType.twoPair;
    } else {
      return _HandType.onePair;
    }
  } else {
    return _HandType.highCard;
  }
}

_HandType _getHandTypeWithJokers(List<_Card> hand) {
  return _Card.values.map((jokerValue) => _getHandType(hand, jokerValue)).max;
}
