import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AocExpansionCard extends HookWidget {
  const AocExpansionCard({
    super.key,
    required this.title,
    this.titleTrailing,
    this.trailing,
    this.margin,
    this.bodyAlignment = .topCenter,
    this.aboveBody,
    this.body,
  });

  final String title;
  final Widget? titleTrailing;
  final Widget? trailing;
  final AocEdgeInsets? margin;
  final AlignmentGeometry bodyAlignment;
  final Widget? aboveBody;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final isExpanded = useState(false);

    return Card(
      margin: margin,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: AocUnit.small,
                children: [AocText(title), ?titleTrailing],
              ),
            ),
            ?trailing,
            AocUnit.small.gap,
            AnimatedRotation(
              turns: isExpanded.value ? 0.25 : -0.25,
              duration: Durations.medium1,
              curve: Curves.easeInOutCubicEmphasized,
              child: const AocIcon(.chevronLeft, size: .large),
            ),
          ],
        ),
        minTileHeight: AocUnit.xlarge * 2,
        tilePadding: const AocEdgeInsets.only(start: .xlarge, end: .large),
        maintainState: true,
        expandedCrossAxisAlignment: .stretch,
        expandedAlignment: .bottomCenter,
        expansionAnimationStyle: .new(
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
          duration: Durations.medium1,
        ),
        showTrailingIcon: false,
        onExpansionChanged: (value) => isExpanded.value = value,
        shape: const Border(),
        collapsedShape: const Border(),
        children: [
          ?aboveBody,
          Card(
            margin: const AocEdgeInsets.only(
              start: .small,
              end: .small,
              bottom: .small,
            ),
            color: colors.surface,
            shape: AocBorder(.medium),
            child: AnimatedSize(
              duration: Durations.medium1,
              curve: Curves.easeInOutCubicEmphasized,
              alignment: bodyAlignment,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
