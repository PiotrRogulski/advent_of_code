import 'package:flutter/material.dart';

class BlurSwitcher extends StatelessWidget {
  const BlurSwitcher({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Durations.long1,
      switchInCurve: Curves.easeInOutCubicEmphasized,
      switchOutCurve: Curves.easeInOutCubicEmphasized.flipped,
      transitionBuilder: (child, animation) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          final progress = animation.value;
          return Blur(visibility: progress, child: child);
        },
        child: child,
      ),
      child: child,
    );
  }
}

class Blur extends StatelessWidget {
  const Blur({super.key, required this.visibility, required this.child});

  final double visibility;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final sigma = 16 * (1 - visibility);

    return Opacity(
      opacity: visibility,
      child: ImageFiltered(
        imageFilter: .blur(sigmaX: sigma, sigmaY: sigma, tileMode: .decal),
        child: child,
      ),
    );
  }
}

class AnimatedBlurVisibility extends StatelessWidget {
  const AnimatedBlurVisibility({
    super.key,
    required this.visible,
    this.builder,
    required this.child,
  });

  final bool visible;
  final Widget Function(BuildContext context, double value, Widget child)?
  builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final builder = this.builder ?? (_, _, child) => child;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: visible ? 1 : 0),
      duration: Durations.long4,
      curve: Curves.easeInOutCubicEmphasized,
      builder: (context, value, child) =>
          builder(context, value, Blur(visibility: value, child: child)),
      child: child,
    );
  }
}
