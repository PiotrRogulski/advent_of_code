import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:collection/collection.dart';
import 'package:more/more.dart';

typedef _I = MatrixInput<String>;
typedef _O = NumericOutput<int>;

class Y2024D12 extends DayData<_I> {
  const Y2024D12() : super(2024, 12, parts: const {1: _P1(), 2: _P2()});

  @override
  _I parseInput(String rawData) =>
      _I(rawData.split('\n').map((l) => l.split('')).toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .fold(Graph<MatrixCell<String>, void>.undirected(), (g, c) {
          g.addVertex(c);
          final ns =
              [
                inputData.matrix.maybeCellAtIndex(c.index + (dr: 1, dc: 0)),
                inputData.matrix.maybeCellAtIndex(c.index + (dr: 0, dc: 1)),
                inputData.matrix.maybeCellAtIndex(c.index + (dr: -1, dc: 0)),
                inputData.matrix.maybeCellAtIndex(c.index + (dr: 0, dc: -1)),
              ].nonNulls;
          for (final n in ns) {
            if (n.value == c.value) {
              g.addEdge(c, n);
            }
          }

          return g;
        })
        .connected()
        .map((g) {
          if (g.edges.isEmpty) {
            return 4;
          }
          final area = g.vertices.length;
          final perimeter = 4 * area - g.edges.length;
          return area * perimeter;
        })
        .sum,
  );
}

class _P2 extends PartImplementation<_I, _O> {
  const _P2() : super(completed: true);

  @override
  _O runInternal(_I inputData) => _O(
    inputData.matrix.cells
        .fold(Graph<MatrixCell<String>, void>.undirected(), (g, c) {
          g.addVertex(c);
          final ns =
              [
                inputData.matrix.maybeCellAtIndex(c.index + (dr: 1, dc: 0)),
                inputData.matrix.maybeCellAtIndex(c.index + (dr: 0, dc: 1)),
                inputData.matrix.maybeCellAtIndex(c.index + (dr: -1, dc: 0)),
                inputData.matrix.maybeCellAtIndex(c.index + (dr: 0, dc: -1)),
              ].nonNulls;
          for (final n in ns) {
            if (n.value == c.value) {
              g.addEdge(c, n);
            }
          }

          return g;
        })
        .connected()
        .map((g) {
          if (g.edges.isEmpty) {
            return 4;
          }
          final corners =
              g.vertices.expand((v) {
                final upLeft = inputData.matrix.maybeAtIndex(
                  v.index + (dr: -1, dc: -1),
                );
                final up = inputData.matrix.maybeAtIndex(
                  v.index + (dr: -1, dc: 0),
                );
                final upRight = inputData.matrix.maybeAtIndex(
                  v.index + (dr: -1, dc: 1),
                );
                final left = inputData.matrix.maybeAtIndex(
                  v.index + (dr: 0, dc: -1),
                );
                final right = inputData.matrix.maybeAtIndex(
                  v.index + (dr: 0, dc: 1),
                );
                final downLeft = inputData.matrix.maybeAtIndex(
                  v.index + (dr: 1, dc: -1),
                );
                final down = inputData.matrix.maybeAtIndex(
                  v.index + (dr: 1, dc: 0),
                );
                final downRight = inputData.matrix.maybeAtIndex(
                  v.index + (dr: 1, dc: 1),
                );

                return {
                  if (up != v.value && left != v.value ||
                      up == v.value && left == v.value && upLeft != v.value)
                    (v.index, _CornerDir.nw),
                  if (up != v.value && right != v.value ||
                      up == v.value && right == v.value && upRight != v.value)
                    (v.index, _CornerDir.ne),
                  if (down != v.value && left != v.value ||
                      down == v.value && left == v.value && downLeft != v.value)
                    (v.index, _CornerDir.sw),
                  if (down != v.value && right != v.value ||
                      down == v.value &&
                          right == v.value &&
                          downRight != v.value)
                    (v.index, _CornerDir.se),
                };
              }).toSet();

          return corners.length * g.vertices.length;
        })
        .sum,
  );
}

enum _CornerDir { ne, nw, se, sw }