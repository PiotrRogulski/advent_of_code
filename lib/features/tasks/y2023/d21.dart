import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/collection.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2023D21 extends DayData<_I> {
  const Y2023D21() : super(2023, 21, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData.split('\n').map((line) {
        return line.split('').map(_Tile.fromSymbol).toList();
      }).toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final start = inputData.matrix.cells.singleWhere(
      (e) => e.value == _Tile.start,
    );
    return _O(
      0.to(64).fold(
        {start.index},
        (front, i) =>
            front
                .expand(
                  (e) => {
                        (row: -1, column: 0),
                        (row: 1, column: 0),
                        (row: 0, column: -1),
                        (row: 0, column: 1),
                      }
                      .map(
                        (diff) => (
                          row: e.row + diff.row,
                          column: e.column + diff.column,
                        ),
                      )
                      .where(inputData.matrix.isIndexInBounds)
                      .where((e) => inputData.matrix.atIndex(e) != _Tile.rocks),
                )
                .toSet(),
      ).length,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static const steps = 26_501_365;

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;
    final (:columns, :rows) = matrix.size;
    final start = matrix.cells.singleWhere((e) => e.value == _Tile.start);

    var front = {start.index};
    final points = <int>[];
    for (final s in 1.to(steps)) {
      front =
          front
              .expand(
                (e) => {
                      (dr: -1, dc: 0),
                      (dr: 1, dc: 0),
                      (dr: 0, dc: -1),
                      (dr: 0, dc: 1),
                    }
                    .map(
                      (diff) => (
                        row: e.row + diff.dr,
                        column: e.column + diff.dc,
                      ),
                    )
                    .where(
                      (e) =>
                          matrix.isInBounds(e.row % rows, e.column % columns),
                    )
                    .where(
                      (e) =>
                          matrix.at(e.row % rows, e.column % columns) !=
                          _Tile.rocks,
                    ),
              )
              .toSet();
      if (s % rows == steps % rows) {
        points.add(front.length);
      }
      if (points.length == 3) {
        break;
      }
    }

    final [p0, p1, p2] = points;

    final c = p0;
    final a = (p2 - 2 * p1 + p0) ~/ 2;
    final b = p1 - p0 - a;
    final n = steps ~/ rows;
    return _O(a * n * n + b * n + c);
  }
}

enum _Tile {
  start('S'),
  garden('.'),
  rocks('#');

  const _Tile(this.symbol);
  factory _Tile.fromSymbol(String s) =>
      values.firstWhere((tile) => tile.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}
