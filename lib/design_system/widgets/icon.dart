// ignore_for_file: use_design_system_item_AocIcon

import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:flutter/material.dart';

class AocIcon extends ImplicitlyAnimatedWidget {
  const AocIcon(
    this.icon, {
    super.key,
    required this.size,
    this.color,
    this.fill = 0,
    this.weight,
  }) : super(
          duration: Durations.medium4,
          curve: Curves.easeInOutCubicEmphasized,
        );

  final AocIconData icon;
  final double size;
  final Color? color;
  final double fill;
  final AocDynamicWeight? weight;

  @override
  ImplicitlyAnimatedWidgetState<AocIcon> createState() => _AocIconState();
}

class _AocIconState extends ImplicitlyAnimatedWidgetState<AocIcon> {
  Tween<double>? _size;
  ColorTween? _color;
  Tween<double>? _fill;
  Tween<double?>? _weight;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Icon(
        widget.icon,
        size: _size?.evaluate(animation),
        opticalSize: _size?.evaluate(animation),
        color: _color?.evaluate(animation),
        fill: _fill?.evaluate(animation),
        weight: _weight?.evaluate(animation),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _size = visitor(
      _size,
      widget.size,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _color = visitor(
      _color,
      widget.color,
      (value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;
    _fill = visitor(
      _fill,
      widget.fill,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
    _weight = visitor(
      _weight,
      widget.weight?.value,
      (value) => Tween<double>(begin: value as double?),
    ) as Tween<double?>?;
  }
}
