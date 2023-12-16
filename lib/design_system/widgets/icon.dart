// ignore_for_file: overridden_fields, use_design_system_item_AocIcon

import 'package:advent_of_code/design_system/icons.dart';
import 'package:flutter/material.dart';

class AocIcon extends Icon {
  const AocIcon(
    AocIconData super.icon, {
    super.key,
    required double super.size,
    super.color,
    double super.fill = 0,
  });
}
