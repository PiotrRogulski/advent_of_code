import 'dart:math';

import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';

typedef _Coord = MatrixIndex;
typedef _CostGraph = Map<_Coord, Map<_Coord, int>>;

typedef _I = MatrixInput<_Tile>;
typedef _O = NumericOutput<int>;

class Y2023D23 extends DayData<_I> {
  const Y2023D23() : super(2023, 23, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return .new(
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
    final matrix = inputData.matrix;
    const start = (row: 0, column: 1);
    final target = (row: matrix.rowCount - 1, column: matrix.columnCount - 2);
    return .new(_dfs(matrix, {start}, start, target)!);
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final matrix = inputData.matrix;
    final graph = _mkCostGraph(matrix);
    const start = (row: 0, column: 1);
    final target = (row: matrix.rowCount - 1, column: matrix.columnCount - 2);
    return .new(_dfs2(graph, {start: 1}, start, target)!);
  }
}

enum _Tile {
  path('.'),
  forest('#'),
  slopeN('^'),
  slopeS('v'),
  slopeE('>'),
  slopeW('<');

  const _Tile(this.symbol);
  factory _Tile.fromSymbol(String s) => values.firstWhere((e) => e.symbol == s);

  final String symbol;

  @override
  String toString() => symbol;
}

Iterable<_Coord> _neighbors(Matrix<_Tile> m, _Coord v) {
  final (:row, :column) = v;
  return [
    (row: row - 1, column: column),
    (row: row + 1, column: column),
    (row: row, column: column - 1),
    (row: row, column: column + 1),
  ].where(m.isIndexInBounds);
}

int? _dfs(Matrix<_Tile> m, Set<_Coord> visited, _Coord coord, _Coord target) {
  if (coord == target) {
    return visited.length - 1;
  }
  final neighbors = switch (m.at(coord.row, coord.column)) {
    .path => _neighbors(m, coord),
    .slopeN => [(row: coord.row - 1, column: coord.column)],
    .slopeS => [(row: coord.row + 1, column: coord.column)],
    .slopeE => [(row: coord.row, column: coord.column + 1)],
    .slopeW => [(row: coord.row, column: coord.column - 1)],
    .forest => throw StateError('Cannot walk on a forest tile'),
  };

  int? best;
  for (final neighbor in neighbors) {
    final (:row, :column) = neighbor;
    if (visited.contains(neighbor) || m.at(row, column) == .forest) {
      continue;
    }
    visited.add(neighbor);
    final result = _dfs(m, visited, neighbor, target);
    best = switch ((best, result)) {
      (final best?, final result?) => max(best, result),
      _ => result ?? best,
    };
    visited.remove(neighbor);
  }
  return best;
}

_CostGraph _mkCostGraph(Matrix<_Tile> m) {
  final result = {
    for (final (:index, :value) in m.cells)
      if (value != .forest)
        index: {
          for (final neighbor in _neighbors(m, index))
            if (m.at(neighbor.row, neighbor.column) != .forest) neighbor: 1,
        },
  };
  final keys = result.keys.toList();
  for (final key in keys) {
    final neighbors = result[key]!;
    if (neighbors.length == 2) {
      final [left, right] = neighbors.keys.toList();
      result[left]?.remove(key);
      result[right]?.remove(key);
      result[left]![right] = max(
        result[left]?[right] ?? 0,
        neighbors[left]! + neighbors[right]!,
      );
      result[right]![left] = result[left]![right]!;
      result.remove(key);
    }
  }
  return result;
}

int? _dfs2(
  _CostGraph m,
  Map<_Coord, int> visited,
  _Coord coord,
  _Coord target,
) {
  if (coord == target) {
    return visited.values.sum - 1;
  }
  int? best;
  for (final neighbor in m[coord]!.keys) {
    if (visited.containsKey(neighbor)) {
      continue;
    }
    visited[neighbor] = m[coord]![neighbor]!;
    final result = _dfs2(m, visited, neighbor, target);
    best = switch ((best, result)) {
      (final best?, final result?) => max(best, result),
      _ => result ?? best,
    };
    visited.remove(neighbor);
  }
  return best;
}
