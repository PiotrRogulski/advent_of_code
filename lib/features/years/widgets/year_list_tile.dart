part of '../years_page.dart';

class _YearListTile extends StatelessWidget {
  const _YearListTile({
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
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(year.toString()),
                      if (progress == 1)
                        const AocIcon(
                          AocIcons.check,
                          size: 24,
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

class _ProgressBar extends HookWidget {
  const _ProgressBar({
    required this.progress,
    required this.completeProgress,
  });

  final double progress;
  final double completeProgress;

  static const _height = 8.0;
  static final _borderRadius = BorderRadius.circular(_height / 2);

  @override
  Widget build(BuildContext context) {
    final textStyle = DefaultTextStyle.of(context).style;

    final formatter = NumberFormat.percentPattern();

    final percentWidth = useMemoized(() {
      final painter = TextPainter(
        text: TextSpan(
          text: formatter.format(1),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      return painter.width;
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
                  backgroundColor: colors.surface,
                  value: progress,
                  borderRadius: _borderRadius,
                  color: Theme.of(context).disabledColor,
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
          child: Text(
            formatter.format(completeProgress),
          ),
        ),
      ],
    );
  }
}
