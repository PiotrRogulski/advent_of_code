import 'package:advent_of_code/common/hooks/use_spring.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AocIcon extends HookWidget {
  const AocIcon(
    this.icon, {
    super.key,
    required this.size,
    this.color,
    this.fill,
    this.weight,
  });

  final AocIconData icon;
  final AocUnit size;
  final Color? color;
  final double? fill;
  final AocDynamicWeight? weight;

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
    // ignore: leancode_lint/use_design_system_item
    return Icon(
      icon,
      size: size,
      opticalSize: size,
      color: color,
      fill: fill,
      weight: weight,
    );
  }
}
