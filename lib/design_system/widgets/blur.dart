import 'package:material_ui/material_ui.dart';

class const BlurSwitcher({super.key, required final Widget? child})
    extends StatelessWidget {
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

class const Blur({
  super.key,
  required final double visibility,
  required final Widget? child,
}) extends StatelessWidget {
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

class const AnimatedBlurVisibility({
  super.key,
  required final bool visible,
  final Widget Function(BuildContext context, double value, Widget child)?
  builder,
  required final Widget child,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final builder = this.builder ?? (context, _, child) => child;

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
