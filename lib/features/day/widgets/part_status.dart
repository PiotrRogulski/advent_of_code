import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/hooks/use_value_stream.dart';
import 'package:advent_of_code/common/widgets/error_stacktrace_dialog.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/icon_button.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:advent_of_code/features/day/store/part_status_store.dart';
import 'package:advent_of_code/features/day/widgets/visualizer_button.dart';
import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/part/part_output.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:advent_of_code/features/years/models/advent_structure.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class const PartStatus({
  super.key,
  required final PartStatusStore store,
  required final PartInput data,
  required final int partNumber,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final colors = Theme.of(context).colorScheme;

    final partVisualizer = getPartVisualizer(
      context.watch<DayData>(),
      partNumber,
    );

    final runs = useValueStream(store.runs);
    final running = useValueStream(store.running);

    return AocExpansionCard(
      title: s.day_partTitle(part: partNumber),
      titleTrailing: switch (store.part.completed) {
        true => AocIcon(.check, size: .large, color: colors.primary),
        false => null,
      },
      trailing: partVisualizer != null
          ? PartVisualizerButton(
              partVisualizer: partVisualizer,
              data: data,
              partNumber: partNumber,
            )
          : null,
      bodyAlignment: .bottomCenter,
      body: Stack(
        children: [
          Column(
            children: switch (runs) {
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
              [final lastRun, ...final runs] => [
                _RunInfoTile(
                  run: lastRun,
                  trailing: AocIconButton(
                    onPressed: () => store.run(data),
                    icon: .playCircle,
                    iconSize: .xlarge,
                  ),
                ),
                for (final run in runs) _RunInfoTile(run: run, trailing: null),
              ],
            },
          ),
          if (running)
            Positioned.fill(
              child: ColoredBox(
                color: colors.surface.withValues(alpha: 0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}

class const _RunInfoTile({
  required final RunInfo run,
  required final Widget? trailing,
}) extends StatelessWidget {
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
