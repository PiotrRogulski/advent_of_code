import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

  @override
  _O runInternal(_I inputData) => NumericOutput(
    inputData.matrix
        .apply(
          (m) => [...m.columns, ...m.rows, ...m.diagonals, ...m.antiDiagonals],
        )
        .map(
          (l) => l
              .window(4)
              .count(
                (w) =>
                    listEquals(w, 'XMAS'.characters.toList()) ||
                    listEquals(w, 'SAMX'.characters.toList()),
              ),
        )
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return NumericOutput(
      inputData.matrix.apply(
        (m) => m.cells.count(
          (c) =>
              c.r >= 1 &&
              c.c >= 1 &&
              c.r <= m.rowCount - 2 &&
              c.c <= m.columnCount - 2 &&
              c.cell == 'A' &&
              (m(c.r - 1, c.c - 1) == 'S' && m(c.r + 1, c.c + 1) == 'M' ||
                  m(c.r - 1, c.c - 1) == 'M' && m(c.r + 1, c.c + 1) == 'S') &&
              (m(c.r - 1, c.c + 1) == 'S' && m(c.r + 1, c.c - 1) == 'M' ||
                  m(c.r - 1, c.c + 1) == 'M' && m(c.r + 1, c.c - 1) == 'S'),
        ),
      ),
    );
  }
}
