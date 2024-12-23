import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

typedef _Move = ({MatrixIndex position, _D dir});

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2023D16 extends DayData<_I> {
  const Y2023D16() : super(2023, 16, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return _I(
      rawData
          .split('\n')
          .map((e) => e.split('').map(_Tile.fromSymbol).toList())
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(
      _energize(
        from: (position: (row: 0, column: 0), dir: _D.right),
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
      for (final column in 0.to(matrix.columnCount)) ...[
        (position: (row: 0, column: column), dir: _D.down),
        (position: (row: matrix.rowCount - 1, column: column), dir: _D.up),
      ],
      for (final row in 0.to(matrix.rowCount)) ...[
        (position: (row: row, column: 0), dir: _D.right),
        (position: (row: row, column: matrix.columnCount - 1), dir: _D.left),
      ],
    ];
    return _O(
      allEnterPoints.map((e) => _energize(from: e, matrix: matrix)).max,
    );
  }
}

int _energize({required _Move from, required Matrix<_Tile> matrix}) {
  var nextTiles = {from};
  final visited = {...nextTiles};
  while (nextTiles.isNotEmpty) {
    nextTiles =
        nextTiles
            .expand((tile) => _nextMoves(matrix, tile))
            .whereNot(visited.contains)
            .where((e) => matrix.isIndexInBounds(e.position))
            .toSet();
    visited.addAll(nextTiles);
  }
  return visited.map((e) => e.position).toSet().length;
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

  MatrixIndexDelta get diff => switch (this) {
    up => (dr: -1, dc: 0),
    down => (dr: 1, dc: 0),
    left => (dr: 0, dc: -1),
    right => (dr: 0, dc: 1),
  };
}

Iterable<_Move> _nextMoves(Matrix<_Tile> matrix, _Move move) {
  final (:position, :dir) = move;
  final tile = matrix.atIndex(position);

  return switch (tile) {
    _Tile.empty => [(position: position + dir.diff, dir: dir)],
    _Tile.mirrorR => switch (dir) {
      _D.up || _D.down => [(position: position + dir.rotL.diff, dir: dir.rotL)],
      _D.left ||
      _D.right => [(position: position + dir.rotR.diff, dir: dir.rotR)],
    },
    _Tile.mirrorL => switch (dir) {
      _D.up || _D.down => [(position: position + dir.rotR.diff, dir: dir.rotR)],
      _D.left ||
      _D.right => [(position: position + dir.rotL.diff, dir: dir.rotL)],
    },
    _Tile.splitH => switch (dir) {
      _D.left || _D.right => [(position: position + dir.diff, dir: dir)],
      _D.up || _D.down => [
        (position: position + _D.left.diff, dir: _D.left),
        (position: position + _D.right.diff, dir: _D.right),
      ],
    },
    _Tile.splitV => switch (dir) {
      _D.up || _D.down => [(position: position + dir.diff, dir: dir)],
      _D.left || _D.right => [
        (position: position + _D.up.diff, dir: _D.up),
        (position: position + _D.down.diff, dir: _D.down),
      ],
    },
  };
}
