import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _I = ListInput<List<int>>;
typedef _O = NumericOutput<int>;

class const Y2024D2() extends DayData<_I> {
  this : super(2024, 2, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((l) => l.split(' ').map(int.parse).toList())
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(inputData.values.count(_isReportSafe));
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
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
