import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ListInput<int>;
typedef _O = NumericOutput<int>;

class Y2024D22 extends DayData<_I> {
  const Y2024D22() : super(2024, 22, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      _I(rawData.split('\n').map(int.parse).toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values.map((s) => s.iterate(_nextSecret).skip(2000).first).sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values
        .map(
          (initial) => initial
              .iterate(_nextSecret)
              .take(2001)
              .pairwise()
              .map((p) => (secret: p.$2, diff: p.$2 % 10 - p.$1 % 10))
              .toList()
              .apply(
                (data) => 0
                    .to(data.length - 3)
                    .reversed
                    .toMap(
                      key:
                          (i) => Tuple4.fromList(
                            data.sublist(i, i + 4),
                          ).mapAll((e) => e.diff),
                      value: (i) => data[i + 3].secret % 10,
                    ),
              ),
        )
        .toList()
        .apply(
          (allPrices) =>
              allPrices
                  .expand((prices) => prices.keys)
                  .toSet()
                  .map(
                    (diff) =>
                        allPrices.map((prices) => prices[diff]).nonNulls.sum,
                  )
                  .max,
        ),
  );
}

int _nextSecret(int secret) => secret
    .apply((s) => _mix(s, s * 64))
    .apply(_prune)
    .apply((s) => _mix(s, s ~/ 32))
    .apply(_prune)
    .apply((s) => _mix(s, s * 2048))
    .apply(_prune);

int _prune(int secret) => secret & ((1 << 24) - 1);

int _mix(int secret, int result) => secret ^ result;
