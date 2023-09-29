import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PartStatus extends HookWidget {
  const PartStatus({
    super.key,
    required this.part,
    required this.data,
    required this.index,
  });

  final PartImplementation part;
  final PartInput data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(ExpansionTileController.new);

    Future<void> onPressed() async {
      final output = await part.run(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(output.toString()),
        ),
      );
    }

    return AocExpansionCard(
      title: 'Part ${index + 1}',
      controller: controller,
      // FIXME: add child
    );
  }
}
