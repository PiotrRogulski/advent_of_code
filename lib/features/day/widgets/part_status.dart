import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/features/day/store/part_status_store.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

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

    final store = useMemoized(
      () => PartStatusStore(
        part: part,
        data: data,
      ),
    );

    return Observer(
      builder: (context) {
        return AocExpansionCard(
          title: 'Part ${index + 1}',
          controller: controller,
          padding: const EdgeInsets.all(16),
          child: switch ((store.running, store.output)) {
            (true, _) => const Center(
                child: CircularProgressIndicator(),
              ),
            (_, null) => Center(
                child: IconButton(
                  onPressed: store.run,
                  icon: const AocIcon(
                    AocIcons.play_circle,
                    size: 32,
                  ),
                ),
              ),
            (_, final output) => Row(
                children: [
                  // TODO: rich output view
                  Expanded(
                    child: Text(
                      output.toString(),
                    ),
                  ),
                  IconButton(
                    onPressed: store.run,
                    icon: const AocIcon(
                      AocIcons.play_circle,
                      size: 32,
                    ),
                  ),
                ],
              ),
          },
        );
      },
    );
  }
}
