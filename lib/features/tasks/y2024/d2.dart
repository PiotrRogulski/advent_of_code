import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<List<int>>;
typedef _O = NumericOutput<int>;

class Y2024D2 extends DayData<_I> {
  const Y2024D2() : super(2024, 2, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => _I(
    rawData
        .split('\n')
        .map((l) => l.split(' ').map(int.parse).toList())
        .toList(),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(inputData.values.count(_isReportSafe));
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.values.count(
      (xs) =>
          _isReportSafe(xs) ||
          xs.mapIndexed((i, _) => xs.toList()..removeAt(i)).any(_isReportSafe),
    ),
  );
}

bool _isReportSafe(Iterable<int> report) => report.diff.apply(
  (ds) =>
      ds.map((d) => d.sign).toSet().length == 1 &&
      ds.map((d) => d.abs()).every((d) => d >= 1 && d <= 3),
);
