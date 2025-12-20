import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';

class VisualizerDialog extends StatelessWidget {
  const VisualizerDialog._({required this.partVisualizer});

  final Widget partVisualizer;

  static const _duration = Durations.medium4;

  static String heroTag({required int? partNumber}) =>
      'visualizer_dialog_$partNumber';

  static Tween<Rect?> createRectTween(Rect? begin, Rect? end) =>
      MaterialRectArcTween(begin: begin, end: end);

  static Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final enterTransition = Tween<double>(begin: 0, end: 1).animate(animation);
    final exitTransition = Tween<double>(begin: 1, end: 0).animate(animation);

    return switch (flightDirection) {
      .push => Stack(
        fit: .expand,
        children: [
          FittedBox(
            fit: .cover,
            child: FadeTransition(
              opacity: exitTransition,
              child: fromHeroContext.widget,
            ),
          ),
          FadeTransition(opacity: enterTransition, child: toHeroContext.widget),
        ],
      ),
      .pop => Stack(
        fit: .expand,
        children: [
          FadeTransition(
            opacity: enterTransition,
            child: fromHeroContext.widget,
          ),
          FittedBox(
            fit: .cover,
            child: FadeTransition(
              opacity: exitTransition,
              child: toHeroContext.widget,
            ),
          ),
        ],
      ),
    };
  }

  static Future<void> show(
    BuildContext context, {
    required PartVisualizer partVisualizer,
    required PartInput data,
    int? partNumber,
  }) => Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: _duration,
      reverseTransitionDuration: _duration,
      pageBuilder: (context, animation, _) {
        return FadeTransition(
          opacity: animation,
          child: AocPadding(
            padding: const .all(.xlarge),
            child: Hero(
              tag: heroTag(partNumber: partNumber),
              createRectTween: createRectTween,
              flightShuttleBuilder: flightShuttleBuilder,
              child: VisualizerDialog._(partVisualizer: partVisualizer(data)),
            ),
          ),
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRSuperellipse(
      borderRadius: AocBorderRadius(.xlarge),
      child: Dialog.fullscreen(
        child: Stack(
          children: [
            partVisualizer,
            PositionedDirectional(
              top: AocUnit.small,
              end: AocUnit.small,
              child: AocIconButton(
                icon: .close,
                iconSize: .xlarge,
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
