import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';

class PartVisualizerButton extends StatelessWidget {
  const PartVisualizerButton({
    super.key,
    required this.partVisualizer,
    required this.data,
    required this.partNumber,
  });

  final PartVisualizer partVisualizer;
  final PartInput data;
  final int partNumber;

  String get _heroTag => 'viz_$partNumber';

  static const _duration = Durations.medium4;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _heroTag,
      createRectTween: _createRectTween,
      flightShuttleBuilder: _flightShuttleBuilder,
      child: AocIconButton(
        icon: .animatedImages,
        iconSize: .large,
        onPressed: () => Navigator.of(context, rootNavigator: true).push<void>(
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
                    tag: _heroTag,
                    createRectTween: _createRectTween,
                    flightShuttleBuilder: _flightShuttleBuilder,
                    child: _VisualizerDialog(
                      partVisualizer: partVisualizer(data),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _VisualizerDialog extends StatelessWidget {
  const _VisualizerDialog({required this.partVisualizer});

  final Widget partVisualizer;

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

Tween<Rect?> _createRectTween(Rect? begin, Rect? end) =>
    MaterialRectArcTween(begin: begin, end: end);

Widget _flightShuttleBuilder(
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
        FadeTransition(opacity: enterTransition, child: fromHeroContext.widget),
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
