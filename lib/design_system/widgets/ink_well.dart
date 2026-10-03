import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:material_ui/material_ui.dart';

class const AocInkWell({
  super.key,
  final GestureTapCallback? onTap,
  final Color? focusColor,
  final Color? hoverColor,
  final Color? highlightColor,
  final Color? splashColor,
  final AocBorderRadius? borderRadius,
  final Widget? child,
}) extends StatelessWidget {
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
