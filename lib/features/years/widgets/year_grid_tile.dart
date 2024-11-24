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
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    year.toString(),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => YearRoute(year: year).go(context),
              ),
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
        final size = constraints.biggest.shortestSide * 0.75;

        if (completeProgress == 1.0) {
          return AocIcon(
            AocIcons.check,
            color: colors.primary,
            size: size * 1.25,
          );
        }

        return SizedBox.square(
          dimension: size,
          child: Stack(
            children: [
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  backgroundColor: colors.surface,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: completeProgress,
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
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
