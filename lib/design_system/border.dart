import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/widgets.dart';

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocBorderRadius extends BorderRadiusDirectional {
  new(AocUnit super.radius) : super.circular();

  new vertical({AocUnit top = .zero, AocUnit bottom = .zero})
    : super.vertical(top: .circular(top), bottom: .circular(bottom));

  new horizontal({AocUnit start = .zero, AocUnit end = .zero})
    : super.horizontal(start: .circular(start), end: .circular(end));
}

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocBorder extends RoundedSuperellipseBorder {
  new(AocUnit radius, {super.side})
    : super(borderRadius: AocBorderRadius(radius));

  new horizontal({AocUnit start = .zero, AocUnit end = .zero, super.side})
    : super(
        borderRadius: AocBorderRadius.horizontal(start: start, end: end),
      );
}
