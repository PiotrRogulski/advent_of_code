import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:flutter/material.dart';

class AocInkWell extends StatelessWidget {
  const AocInkWell({
    super.key,
    this.onTap,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.borderRadius,
    this.child,
  });

  final GestureTapCallback? onTap;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? highlightColor;
  final Color? splashColor;
  final AocBorderRadius? borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // This is the definition
    // ignore: leancode_lint/use_design_system_item
    return InkWell(
      statesController: DynamicWeight.maybeOf(context)?.controller,
      onTap: onTap,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      borderRadius: borderRadius?.resolve(Directionality.of(context)),
      child: child,
    );
  }
}
