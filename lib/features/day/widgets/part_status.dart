import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/widgets/error_stacktrace_dialog.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/features/day/store/part_status_store.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/gen/fonts.gen.dart';
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
    final s = context.l10n;
    final colors = Theme.of(context).colorScheme;

    final controller = useMemoized(ExpansionTileController.new);

    return Observer(
      builder: (context) {
        return AocExpansionCard(
          title: s.day_partTitle(part: index + 1),
          trailing: switch (store.part.completed) {
            true => AocIcon(AocIconData.check, size: 24, color: colors.primary),
            false => null,
          },
          controller: controller,
          body: Stack(
            children: [
              Column(
                children: switch (store.runs) {
                  [] => [
                    ListTile(
                      title: Text(s.day_part_notRun),
                      subtitle: Text(s.day_part_notRunSubtitle),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      trailing: IconButton(
                        onPressed: () => store.run(data),
                        icon: const AocIcon(AocIconData.playCircle, size: 32),
                      ),
                    ),
                  ],
                  final runs => [
                    for (final (index, run) in runs.indexed)
                      _RunInfoTile(
                        run: run,
                        trailing:
                            index == 0
                                ? IconButton(
                                  onPressed: () => store.run(data),
                                  icon: const AocIcon(
                                    AocIconData.playCircle,
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
                    color: colors.surface.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
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
  const _RunInfoTile({required this.run, required this.trailing});

  final RunInfo run;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final colors = Theme.of(context).colorScheme;

    return switch (run.error) {
      null => SelectionArea(
        child: ListTile(
          title: DefaultTextStyle.merge(
            style: const TextStyle(
              fontFamily: FontFamily.jetBrainsMono,
              fontFeatures: [FontFeature.disable('calt')],
              height: 1.2,
            ),
            child: Text(switch (run.data) {
              StringOutput(:final value) => value,
              NumericOutput(:final value) => value.toString(),
              null => s.day_part_noOutput,
            }),
          ),
          subtitle: Text(run.runDuration.toString()),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          trailing: trailing,
        ),
      ),
      (:final error, :final stackTrace) => ListTile(
        onTap: () {
          ErrorStackTraceDialog.show(
            context,
            error: error,
            stackTrace: stackTrace,
          );
        },
        leading: AocIcon(AocIconData.error, color: colors.error, size: 32),
        title: Text(s.day_part_error, style: TextStyle(color: colors.error)),
        subtitle: Text(s.day_part_seeErrorDetails),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        trailing: trailing,
      ),
    };
  }
}
