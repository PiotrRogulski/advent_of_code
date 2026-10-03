import 'package:advent_of_code/common/hooks/use_spring.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';

class const AocIcon(
  final AocIconData icon, {
  super.key,
  required final AocUnit size,
  final Color? color,
  final double? fill,
  final AocDynamicWeight? weight,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = useValueSpring(this.size);
    final fill = useValueSpring(
      this.fill ?? DynamicWeight.maybeOf(context)?.fill ?? 0,
    );
    final weight = useValueSpring(
      (this.weight ?? DynamicWeight.maybeOf(context)?.weight ?? .regular).value,
    );
    final color = useColorSpring(this.color ?? IconTheme.of(context).color!);

    // This is the definition
    // ignore: aoc_lint/use_design_system_item_AocIcon
    return Icon(
      icon.iconData,
      size: size,
      opticalSize: size,
      color: color,
      fill: fill,
      weight: weight,
    );
  }
}
