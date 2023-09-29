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
    final colors = Theme.of(context).colorScheme;

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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              Column(
                children: switch (store.runs) {
                  [] => [
                      // FIXME: unify tiles
                      ListTile(
                        title: const Text('Not run'),
                        subtitle: const Text('Run to see the result'),
                        contentPadding: EdgeInsets.zero,
                        trailing: IconButton(
                          onPressed: store.run,
                          icon: const AocIcon(
                            AocIcons.play_circle,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  final runs => [
                      for (final (index, run) in runs.indexed)
                        ListTile(
                          title: Text(run.data.toString()),
                          subtitle: Text(run.runDuration.toString()),
                          contentPadding: EdgeInsets.zero,
                          trailing: index == 0
                              ? IconButton(
                                  onPressed: store.run,
                                  icon: const AocIcon(
                                    AocIcons.play_circle,
                                    size: 32,
                                  ),
                                )
                              : null,
                        ),
                    ],
                },
              ),
              if (store.running)
                Positioned.fill(
                  child: ColoredBox(
                    color: colors.surface.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
