import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _I = MatrixInput<_SpaceCell>;
typedef _O = NumericOutput<int>;

class Y2023D11 extends DayData<_I> {
  const Y2023D11() : super(year: 2023, day: 11);

  @override
  _I parseInput(String rawData) {
    return _I(
      Matrix.fromList(
        rawData
            .split('\n')
            .map((e) => e.split('').map(_SpaceCell.fromSymbol).toList())
            .toList(),
      ),
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
    return _run(inputData, dilation: 2);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _run(inputData, dilation: 1000000);
  }
}

enum _SpaceCell {
  empty('.'),
  galaxy('#');

  const _SpaceCell(this.symbol);
  factory _SpaceCell.fromSymbol(String s) =>
      values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}

NumericOutput<int> _run(_I inputData, {required int dilation}) {
  final matrix = inputData.matrix;

  final emptyColumnsIdx = matrix.columns.indexed
      .where((e) => e.$2.every((e) => e == _SpaceCell.empty))
      .map((e) => e.$1)
      .toList();

  final emptyRowsIdx = matrix.rows.indexed
      .where((e) => e.$2.every((e) => e == _SpaceCell.empty))
      .map((e) => e.$1)
      .toList();

  final galaxyIndexes = matrix.cells
      .where((c) => c.cell == _SpaceCell.galaxy)
      .map((c) => (c.r, c.c))
      .toList();

  return NumericOutput(
    galaxyIndexes
        .expand((e) => galaxyIndexes.map((e2) => (e, e2)))
        .where((e) => e.$1 < e.$2)
        .map((p) {
      final (from, to) = p;
      final rowBounds = [from.$1, to.$1]..sort();
      final columnBounds = [from.$2, to.$2]..sort();
      final emptyRowsCrossed = emptyRowsIdx
          .where((e) => e >= rowBounds.first && e <= rowBounds.last)
          .length;
      final emptyColumnsCrossed = emptyColumnsIdx
          .where((e) => e >= columnBounds.first && e <= columnBounds.last)
          .length;
      return (from.$1 - to.$1).abs() +
          (from.$2 - to.$2).abs() +
          (emptyRowsCrossed + emptyColumnsCrossed) * (dilation - 1);
    }).sum,
  );
}

extension on (int, int) {
  bool operator <((int, int) other) =>
      this.$1 < other.$1 || (this.$1 == other.$1 && this.$2 < other.$2);
}
