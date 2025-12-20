import 'package:advent_of_code/common/hooks/use_unbounded_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

enum SpringState {
  first(value: 0, ratio: 1),
  second(value: 1, ratio: 0.4);

  const SpringState({required this.value, required this.ratio});

  final double value;
  final double ratio;
}

SpringDescription _spring({required double ratio, required double stiffness}) =>
    .withDampingRatio(mass: 1, stiffness: stiffness, ratio: ratio);

double useValueSpring(
  double value, {
  double? ratio,
  double? stiffness,
  bool animate = true,
}) {
  final controller = useUnboundedAnimationController(initialValue: value);
  useValueChanged<(double, bool), void>((value, animate), (_, _) {
    if (animate) {
      controller.animateWith(
        SpringSimulation(
          _spring(ratio: ratio ?? 1, stiffness: stiffness ?? 500),
          controller.value,
          value,
          0,
        ),
      );
    } else {
      controller.value = value;
    }
  });

  return useAnimation(controller);
}

(double, double, double, double) useValueSpring4D(
  (double, double, double, double) value, {
  double? ratio,
  double? stiffness,
  bool animate = true,
}) {
  double use(double value) => useValueSpring(
    value,
    ratio: ratio,
    stiffness: stiffness,
    animate: animate,
  );

  return (use(value.$1), use(value.$2), use(value.$3), use(value.$4));
}

Color useColorSpring(
  Color value, {
  double? ratio,
  double? stiffness,
  bool animate = true,
}) {
  final (a, r, g, b) = useValueSpring4D(
    (value.a, value.r, value.g, value.b),
    ratio: ratio,
    stiffness: stiffness,
    animate: animate,
  );

  return .from(alpha: a, red: r, green: g, blue: b);
}
