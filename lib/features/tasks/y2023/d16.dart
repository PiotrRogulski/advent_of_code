import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _Move = ({int r, int c, _D dir});

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2023D16 extends DayData<_I> {
  const Y2023D16() : super(2023, 16, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      Matrix.fromList(
        rawData
            .split('\n')
            .map((e) => e.split('').map(_Tile.fromSymbol).toList())
            .toList(),
      ),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(
      _energize(
        from: (r: 0, c: 0, dir: _D.right),
        matrix: inputData.matrix,
      ),
    );
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;
    final allEnterPoints = [
      for (final c in 0.to(matrix.columnCount)) ...[
        (r: 0, c: c, dir: _D.down),
        (r: matrix.rowCount - 1, c: c, dir: _D.up),
      ],
      for (final r in 0.to(matrix.rowCount)) ...[
        (r: r, c: 0, dir: _D.right),
        (r: r, c: matrix.columnCount - 1, dir: _D.left),
      ],
    ];
    return _O(
      allEnterPoints.map((e) => _energize(from: e, matrix: matrix)).max,
    );
  }
}

int _energize({required _Move from, required Matrix<_Tile> matrix}) {
  var nextTiles = [from];
  final visited = {...nextTiles};
  while (nextTiles.isNotEmpty) {
    nextTiles = nextTiles
        .expand((tile) => _nextMoves(matrix, tile))
        .whereNot(visited.contains)
        .where((e) => matrix.isIndexInBounds(e.r, e.c))
        .toSet()
        .toList();
    visited.addAll(nextTiles);
  }
  return visited.map((e) => (e.r, e.c)).toSet().length;
}

enum _Tile {
  empty('.'),
  mirrorR(r'\'),
  mirrorL('/'),
  splitH('-'),
  splitV('|');

  const _Tile(this.symbol);
  factory _Tile.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}

enum _D {
  up,
  down,
  left,
  right;

  _D get rotR => switch (this) {
        up => right,
        down => left,
        left => up,
        right => down,
      };

  _D get rotL => switch (this) {
        up => left,
        down => right,
        left => down,
        right => up,
      };

  ({int r, int c}) get diff => switch (this) {
        up => (r: -1, c: 0),
        down => (r: 1, c: 0),
        left => (r: 0, c: -1),
        right => (r: 0, c: 1),
      };
}

Iterable<_Move> _nextMoves(Matrix<_Tile> matrix, _Move move) {
  final (:r, :c, :dir) = move;
  final tile = matrix(r, c);

  return switch (tile) {
    _Tile.empty => [(r: r + dir.diff.r, c: c + dir.diff.c, dir: dir)],
    _Tile.mirrorR => switch (dir) {
        _D.up || _D.down => [
            (r: r + dir.rotL.diff.r, c: c + dir.rotL.diff.c, dir: dir.rotL),
          ],
        _D.left || _D.right => [
            (r: r + dir.rotR.diff.r, c: c + dir.rotR.diff.c, dir: dir.rotR),
          ],
      },
    _Tile.mirrorL => switch (dir) {
        _D.up || _D.down => [
            (r: r + dir.rotR.diff.r, c: c + dir.rotR.diff.c, dir: dir.rotR),
          ],
        _D.left || _D.right => [
            (r: r + dir.rotL.diff.r, c: c + dir.rotL.diff.c, dir: dir.rotL),
          ],
      },
    _Tile.splitH => switch (dir) {
        _D.left || _D.right => [
            (r: r + dir.diff.r, c: c + dir.diff.c, dir: dir),
          ],
        _D.up || _D.down => [
            (r: r + _D.left.diff.r, c: c + _D.left.diff.c, dir: _D.left),
            (r: r + _D.right.diff.r, c: c + _D.right.diff.c, dir: _D.right),
          ],
      },
    _Tile.splitV => switch (dir) {
        _D.up || _D.down => [
            (r: r + dir.diff.r, c: c + dir.diff.c, dir: dir),
          ],
        _D.left || _D.right => [
            (r: r + _D.up.diff.r, c: c + _D.up.diff.c, dir: _D.up),
            (r: r + _D.down.diff.r, c: c + _D.down.diff.c, dir: _D.down),
          ],
      },
  };
}
