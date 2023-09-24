import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' hide TextDirection;

class SliverYearsList extends StatelessWidget {
  const SliverYearsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 25,
        (context, index) {
          return _YearTile(
            year: index,
            progress: index / 24,
          );
        },
      ),
    );
  }
}

class _YearTile extends StatelessWidget {
  const _YearTile({
    required this.year,
    required this.progress,
  });

  final int year;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Stack(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Year ${year + 1}'),
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
                  child: _ProgressBar(progress: progress),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
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
  });

  final double progress;

  static const _height = 8.0;

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
          child: LinearProgressIndicator(
            minHeight: _height,
            backgroundColor: colors.surface,
            value: progress,
            borderRadius: BorderRadius.circular(_height / 2),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: percentWidth,
          child: Text(
            formatter.format(progress),
          ),
        ),
      ],
    );
  }
}