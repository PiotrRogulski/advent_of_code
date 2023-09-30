import 'package:advent_of_code/common/widgets/error_stacktrace_dialog.dart';
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
    required this.store,
    required this.data,
    required this.index,
  });

  final PartStatusStore store;
  final PartInput data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final controller = useMemoized(ExpansionTileController.new);

    return Observer(
      builder: (context) {
        return AocExpansionCard(
          title: 'Part ${index + 1}',
          controller: controller,
          child: Stack(
            children: [
              Column(
                children: switch (store.runs) {
                  [] => [
                      ListTile(
                        title: const Text('Not run'),
                        subtitle: const Text('Run to see the result'),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        trailing: IconButton(
                          onPressed: () => store.run(data),
                          icon: const AocIcon(
                            AocIcons.play_circle,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  final runs => [
                      for (final (index, run) in runs.indexed)
                        _RunInfoTile(
                          run: run,
                          trailing: index == 0
                              ? IconButton(
                                  onPressed: () => store.run(data),
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

class _RunInfoTile extends StatelessWidget {
  const _RunInfoTile({
    required this.run,
    required this.trailing,
  });

  final RunInfo run;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return switch (run.error) {
      null => ListTile(
          title: Text(run.data.toString()),
          subtitle: Text(run.runDuration.toString()),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          trailing: trailing,
        ),
      (:final error, :final stackTrace) => ListTile(
          onTap: () {
            _showErrorDetails(
              context,
              error: error,
              stackTrace: stackTrace,
            );
          },
          leading: AocIcon(
            AocIcons.error,
            color: colors.error,
            size: 32,
          ),
          title: Text(
            'An error occurred',
            style: TextStyle(
              color: colors.error,
            ),
          ),
          subtitle: const Text('Tap to see error details'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          trailing: trailing,
        ),
    };
  }
}

Future<void> _showErrorDetails(
  BuildContext context, {
  required Object? error,
  required StackTrace stackTrace,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return ErrorStackTraceDialog(
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}
