import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:advent_of_code/common/widgets/error_stacktrace_dialog.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/design_system/widgets/switch_list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:advent_of_code/features/day/store/part_status_store.dart';
import 'package:advent_of_code/features/day/use_day_input.dart';
import 'package:advent_of_code/features/day/widgets/input_view.dart';
import 'package:advent_of_code/features/day/widgets/part_status.dart';
import 'package:advent_of_code/features/day/widgets/visualizer_button.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class DayPage extends MaterialPage<void> {
  DayPage({required int year, required int day})
    : super(
        child: DayScreen(year: year, day: day),
      );
}

class DayScreen extends HookWidget {
  const DayScreen({super.key, required this.year, required this.day});

  final int year;
  final int day;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final dayData = getDay(year, day);

    final inputDataSnapshot = useDayInput(dayData);

    final partStores = useMemoized(
      () => [
        for (final part in dayData.parts.entries)
          PartStatusStore(part: part.value),
      ],
      [year, day],
    );

    final useFullData = useState(false);

    return Provider.value(
      value: dayData,
      child: AocScaffold(
        title: s.day_title(day: day, year: year),
        actions: [
          if (inputDataSnapshot.data case final input?)
            if (getDayVisualizer(dayData) case final visualizer?)
              PartVisualizerButton(
                partVisualizer: visualizer,
                data: useFullData.value ? input.full : input.example,
              ),
        ],
        bodySlivers: [
          switch (inputDataSnapshot) {
            AsyncSnapshot(:final data?) => BreakpointSelector(
              builders: {
                Breakpoints.small: (context) => _SliverBodyColumn(
                  stores: partStores,
                  inputData: data,
                  useFullData: useFullData,
                ),
                null: (context) => _SliverBodySideBySide(
                  stores: partStores,
                  inputData: data,
                  useFullData: useFullData,
                ),
              },
            ),
            AsyncSnapshot(:final error?, :final stackTrace) =>
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      AocText(s.day_inputData_errorLoading),
                      AocUnit.medium.gap,
                      FilledButton.tonal(
                        onPressed: () => ErrorStackTraceDialog.show(
                          context,
                          error: error,
                          stackTrace: stackTrace,
                        ),
                        child: AocText(s.common_showDetails),
                      ),
                    ],
                  ),
                ),
              ),
            _ => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
          },
        ],
      ),
    );
  }
}

class _SliverBodyColumn extends StatelessWidget {
  const _SliverBodyColumn({
    required this.stores,
    required this.inputData,
    required this.useFullData,
  });

  final List<PartStatusStore> stores;
  final ({PartInput example, PartInput full}) inputData;
  final ValueNotifier<bool> useFullData;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Card(
            margin: const AocEdgeInsets.symmetric(horizontal: .medium),
            child: AocSwitchListTile(
              value: useFullData.value,
              onChanged: (value) => useFullData.value = value,
              title: s.day_useFullInput,
            ),
          ),
        ),
        _SliverPartList(
          padding: const .all(.medium),
          stores: stores,
          inputData: useFullData.value ? inputData.full : inputData.example,
        ),
        const SliverToBoxAdapter(child: Divider()),
        _SliverInputView(
          key: const PageStorageKey('input-example'),
          label: s.day_inputExample,
          padding: const .all(.medium),
          inputData: inputData.example,
        ),
        _SliverInputView(
          key: const PageStorageKey('input-full'),
          label: s.day_inputFull,
          padding: const .all(.medium),
          inputData: inputData.full,
        ),
      ],
    );
  }
}

class _SliverBodySideBySide extends StatelessWidget {
  const _SliverBodySideBySide({
    required this.stores,
    required this.inputData,
    required this.useFullData,
  });

  final List<PartStatusStore> stores;
  final ({PartInput example, PartInput full}) inputData;
  final ValueNotifier<bool> useFullData;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AocSliverPadding(
      padding: const .all(.small),
      sliver: SliverCrossAxisGroup(
        slivers: [
          SliverCrossAxisExpanded(
            flex: 1,
            sliver: _SliverPartList(
              padding: const .all(.small),
              stores: stores,
              inputData: useFullData.value ? inputData.full : inputData.example,
            ),
          ),
          SliverCrossAxisExpanded(
            flex: 1,
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(
                  child: Card(
                    margin: const AocEdgeInsets.all(.small),
                    child: AocSwitchListTile(
                      value: useFullData.value,
                      onChanged: (value) => useFullData.value = value,
                      title: s.day_useFullInput,
                    ),
                  ),
                ),
                _SliverInputView(
                  key: const PageStorageKey('input-example'),
                  label: s.day_inputExample,
                  padding: const .all(.small),
                  inputData: inputData.example,
                ),
                _SliverInputView(
                  key: const PageStorageKey('input-full'),
                  label: s.day_inputFull,
                  padding: const .all(.small),
                  inputData: inputData.full,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverPartList extends StatelessWidget {
  const _SliverPartList({
    required this.padding,
    required this.stores,
    required this.inputData,
  });

  final AocEdgeInsets padding;
  final List<PartStatusStore> stores;
  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    return AocSliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final partStore = stores[index];
          return PartStatus(
            key: PageStorageKey('part-$index'),
            store: partStore,
            data: inputData,
            partNumber: index + 1,
          );
        },
        separatorBuilder: (context, index) => AocUnit.medium.gap,
      ),
    );
  }
}

class _SliverInputView extends StatelessWidget {
  const _SliverInputView({
    super.key,
    required this.label,
    required this.padding,
    required this.inputData,
  });

  final String label;
  final AocEdgeInsets padding;
  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    return AocSliverPadding(
      padding: padding,
      sliver: SliverDayInputView(inputData: inputData, label: label),
    );
  }
}
