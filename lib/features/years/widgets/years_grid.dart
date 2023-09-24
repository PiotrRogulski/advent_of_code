import 'dart:math';

import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:flutter/material.dart';

class SliverYearsGrid extends StatelessWidget {
  const SliverYearsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
      delegate: SliverChildBuilderDelegate(
        childCount: 25,
        (context, index) {
          return _YearTile(
            year: 2000 + index,
            progress: index / 24,
            completeProgress: pow(index / 24, 2).toDouble(),
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
    required this.completeProgress,
  });

  final int year;
  final double progress;
  final double completeProgress;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
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
                      .surfaceVariant
                      .withOpacity(0.75),
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

  static const _size = 96.0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (completeProgress == 1.0) {
      return AocIcon(
        AocIcons.check,
        color: colors.primary,
        size: _size * 1.25,
      );
    }

    return SizedBox.square(
      dimension: _size,
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
  }
}
