import 'package:advent_of_code/common/extensions/int.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/comparator.dart';

typedef _Vertex = ({int r, int c});
typedef _VertexDir<D extends _D?> = ({_Vertex v, D dir});

typedef _I = MatrixInput<int>;
typedef _O = NumericOutput<int>;

class Y2023D17 extends DayData<_I> {
  const Y2023D17() : super(year: 2023, day: 17);

  @override
  _I parseInput(String rawData) {
    return _I(
      Matrix.fromList(
        rawData
            .split('\n')
            .map((e) => e.split('').map(int.parse).toList())
            .toList(),
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
    return _O(_dist(inputData.matrix, minStep: 1, maxStep: 3));
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return _O(_dist(inputData.matrix, minStep: 4, maxStep: 10));
  }
}

enum _D {
  down(0, 1),
  right(1, 0),
  up(0, -1),
  left(-1, 0);

  const _D(this.dr, this.dc);

  final int dr;
  final int dc;

  bool isOpposite(_D other) => dr == -other.dr && dc == -other.dc;
}

int _dist(
  Matrix<int> matrix, {
  required int minStep,
  required int maxStep,
}) {
  final visited = <_VertexDir<_D?>>{};
  final costs = <_VertexDir<_D>, int>{};

  final q = PriorityQueue<_VertexDir<_D?>>(
    naturalComparable<num>.nullsFirst.onResultOf((e) => costs[e]),
  )..add((v: (r: 0, c: 0), dir: null));

  while (q.isNotEmpty) {
    final u = q.removeFirst();
    final (v: (:r, :c), :dir) = u;
    final cost = costs[u] ?? 0;
    if (r == matrix.rowCount - 1 && c == matrix.columnCount - 1) {
      return cost;
    }
    if (visited.contains(u)) {
      continue;
    }
    visited.add(u);
    for (final direction in _D.values) {
      if (direction == dir || (dir != null && direction.isOpposite(dir))) {
        continue;
      }
      var costD = 0;
      for (final distance in 1.to(maxStep + 1)) {
        final newR = r + direction.dr * distance;
        final newC = c + direction.dc * distance;
        final newU = (v: (r: newR, c: newC), dir: direction);
        if (matrix.isIndexInBounds(newR, newC)) {
          costD += matrix(newR, newC);
          if (distance < minStep) {
            continue;
          }
          final newCost = cost + costD;
          if (costs[newU] case final cc? when cc <= newCost) {
            continue;
          }
          costs[newU] = newCost;
          q.add(newU);
        }
      }
    }
  }

  throw StateError('No path found');
}
