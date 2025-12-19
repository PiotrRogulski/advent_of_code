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
      .new(rawData.split('\n').map((l) => l.split('')).toList());
}

class _P1 extends PartImplementation<_I, _O> {
  const _P1() : super(completed: true);

  @override
  _O runInternal(_I inputData) => .new(
    inputData.matrix.cells
        .fold(Graph<MatrixCell<String>, void>(isDirected: false), (g, c) {
          g.addVertex(c);
          final ns = [
            inputData.matrix.maybeCellAtIndex(c.index.up),
            inputData.matrix.maybeCellAtIndex(c.index.down),
            inputData.matrix.maybeCellAtIndex(c.index.left),
            inputData.matrix.maybeCellAtIndex(c.index.right),
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
  _O runInternal(_I inputData) => .new(
    inputData.matrix.cells
        .fold(Graph<MatrixCell<String>, void>(isDirected: false), (g, c) {
          g.addVertex(c);
          final ns = [
            inputData.matrix.maybeCellAtIndex(c.index.up),
            inputData.matrix.maybeCellAtIndex(c.index.down),
            inputData.matrix.maybeCellAtIndex(c.index.left),
            inputData.matrix.maybeCellAtIndex(c.index.right),
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
          final corners = g.vertices.expand((v) {
            final m = inputData.matrix;
            final upLeft = m.maybeAtIndex(v.index.up.left);
            final up = m.maybeAtIndex(v.index.up);
            final upRight = m.maybeAtIndex(v.index.up.right);
            final left = m.maybeAtIndex(v.index.left);
            final right = m.maybeAtIndex(v.index.right);
            final downLeft = m.maybeAtIndex(v.index.down.left);
            final down = m.maybeAtIndex(v.index.down);
            final downRight = m.maybeAtIndex(v.index.down.right);

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
                  down == v.value && right == v.value && downRight != v.value)
                (v.index, _CornerDir.se),
            };
          }).toSet();

          return corners.length * g.vertices.length;
        })
        .sum,
  );
}

enum _CornerDir { ne, nw, se, sw }
