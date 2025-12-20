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
    final theme = Theme.of(context);

    return Card(
      child: Stack(
        alignment: .center,
        children: [
          _ProgressIndicator(
            progress: progress,
            completeProgress: completeProgress,
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: AocBorderRadius(.medium),
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.25,
                  ),
                ),
                clipBehavior: .antiAlias,
                child: BackdropFilter(
                  filter: .blur(sigmaX: 4, sigmaY: 4),
                  child: AocPadding(
                    padding: const .symmetric(
                      vertical: .xsmall,
                      horizontal: .small,
                    ),
                    child: AocText(
                      year.toString(),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              type: .transparency,
              child: AocInkWell(onTap: () => YearRoute(year: year).go(context)),
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
          return AocIcon(
            .check,
            color: colors.primary,
            size: AocUnit.xlarge * 4,
          );
        }

        return SizedBox.square(
          dimension: maxSize * 0.85,
          child: Stack(
            children: [
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: AocUnit.small,
                  strokeCap: .round,
                  backgroundColor: colors.surface,
                  color: colors.primary.withValues(alpha: 0.3),
                ),
              ),
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: completeProgress,
                  strokeWidth: AocUnit.small,
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
