import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AocExpansionCard extends HookWidget {
  const AocExpansionCard({
    super.key,
    required this.title,
    this.trailing,
    this.margin,
    this.bodyAlignment = .topCenter,
    this.aboveBody,
    this.body,
  });

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? margin;
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
            Expanded(child: Text(title)),
            ?trailing,
            const SizedBox(width: 16),
            AnimatedRotation(
              turns: isExpanded.value ? 0.25 : -0.25,
              duration: Durations.medium1,
              curve: Curves.easeInOutCubicEmphasized,
              child: const AocIcon(.chevronLeft, size: 24),
            ),
          ],
        ),
        tilePadding: const .directional(start: 32, end: 24, top: 8, bottom: 8),
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
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            color: colors.surface,
            shape: RoundedSuperellipseBorder(borderRadius: .circular(10)),
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
