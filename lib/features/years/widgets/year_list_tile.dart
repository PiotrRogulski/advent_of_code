part of '../years_page.dart';

class const _YearListTile({
  required final int year,
  required final double progress,
  required final double completeProgress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          AocListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      AocText(year.toString()),
                      if (progress == 1)
                        AocIcon(
                          .check,
                          size: .large,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ProgressBar(
                    progress: progress,
                    completeProgress: completeProgress,
                  ),
                ),
              ],
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

class const _ProgressBar({
  required final double progress,
  required final double completeProgress,
}) extends HookWidget {
  static const _height = AocUnit.small;
  static final _borderRadius = AocBorderRadius(_height * 0.5);

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;

    final formatter = NumberFormat.percentPattern();

    final percentWidth = useMemoized(() {
      final painter = TextPainter(
        text: TextSpan(text: formatter.format(1), style: textStyle),
        textDirection: .ltr,
      )..layout();
      return painter.width * 1.1;
    });

    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: _borderRadius,
            child: Stack(
              children: [
                LinearProgressIndicator(
                  minHeight: _height,
                  value: progress,
                  borderRadius: _borderRadius,
                  backgroundColor: colors.surface,
                  color: colors.primary.withValues(alpha: 0.3),
                ),
                LinearProgressIndicator(
                  minHeight: _height,
                  backgroundColor: Colors.transparent,
                  value: completeProgress,
                  borderRadius: _borderRadius,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: percentWidth,
          child: AocText(formatter.format(completeProgress)),
        ),
      ],
    );
  }
}
