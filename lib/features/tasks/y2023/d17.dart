import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _Vertex = ({int r, int c});
typedef _Delta = ({int dr, int dc});
typedef _VertexDir<D extends _D?> = ({_Vertex v, D dir});

typedef _I = MatrixInput<int>;
typedef _O = NumericOutput<int>;

class Y2023D17 extends DayData<_I> {
  const Y2023D17() : super(2023, 17, parts: const {1: _P1(), 2: _P2()});

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
  down(1, 0),
  right(0, 1),
  up(-1, 0),
  left(0, -1);

  const _D(this.dr, this.dc);

  final int dr;
  final int dc;

  bool isOpposite(_D other) => dr == -other.dr && dc == -other.dc;

  _Delta get delta => (dr: dr, dc: dc);
}

int _dist(Matrix<int> matrix, {required int minStep, required int maxStep}) {
  return DijkstraSearchIterable<_VertexDir<_D?>>(
        startVertices: [(v: (r: 0, c: 0), dir: null)],
        targetPredicate:
            (v) => v.v == (r: matrix.rowCount - 1, c: matrix.columnCount - 1),
        successorsOf:
            (v) => _D.values
                .where(
                  (d) => d != v.dir && (v.dir == null || !d.isOpposite(v.dir!)),
                )
                .expand(
                  (d) => minStep
                      .to(maxStep + 1)
                      .map((distance) => v.v + d.delta * distance)
                      .where((newV) => matrix.isIndexInBounds(newV.r, newV.c))
                      .map((newV) => (v: newV, dir: d)),
                ),
        edgeCost: (v1, v2) {
          final (r: r1, c: c1) = v1.v;
          final (r: r2, c: c2) = v2.v;
          final costs = switch (r1 == r2) {
            true => switch (c1 < c2) {
              true => (c1 + 1).to(c2 + 1).map((c) => matrix(r1, c)),
              false => c2.to(c1).map((c) => matrix(r1, c)),
            },
            false => switch (r1 < r2) {
              true => (r1 + 1).to(r2 + 1).map((r) => matrix(r, c1)),
              false => r2.to(r1).map((r) => matrix(r, c1)),
            },
          };
          return costs.sum;
        },
      )
      .min(comparator: naturalComparable<num>.onResultOf((e) => e.cost))
      .cost
      .toInt();
}

extension on _Vertex {
  _Vertex operator +(_Delta delta) => (r: r + delta.dr, c: c + delta.dc);
}

extension on _Delta {
  _Delta operator *(int factor) => (dr: dr * factor, dc: dc * factor);
}
