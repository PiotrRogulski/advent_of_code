import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/collection.dart';

class const _Move({required final MatrixIndex position, required final _D dir});

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class const Y2023D16() extends DayData<_I> {
  this : super(2023, 16, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) => .new(
    rawData
        .split('\n')
        .map((e) => e.split('').map(_Tile.fromSymbol).toList())
        .toList(),
  );
}

class const _P1() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    _energize(
      from: const .new(position: .new(row: 0, column: 0), dir: .right),
      matrix: inputData.matrix,
    ),
  );
}

class const _P2() extends PartImplementation<_I, _O> {
  this : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;
    final allEnterPoints = <_Move>[
      for (final column in 0.to(matrix.columnCount)) ...[
        .new(
          position: .new(row: 0, column: column),
          dir: .down,
        ),
        .new(
          position: .new(row: matrix.rowCount - 1, column: column),
          dir: .up,
        ),
      ],
      for (final row in 0.to(matrix.rowCount)) ...[
        .new(
          position: .new(row: row, column: 0),
          dir: .right,
        ),
        .new(
          position: .new(row: row, column: matrix.columnCount - 1),
          dir: .left,
        ),
      ],
    ];
    return .new(
      allEnterPoints.map((e) => _energize(from: e, matrix: matrix)).max,
    );
  }
}

int _energize({required _Move from, required Matrix<_Tile> matrix}) {
  var nextTiles = {from};
  final visited = {...nextTiles};
  while (nextTiles.isNotEmpty) {
    nextTiles = nextTiles
        .expand((tile) => _nextMoves(matrix, tile))
        .whereNot(visited.contains)
        .where((e) => matrix.isIndexInBounds(e.position))
        .toSet();
    visited.addAll(nextTiles);
  }
  return visited.map((e) => e.position).toSet().length;
}

enum _Tile(final String symbol) {
  empty('.'),
  mirrorR(r'\'),
  mirrorL('/'),
  splitH('-'),
  splitV('|');

  factory fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  @override
  String toString() => symbol;
}

enum _D(final MatrixIndexDelta diff) {
  up(.up),
  down(.down),
  left(.left),
  right(.right);

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
}

Iterable<_Move> _nextMoves(Matrix<_Tile> matrix, _Move move) {
  final _Move(:position, :dir) = move;
  final tile = matrix.atIndex(position);

  return switch (tile) {
    .empty => [.new(position: position + dir.diff, dir: dir)],
    .mirrorR => switch (dir) {
      .up || .down => [.new(position: position + dir.rotL.diff, dir: dir.rotL)],
      .left ||
      .right => [.new(position: position + dir.rotR.diff, dir: dir.rotR)],
    },
    .mirrorL => switch (dir) {
      .up || .down => [.new(position: position + dir.rotR.diff, dir: dir.rotR)],
      .left ||
      .right => [.new(position: position + dir.rotL.diff, dir: dir.rotL)],
    },
    .splitH => switch (dir) {
      .left || .right => [.new(position: position + dir.diff, dir: dir)],
      .up || .down => [
        .new(position: position + _D.left.diff, dir: .left),
        .new(position: position + _D.right.diff, dir: .right),
      ],
    },
    .splitV => switch (dir) {
      .up || .down => [.new(position: position + dir.diff, dir: dir)],
      .left || .right => [
        .new(position: position + _D.up.diff, dir: .up),
        .new(position: position + _D.down.diff, dir: .down),
      ],
    },
  };
}
