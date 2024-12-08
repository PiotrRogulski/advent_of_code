import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart' hide IndexedIterableExtension;

typedef _I = MatrixInput<_SpaceCell>;
typedef _O = NumericOutput<int>;

class Y2023D11 extends DayData<_I> {
  const Y2023D11() : super(2023, 11, parts: const {1: _P1(), 2: _P2()});

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
    return _run(inputData, dilation: 1_000_000);
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

  final emptyColumnsIdx =
      matrix.columns.indexed
          .where((e) => e.$2.every((e) => e == _SpaceCell.empty))
          .map((e) => e.$1)
          .toList();

  final emptyRowsIdx =
      matrix.rows.indexed
          .where((e) => e.$2.every((e) => e == _SpaceCell.empty))
          .map((e) => e.$1)
          .toList();

  final galaxyIndexes =
      matrix.cells.where((c) => c.value == _SpaceCell.galaxy).toList();

  return NumericOutput(
    galaxyIndexes.combinations(2).map((p) {
      final [from, to] = p;
      final rowBounds = [from.index.row, to.index.row]..sort();
      final columnBounds = [from.index.column, to.index.column]..sort();
      final emptyRowsCrossed =
          emptyRowsIdx
              .where((e) => e >= rowBounds.first && e <= rowBounds.last)
              .length;
      final emptyColumnsCrossed =
          emptyColumnsIdx
              .where((e) => e >= columnBounds.first && e <= columnBounds.last)
              .length;
      return (from.index.row - to.index.row).abs() +
          (from.index.column - to.index.column).abs() +
          (emptyRowsCrossed + emptyColumnsCrossed) * (dilation - 1);
    }).sum,
  );
}
