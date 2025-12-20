import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:advent_of_code/features/day/widgets/visualizer_dialog.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:flutter/material.dart';

class PartVisualizerButton extends StatelessWidget {
  const PartVisualizerButton({
    super.key,
    required this.partVisualizer,
    required this.data,
    this.partNumber,
  });

  final PartVisualizer partVisualizer;
  final PartInput data;
  final int? partNumber;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: VisualizerDialog.heroTag(partNumber: partNumber),
      createRectTween: VisualizerDialog.createRectTween,
      flightShuttleBuilder: VisualizerDialog.flightShuttleBuilder,
      child: AocIconButton(
        icon: .animatedImages,
        iconSize: .large,
        onPressed: () => VisualizerDialog.show(
          context,
          partVisualizer: partVisualizer,
          data: data,
          partNumber: partNumber,
        ),
      ),
    );
  }
}
