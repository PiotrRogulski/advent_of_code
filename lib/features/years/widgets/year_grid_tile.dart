part of '../years_page.dart';

class _YearGridTile extends StatelessWidget {
  const _YearGridTile({
    required this.year,
    required this.progress,
    required this.completeProgress,
  });

  final int year;
  final double progress;
  final double completeProgress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: _ProgressIndicator(
                progress: progress,
                completeProgress: completeProgress,
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: .circular(8)),
                clipBehavior: .antiAlias,
                child: BackdropFilter(
                  filter: .blur(sigmaX: 4, sigmaY: 4),
                  child: Padding(
                    padding: const .all(4),
                    child: Text(
                      year.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              type: .transparency,
              child: InkWell(onTap: () => YearRoute(year: year).go(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.progress,
    required this.completeProgress,
  });

  final double progress;
  final double completeProgress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = constraints.biggest.shortestSide;

        if (completeProgress == 1.0) {
          return AocIcon(.check, color: colors.primary, size: maxSize);
        }

        return SizedBox.square(
          dimension: maxSize * 0.85,
          child: Stack(
            children: [
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  strokeCap: .round,
                  backgroundColor: colors.surface,
                  color: colors.primary.withValues(alpha: 0.3),
                ),
              ),
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: completeProgress,
                  strokeWidth: 8,
                  strokeCap: .round,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
