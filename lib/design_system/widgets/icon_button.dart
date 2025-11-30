import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/use_dynamic_weight.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AocIconButton extends HookWidget {
  const AocIconButton({
    super.key,
    required this.icon,
    required this.iconSize,
    this.onPressed,
    this.color,
    this.fill,
  });

  final AocIconData icon;
  final double iconSize;
  final VoidCallback? onPressed;
  final Color? color;
  final double? fill;

  @override
  Widget build(BuildContext context) {
    final (:weight, :fill, :controller) = useDynamicWeight();

    return Material(
      type: .transparency,
      shape: const CircleBorder(),
      clipBehavior: .antiAlias,
      child: InkWell(
        onTap: onPressed,
        statesController: controller,
        child: Padding(
          padding: const .all(8),
          child: AnimatedSwitcher(
            duration: Durations.medium1,
            switchInCurve: Curves.easeInOutCubicEmphasized,
            switchOutCurve: Curves.easeInOutCubicEmphasized.flipped,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: AocIcon(
              key: ValueKey(icon),
              icon,
              size: iconSize,
              color: color,
              fill: this.fill ?? fill,
              weight: weight,
            ),
          ),
        ),
      ),
    );
  }
}
