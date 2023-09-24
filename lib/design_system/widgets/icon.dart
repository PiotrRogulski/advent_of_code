import 'package:advent_of_code/design_system/icons.dart';
import 'package:flutter/material.dart';

class AocIcon extends StatelessWidget {
  const AocIcon(
    this.icon, {
    super.key,
    required this.size,
    this.color,
    this.fill,
  });

  final AocIconData icon;
  final double size;
  final Color? color;
  final double? fill;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -size / 12),
      // ignore: use_design_system_item_AocIcon
      child: Icon(
        icon,
        size: size,
        opticalSize: size,
        color: color,
        fill: fill,
      ),
    );
  }
}