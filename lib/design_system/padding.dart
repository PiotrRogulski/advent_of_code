import 'package:advent_of_code/design_system/unit.dart';
import 'package:material_ui/material_ui.dart';

class const AocPadding({
  super.key,
  required final AocEdgeInsets padding,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is the definition
    // ignore: aoc_lint/use_design_system_item_AocPadding
    return Padding(padding: padding, child: child);
  }
}

class const AocSliverPadding({
  super.key,
  required final AocEdgeInsets padding,
  required final Widget sliver,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is the definition
    // ignore: aoc_lint/use_design_system_item_AocSliverPadding
    return SliverPadding(padding: padding, sliver: sliver);
  }
}

// This is the definition
// ignore: aoc_lint/use_design_system_item_AocEdgeInsets
class AocEdgeInsets extends EdgeInsetsDirectional {
  const new all(AocUnit super.value) : super.all();

  const new only({
    AocUnit super.start = .zero,
    AocUnit super.top = .zero,
    AocUnit super.end = .zero,
    AocUnit super.bottom = .zero,
  }) : super.only();

  const new symmetric({
    AocUnit super.horizontal = .zero,
    AocUnit super.vertical = .zero,
  }) : super.symmetric();

  static const zero = AocEdgeInsets.only();

  @override
  AocUnit get start => super.start as AocUnit;

  @override
  AocUnit get top => super.top as AocUnit;

  @override
  AocUnit get end => super.end as AocUnit;

  @override
  AocUnit get bottom => super.bottom as AocUnit;

  @override
  AocEdgeInsets operator *(double other) => .only(
    start: start * other,
    top: top * other,
    end: end * other,
    bottom: bottom * other,
  );

  @override
  AocEdgeInsets operator /(double other) => .only(
    start: start / other,
    top: top / other,
    end: end / other,
    bottom: bottom / other,
  );
}
