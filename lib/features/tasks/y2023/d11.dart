import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart' hide IndexedIterableExtension;

typedef _I = MatrixInput<_SpaceCell>;
typedef _O = NumericOutput<int>;

class const Y2023D11() extends DayData<_I> {
  this : super(2023, 11, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((e) => e.split('').map(_SpaceCell.fromSymbol).toList())
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => _run(inputData, dilation: 2);
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => _run(inputData, dilation: 1_000_000);
}

enum _SpaceCell(final String symbol) {
  empty('.'),
  galaxy('#');

  factory fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  @override
  String toString() => symbol;
}

NumericOutput<int> _run(_I inputData, {required int dilation}) {
  final matrix = inputData.matrix;

  final emptyColumnsIdx = matrix.columns.indexed
      .where((e) => e.$2.every((e) => e == .empty))
      .map((e) => e.$1)
      .toList();

  final emptyRowsIdx = matrix.rows.indexed
      .where((e) => e.$2.every((e) => e == .empty))
      .map((e) => e.$1)
      .toList();

  final galaxyIndexes = matrix.cells.where((c) => c.value == .galaxy).toList();

  return NumericOutput(
    galaxyIndexes.combinations(2).map((p) {
      final [from, to] = p;
      final rowBounds = [from.index.row, to.index.row]..sort();
      final columnBounds = [from.index.column, to.index.column]..sort();
      final emptyRowsCrossed = emptyRowsIdx
          .where((e) => e >= rowBounds.first && e <= rowBounds.last)
          .length;
      final emptyColumnsCrossed = emptyColumnsIdx
          .where((e) => e >= columnBounds.first && e <= columnBounds.last)
          .length;
      return (from.index.row - to.index.row).abs() +
          (from.index.column - to.index.column).abs() +
          (emptyRowsCrossed + emptyColumnsCrossed) * (dilation - 1);
    }).sum,
  );
}
