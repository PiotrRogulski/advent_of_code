import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/matrix.dart';
import 'package:advent_of_code/common/widgets/visualization_stat.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:more/collection.dart' hide IndexedIterableExtension;

typedef _I = MatrixInput<String>;

class Y2025D4Visualizer extends DayVisualizer<_I> {
  const Y2025D4Visualizer()
    : super(2025, 4, commonVisualizer: const .new(_part1and2));
}

Widget _part1and2(_I input) => HookBuilder(
  builder: (context) {
    final s = context.l10n;

    final indicesToRemove = useState(<MatrixIndex>{});
    final removedCount = useState(0);
    final grid = useState(input.matrix);

    useEffect(() {
      var canceled = false;

      () async {
        await Future<void>.delayed(const .new(milliseconds: 1000));

        while (true) {
          if (canceled) {
            return;
          }

          final currentGrid = grid.value;
          final toRemove = currentGrid.cells
              .where(
                (c) =>
                    c.value == '@' &&
                    currentGrid
                            .neighborsOfIndex(c.index)
                            .where((c) => c.value == '@')
                            .length <
                        4,
              )
              .map((e) => e.index)
              .toSet();
          if (toRemove.isEmpty) {
            break;
          }

          indicesToRemove.value = toRemove;
          await Future<void>.delayed(const .new(milliseconds: 300));

          final newGrid = currentGrid.copy();
          for (final idx in toRemove) {
            newGrid.setIndex(idx, '.');
          }
          grid.value = newGrid;
          removedCount.value += toRemove.length;
          indicesToRemove.value = {};
          await Future<void>.delayed(const .new(milliseconds: 300));
        }
      }();

      return () => canceled = true;
    }, []);

    return AocPadding(
      padding: const .all(.xlarge),
      child: Row(
        crossAxisAlignment: .stretch,
        children: [
          Center(
            child: VisualizationStat.single(
              value: removedCount.value,
              label: s.visualizer_2025_04_removedCountLabel,
            ),
          ),
          Expanded(
            child: _GridView(grid: grid.value, toRemove: indicesToRemove.value),
          ),
        ],
      ),
    );
  },
);

class _GridView extends StatelessWidget {
  const _GridView({required this.grid, required this.toRemove});

  final Matrix<String> grid;
  final Set<MatrixIndex> toRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomPaint(
      painter: _GridPainter(
        grid: grid,
        colorScheme: theme.colorScheme,
        toRemove: toRemove,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.grid,
    required this.colorScheme,
    required this.toRemove,
  });

  final Matrix<String> grid;
  final ColorScheme colorScheme;
  final Set<MatrixIndex> toRemove;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final itemCount = grid.rowCount;
    final itemSide = side / itemCount;

    final centerSquare = Rect.fromCenter(
      center: size.center(.zero),
      width: side,
      height: side,
    );
    canvas
      ..save()
      ..translate(centerSquare.left, centerSquare.top);

    final borderPaint = Paint()
      ..color = colorScheme.outlineVariant
      ..strokeWidth = 0
      ..strokeCap = .round;
    for (final i in 0.to(itemCount + 1)) {
      canvas.drawLine(
        .new(0, i * itemSide),
        .new(side, i * itemSide),
        borderPaint,
      );
    }
    for (final i in 0.to(itemCount + 1)) {
      canvas.drawLine(
        .new(i * itemSide, 0),
        .new(i * itemSide, side),
        borderPaint,
      );
    }

    final regularPaint = Paint()..color = colorScheme.primary;
    final toRemovePaint = Paint()..color = colorScheme.error;

    for (final (:value, :index) in grid.cells) {
      if (value == '@') {
        canvas.drawRSuperellipse(
          .fromRectAndRadius(
            .fromCircle(
              center: .new(
                index.column * itemSide + itemSide / 2,
                index.row * itemSide + itemSide / 2,
              ),
              radius: itemSide / 2.5,
            ),
            .circular(itemSide / 4),
          ),
          toRemove.contains(index) ? toRemovePaint : regularPaint,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) =>
      grid != oldDelegate.grid ||
      colorScheme != oldDelegate.colorScheme ||
      !setEquals(toRemove, oldDelegate.toRemove);
}
