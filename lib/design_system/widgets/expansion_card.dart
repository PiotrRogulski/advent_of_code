import 'package:flutter/material.dart';

class AocExpansionCard extends StatelessWidget {
  const AocExpansionCard({
    super.key,
    required this.title,
    this.trailing,
    this.controller,
    this.margin,
    this.aboveBody,
    this.body,
  });

  final String title;
  final Widget? trailing;
  final ExpansionTileController? controller;
  final EdgeInsetsGeometry? margin;
  final Widget? aboveBody;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: margin,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), if (trailing != null) trailing!],
        ),
        controller: controller,
        maintainState: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        expandedAlignment: Alignment.topCenter,
        children: [
          if (aboveBody != null) aboveBody!,
          Card(
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            color: colors.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: colors.outline, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOutCubicEmphasized,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
