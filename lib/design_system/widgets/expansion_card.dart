import 'package:flutter/material.dart';

class AocExpansionCard extends StatelessWidget {
  const AocExpansionCard({
    super.key,
    required this.title,
    this.controller,
    this.margin,
    this.child,
  });

  final String title;
  final ExpansionTileController? controller;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: margin,
      child: ExpansionTile(
        title: Text(title),
        controller: controller,
        maintainState: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        expandedAlignment: Alignment.topCenter,
        children: [
          Card(
            margin: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
            ),
            color: colors.surface,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: colors.outline,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
