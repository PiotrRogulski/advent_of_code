import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _SpringRecord = ({List<_Part> parts, List<int> damaged});

typedef _I = ListInput<_SpringRecord>;
typedef _O = NumericOutput<int>;

class Y2023D12 extends DayData<_I> {
  const Y2023D12() : super(2023, 12, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map((l) => l.split(' '))
          .map(
            (l) => (
              parts: l.first.split('').map(_Part.fromSymbol).toList(),
              damaged: l.last.split(',').map(int.parse).toList(),
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
    return _O(inputData.values.map((e) => _s(e.parts, null, e.damaged)).sum);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(
      inputData.values
          .map(
            (e) => _s(
              Iterable.generate(
                5,
                (_) => e.parts,
              ).separatedBy(() => [_Part.unknown]).flattenedToList,
              null,
              Iterable.generate(5, (_) => e.damaged).flattenedToList,
            ),
          )
          .sum,
    );
  }
}

enum _Part {
  ok('.'),
  damaged('#'),
  unknown('?');

  const _Part(this.symbol);
  factory _Part.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}

final _memo = <String, int>{};

int _s(List<_Part> s, int? currentRun, List<int> remain) {
  if (_memo[(s, currentRun, remain).toString()] case final memoized?) {
    return memoized;
  }
  if (s.isEmpty) {
    return switch ((currentRun, remain)) {
      (null, []) => 1,
      (final withinRun?, [final remain]) when withinRun == remain => 1,
      _ => 0,
    };
  }
  final possible = s
      .where((e) => e == _Part.damaged || e == _Part.unknown)
      .length;
  if ((currentRun != null &&
          (remain.isEmpty || possible + currentRun < remain.sum)) ||
      (currentRun == null && possible < remain.sum)) {
    return 0;
  }

  if (s[0] == _Part.ok && currentRun != null && currentRun != remain[0]) {
    return 0;
  }

  final [first, ...rest] = s;

  final ret = [
    if (first == _Part.ok && currentRun != null)
      _s(rest, null, remain.sublist(1)),
    if (first == _Part.unknown && currentRun != null && currentRun == remain[0])
      _s(rest, null, remain.sublist(1)),
    if ((first == _Part.damaged || first == _Part.unknown) &&
        currentRun != null)
      _s(rest, currentRun + 1, remain),
    if ((first == _Part.damaged || first == _Part.unknown) &&
        currentRun == null)
      _s(rest, 1, remain),
    if ((first == _Part.unknown || first == _Part.ok) && currentRun == null)
      _s(rest, null, remain),
  ].sum;

  _memo[(s, currentRun, remain).toString()] = ret;
  return ret;
}
