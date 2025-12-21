import 'package:advent_of_code/common/hooks/use_unbounded_animation_controller.dart';
import 'package:flutter/physics.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

double useEmphasize<T>(T value) {
  final emphasisController = useUnboundedAnimationController();

  useValueChanged<T, void>(value, (_, _) {
    emphasisController
      ..value = 0
      ..animateWith(
        SpringSimulation(
          .withDampingRatio(mass: 10, stiffness: 500),
          0,
          0,
          20,
          snapToEnd: true,
        ),
      );
  });

  return useAnimation(emphasisController);
}
