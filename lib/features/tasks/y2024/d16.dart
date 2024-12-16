import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<String>;
typedef _O = NumericOutput<int>;

typedef _Node = ({MatrixIndex index, _Direction direction});

class Y2024D16 extends DayData<_I> {
  const Y2024D16() : super(2024, 16, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      _I(rawData.split('\n').map((l) => l.split('')).toList(), dense: true);
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    DijkstraSearchIterable(
      startVertices: [inputData.matrix.start],
      successorsOf: inputData.matrix.successorsOf,
      targetPredicate: inputData.matrix.isEnd,
      edgeCost: _cost,
    ).firstWhere((p) => inputData.matrix.isEnd(p.vertices.last)).cost.toInt(),
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    final start = inputData.matrix.start;

    final costs = {start: 0};
    final previous = {start: <_Node>[]};
    final queue = PriorityQueue<(int, _Node)>(
      (e1, e2) => e1.$1.compareTo(e2.$1),
    )..add((0, start));

    while (queue.isNotEmpty) {
      final (_, current) = queue.removeFirst();
      for (final neighbor in inputData.matrix.successorsOf(current)) {
        final newCost = costs[current]! + _cost(current, neighbor);
        if (!costs.containsKey(neighbor) || newCost < costs[neighbor]!) {
          costs[neighbor] = newCost;
          queue.add((newCost, neighbor));
          previous[neighbor] = [current];
        } else if (newCost == costs[neighbor]!) {
          previous[neighbor]!.add(current);
        }
      }
    }

    final end =
        costs.entries
            .where((e) => inputData.matrix.isEnd(e.key))
            .min(comparator: (e1, e2) => e1.value.compareTo(e2.value))
            .key;

    final visited = <MatrixIndex>{};
    final pathStack = [end];
    while (pathStack.isNotEmpty) {
      final current = pathStack.removeAt(0);
      visited.add(current.index);
      pathStack.addAll(previous[current]!);
    }

    return _O(visited.length);
  }
}

enum _Direction {
  N,
  E,
  W,
  S;

  MatrixIndexDelta get delta => switch (this) {
    N => (dr: -1, dc: 0),
    E => (dr: 0, dc: 1),
    W => (dr: 0, dc: -1),
    S => (dr: 1, dc: 0),
  };

  _Direction get clockwise => switch (this) {
    N => E,
    E => S,
    S => W,
    W => N,
  };

  _Direction get counterClockwise => switch (this) {
    N => W,
    W => S,
    S => E,
    E => N,
  };
}

extension on Matrix<String> {
  _Node get start => (
    index: cells.firstWhere((c) => c.value == 'S').index,
    direction: _Direction.E,
  );

  bool isEnd(_Node node) => atIndex(node.index) == 'E';

  Iterable<_Node> successorsOf(_Node node) => [
    (index: node.index + node.direction.delta, direction: node.direction),
    (index: node.index, direction: node.direction.clockwise),
    (index: node.index, direction: node.direction.counterClockwise),
  ].where((v) => isIndexInBounds(v.index) && atIndex(v.index) != '#');
}

int _cost(_Node n1, _Node n2) => n1.direction == n2.direction ? 1 : 1000;
