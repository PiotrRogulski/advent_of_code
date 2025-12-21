import 'package:advent_of_code/common/hooks/use_emphasize.dart';
import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/blur.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class VisualizationStat extends HookWidget {
  VisualizationStat.single({
    super.key,
    required this.value,
    required this.label,
  }) : shape = .horizontal(start: .large, end: .large);

  VisualizationStat.first({super.key, required this.value, required this.label})
    : shape = .horizontal(start: .large, end: .xsmall);

  VisualizationStat.middle({
    super.key,
    required this.value,
    required this.label,
  }) : shape = .horizontal(start: .xsmall, end: .xsmall);

  VisualizationStat.last({super.key, required this.value, required this.label})
    : shape = .horizontal(start: .xsmall, end: .large);

  final int value;
  final String label;

  final AocBorder shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final emphasisProgress = useEmphasize(value);

    return Container(
      decoration: ShapeDecoration(color: theme.cardTheme.color, shape: shape),
      foregroundDecoration: ShapeDecoration(
        shape: shape.copyWith(
          side: .new(
            color: theme.colorScheme.primary.withValues(
              alpha: emphasisProgress,
            ),
            width: 8 * emphasisProgress,
          ),
        ),
      ),
      child: AocPadding(
        padding: const .symmetric(vertical: .small, horizontal: .medium),
        child: Column(
          mainAxisSize: .min,
          children: [
            BlurSwitcher(
              child: AocText(
                key: ValueKey(value),
                value.toString(),
                style: theme.textTheme.displaySmall,
              ),
            ),
            AocText(label, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
