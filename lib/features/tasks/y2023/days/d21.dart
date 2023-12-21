import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:more/collection.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2023D21 extends DayData<_I> {
  const Y2023D21() : super(year: 2023, day: 21);

  @override
  _I parseInput(String rawData) {
    return _I(
      Matrix.fromList(
        rawData.split('\n').map((line) {
          return line.split('').map(_Tile.fromSymbol).toList();
        }).toList(),
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
    final start =
        inputData.matrix.cells.singleWhere((e) => e.cell == _Tile.start);
    return _O(
      0.to(64).fold(
        {(r: start.r, c: start.c)},
        (front, i) => front
            .expand(
              (e) => {
                (r: -1, c: 0),
                (r: 1, c: 0),
                (r: 0, c: -1),
                (r: 0, c: 1),
              }
                  .map((diff) => (r: e.r + diff.r, c: e.c + diff.c))
                  .where((e) => inputData.matrix.isIndexInBounds(e.r, e.c))
                  .where((e) => inputData.matrix(e.r, e.c) != _Tile.rocks),
            )
            .toSet(),
      ).length,
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  static const steps = 26501365;

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;
    final (:columns, :rows) = matrix.size;
    final start = matrix.cells.singleWhere((e) => e.cell == _Tile.start);

    var front = {(r: start.r, c: start.c)};
    final points = <int>[];
    for (final s in 1.to(steps)) {
      front = front
          .expand(
            (e) => {
              (dr: -1, dc: 0),
              (dr: 1, dc: 0),
              (dr: 0, dc: -1),
              (dr: 0, dc: 1),
            }
                .map((diff) => (r: e.r + diff.dr, c: e.c + diff.dc))
                .where((e) => matrix.isIndexInBounds(e.r % rows, e.c % columns))
                .where((e) => matrix(e.r % rows, e.c % columns) != _Tile.rocks),
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
