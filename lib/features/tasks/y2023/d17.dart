import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _VertexDir<D extends _D?> = ({MatrixIndex v, D dir});

typedef _I = MatrixInput<int>;
typedef _O = NumericOutput<int>;

class Y2023D17 extends DayData<_I> {
  const Y2023D17() : super(2023, 17, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) {
    return .new(
      rawData
          .split('\n')
          .map((e) => e.split('').map(int.parse).toList())
          .toList(),
    );
  }
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return .new(_dist(inputData.matrix, minStep: 1, maxStep: 3));
  }
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) {
    return .new(_dist(inputData.matrix, minStep: 4, maxStep: 10));
  }
}

enum _D {
  down(1, 0),
  right(0, 1),
  up(-1, 0),
  left(0, -1);

  const _D(this.dr, this.dc);

  final int dr;
  final int dc;

  bool isOpposite(_D other) => dr == -other.dr && dc == -other.dc;

  MatrixIndexDelta get delta => (dr: dr, dc: dc);
}

int _dist(Matrix<int> matrix, {required int minStep, required int maxStep}) {
  return dijkstraSearch<_VertexDir<_D?>>(
    startVertices: [(v: (row: 0, column: 0), dir: null)],
    targetPredicate: (v) =>
        v.v == (row: matrix.rowCount - 1, column: matrix.columnCount - 1),
    successorsOf: (v) => _D.values
        .where((d) => d != v.dir && (v.dir == null || !d.isOpposite(v.dir!)))
        .expand(
          (d) => minStep
              .to(maxStep + 1)
              .map((distance) => v.v + d.delta * distance)
              .where(matrix.isIndexInBounds)
              .map((newV) => (v: newV, dir: d)),
        ),
    edgeCost: (v1, v2) {
      final (row: r1, column: c1) = v1.v;
      final (row: r2, column: c2) = v2.v;
      final costs = switch (r1 == r2) {
        true => switch (c1 < c2) {
          true => (c1 + 1).to(c2 + 1).map((c) => matrix.at(r1, c)),
          false => c2.to(c1).map((c) => matrix.at(r1, c)),
        },
        false => switch (r1 < r2) {
          true => (r1 + 1).to(r2 + 1).map((r) => matrix.at(r, c1)),
          false => r2.to(r1).map((r) => matrix.at(r, c1)),
        },
      };
      return costs.sum;
    },
  ).min(comparator: naturalComparable<num>.keyOf((e) => e.cost)).cost.toInt();
}
