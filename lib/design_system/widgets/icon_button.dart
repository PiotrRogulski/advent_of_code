import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/ink_well.dart';
import 'package:material_ui/material_ui.dart';

class const AocIconButton({
  super.key,
  required final AocIconData icon,
  required final AocUnit iconSize,
  final VoidCallback? onPressed,
  final Color? color,
  final double? fill,
  final AocEdgeInsets? iconPadding,
}) extends StatelessWidget {
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
