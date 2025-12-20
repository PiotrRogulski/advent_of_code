import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/material.dart';

class AocPadding extends StatelessWidget {
  const AocPadding({super.key, required this.padding, required this.child});

  final AocEdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // This is the definition
    // ignore: leancode_lint/use_design_system_item
    return Padding(padding: padding, child: child);
  }
}

class AocSliverPadding extends StatelessWidget {
  const AocSliverPadding({
    super.key,
    required this.padding,
    required this.sliver,
  });

  final AocEdgeInsets padding;
  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    // This is the definition
    // ignore: leancode_lint/use_design_system_item
    return SliverPadding(padding: padding, sliver: sliver);
  }
}

// This is the definition
// ignore: leancode_lint/use_design_system_item
class AocEdgeInsets extends EdgeInsetsDirectional {
  const AocEdgeInsets.all(AocUnit super.value) : super.all();

  const AocEdgeInsets.only({
    AocUnit super.start = .zero,
    AocUnit super.top = .zero,
    AocUnit super.end = .zero,
    AocUnit super.bottom = .zero,
  }) : super.only();

  const AocEdgeInsets.symmetric({
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
