import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/widgets.dart';

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocBorderRadius extends BorderRadius {
  AocBorderRadius(AocUnit super.radius) : super.circular();

  AocBorderRadius.vertical({AocUnit top = .zero, AocUnit bottom = .zero})
    : super.vertical(top: .circular(top), bottom: .circular(bottom));
}

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocBorder extends RoundedSuperellipseBorder {
  AocBorder(AocUnit radius, {super.side})
    : super(borderRadius: AocBorderRadius(radius));
}
