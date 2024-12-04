import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<String>;
typedef _O = NumericOutput<int>;

class Y2024D4 extends DayData<_I> {
  const Y2024D4() : super(2024, 4, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => MatrixInput(
    Matrix.fromList(rawData.split('\n').map((l) => l.split('')).toList()),
  );
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  static const _patterns = ['XMAS', 'SAMX'];

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.matrix
        .apply(
          (m) => [...m.columns, ...m.rows, ...m.diagonals, ...m.antiDiagonals],
        )
        .map((l) => l.window(4).count((w) => _patterns.contains(w.join())))
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static const _patterns = ['MAS', 'SAM'];

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.matrix.apply(
      (m) => m.cells.count(
        (c) => switch ((
          m.maybeAt(c.row - 1, c.column - 1),
          m.maybeAt(c.row - 1, c.column + 1),
          m.maybeAt(c.row + 1, c.column - 1),
          m.maybeAt(c.row + 1, c.column + 1),
        )) {
          (final upLeft?, final upRight?, final downLeft?, final downRight?) =>
            _patterns.contains('$upLeft${c.cell}$downRight') &&
                _patterns.contains('$upRight${c.cell}$downLeft'),
          _ => false,
        },
      ),
    ),
  );
}
