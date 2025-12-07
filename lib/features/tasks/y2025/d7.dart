import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart' hide IndexedIterableExtension;

typedef _I = MatrixInput<String>;
typedef _O = NumericOutput<int>;

class Y2025D7 extends DayData<_I> {
  const Y2025D7() : super(2025, 7, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      .new(rawData.split('\n').map((l) => l.split('')).toList(), dense: true);
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.matrix.apply(_processBeams).splitCount);
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) =>
      .new(inputData.matrix.apply(_processBeams).timelineCount);
}

({int splitCount, int timelineCount}) _processBeams(Matrix<String> matrix) {
  final timelineCounts = Matrix.fromList(
    .generate(matrix.rowCount, (_) => .filled(matrix.columnCount, 0)),
  );
  var splitCount = 0;

  final startColumn = matrix.rows[0].indexWhere((e) => e == 'S');
  timelineCounts.rows[1][startColumn]++;

  for (final i in 2.to(matrix.rowCount)) {
    final incomingBeams = matrix.rows[i - 1].indexed
        .where((e) => timelineCounts.rows[i - 1][e.$1] > 0)
        .map((e) => e.$1)
        .toList();
    for (final beam in incomingBeams) {
      final count = timelineCounts.rows[i - 1][beam];
      if (matrix.rows[i][beam] == '^') {
        splitCount++;
        timelineCounts
          ..rows[i][beam - 1] += count
          ..rows[i][beam + 1] += count;
      } else {
        timelineCounts.rows[i][beam] += count;
      }
    }
  }

  return (splitCount: splitCount, timelineCount: timelineCounts.rows.last.sum);
}
