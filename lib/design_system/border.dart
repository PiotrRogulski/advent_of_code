import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/widgets.dart';

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocBorderRadius extends BorderRadiusDirectional {
  AocBorderRadius(AocUnit super.radius) : super.circular();

  AocBorderRadius.vertical({AocUnit top = .zero, AocUnit bottom = .zero})
    : super.vertical(top: .circular(top), bottom: .circular(bottom));

  AocBorderRadius.horizontal({AocUnit start = .zero, AocUnit end = .zero})
    : super.horizontal(start: .circular(start), end: .circular(end));
}

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocBorder extends RoundedSuperellipseBorder {
  AocBorder(AocUnit radius, {super.side})
    : super(borderRadius: AocBorderRadius(radius));

  AocBorder.horizontal({AocUnit start = .zero, AocUnit end = .zero, super.side})
    : super(
        borderRadius: AocBorderRadius.horizontal(start: start, end: end),
      );
}
