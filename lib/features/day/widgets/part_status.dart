import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/widgets/error_stacktrace_dialog.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:advent_of_code/features/day/store/part_status_store.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PartStatus extends StatelessWidget {
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

    return Observer(
      builder: (context) {
        return AocExpansionCard(
          title: s.day_partTitle(part: index + 1),
          trailing: switch (store.part.completed) {
            true => AocIcon(.check, size: .large, color: colors.primary),
            false => null,
          },
          bodyAlignment: .bottomCenter,
          body: Stack(
            children: [
              Column(
                children: switch (store.runs) {
                  [] => [
                    AocListTile(
                      title: AocText(s.day_part_notRun),
                      subtitle: AocText(s.day_part_notRunSubtitle),
                      contentPadding: const .symmetric(horizontal: .medium),
                      trailing: AocIconButton(
                        onPressed: () => store.run(data),
                        icon: .playCircle,
                        iconSize: .xlarge,
                      ),
                    ),
                  ],
                  final runs => [
                    for (final (index, run) in runs.indexed)
                      _RunInfoTile(
                        run: run,
                        trailing: index == 0
                            ? AocIconButton(
                                onPressed: () => store.run(data),
                                icon: .playCircle,
                                iconSize: .xlarge,
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
        child: AocListTile(
          title: AocText(switch (run.data) {
            StringOutput(:final value) => value,
            NumericOutput(:final value) => value.toString(),
            null => s.day_part_noOutput,
          }, monospaced: true),
          subtitle: AocText(run.runDuration.toString()),
          contentPadding: const .symmetric(horizontal: .medium),
          trailing: trailing,
        ),
      ),
      (:final error, :final stackTrace) => DynamicWeight(
        child: AocListTile(
          onTap: () {
            ErrorStackTraceDialog.show(
              context,
              error: error,
              stackTrace: stackTrace,
            );
          },
          leading: AocIcon(.error, color: colors.error, size: .xlarge),
          title: AocText(s.day_part_error, style: .new(color: colors.error)),
          subtitle: AocText(s.day_part_seeErrorDetails),
          contentPadding: const .symmetric(horizontal: .medium),
          trailing: trailing,
        ),
      ),
    };
  }
}
