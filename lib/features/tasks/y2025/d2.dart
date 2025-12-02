import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = ListInput<(int, int)>;
typedef _O = NumericOutput<int>;

class Y2025D2 extends DayData<_I> {
  const Y2025D2() : super(2025, 2, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split(',')
        .map((e) => Tuple2.fromList(e.split('-').map(int.parse).toList()))
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values.expand((e) => e.$1.to(e.$2 + 1)).where(_isValid).sum,
  );

  bool _isValid(int id) => id.toString().apply(
    (s) =>
        s.length.isEven &&
        s.substring(0, s.length ~/ 2) == s.substring(s.length ~/ 2),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.values.expand((e) => e.$1.to(e.$2 + 1)).where(_isValid).sum,
  );

  bool _isValid(int id) => id.toString().apply(
    (s) => 1
        .to(s.length ~/ 2 + 1)
        .any((i) => s.substring(0, i) * (s.length ~/ i) == s),
  );
}
