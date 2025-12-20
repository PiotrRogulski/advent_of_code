import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/ink_well.dart';
import 'package:flutter/material.dart';

class AocIconButton extends StatelessWidget {
  const AocIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.color,
    this.fill,
    this.iconPadding,
  });

  final AocIconData icon;
  final AocUnit iconSize;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fill;
  final AocEdgeInsets? iconPadding;

  @override
  Widget build(BuildContext context) {
    return DynamicWeight(
      child: Material(
        type: .transparency,
        shape: const CircleBorder(),
        clipBehavior: .antiAlias,
        child: AocInkWell(
          onTap: onPressed,
          child: AocPadding(
            padding: iconPadding ?? const .all(.small),
            child: AnimatedSwitcher(
              duration: Durations.medium1,
              switchInCurve: Curves.easeInOutCubicEmphasized,
              switchOutCurve: Curves.easeInOutCubicEmphasized.flipped,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              ),
              child: AocIcon(
                key: ValueKey(icon),
                icon,
                size: iconSize,
                color: color,
                fill: fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
