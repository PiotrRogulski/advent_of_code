import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:advent_of_code/common/widgets/error_stacktrace_dialog.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/day/store/part_status_store.dart';
import 'package:advent_of_code/features/day/use_day_input.dart';
import 'package:advent_of_code/features/day/widgets/input_view.dart';
import 'package:advent_of_code/features/day/widgets/part_status.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DayPage extends MaterialPage<void> {
  DayPage({
    required int year,
    required int day,
  }) : super(
          child: DayScreen(
            year: year,
            day: day,
          ),
        );
}

class DayScreen extends HookWidget {
  const DayScreen({
    super.key,
    required this.year,
    required this.day,
  });

  final int year;
  final int day;

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final dayData = getDay(year, day);
    final parts = dayData.parts.entries.toList();

    final inputDataSnapshot = useDayInput(dayData);

    final partStores = useMemoized(
      () => List.generate(
        parts.length,
        (index) => PartStatusStore(
          part: parts[index].value,
        ),
      ),
    );

    final useFullData = useState(false);

    return AocScaffold(
      title: s.day_title(day: day, year: year),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s.day_inputData_errorLoading),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () => ErrorStackTraceDialog.show(
                        context,
                        error: error,
                        stackTrace: stackTrace,
                      ),
                      child: Text(s.common_showDetails),
                    ),
                  ],
                ),
              ),
            ),
          _ => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        },
      ],
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
    return MultiSliver(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SwitchListTile(
            value: useFullData.value,
            onChanged: (value) => useFullData.value = value,
            title: Text(context.l10n.day_useFullInput),
          ),
        ),
        _SliverPartList(
          padding: const EdgeInsets.all(16),
          stores: stores,
          inputData: useFullData.value ? inputData.full : inputData.example,
        ),
        const SliverToBoxAdapter(child: Divider()),
        _SliverInputView(
          padding: const EdgeInsets.all(16),
          inputData: inputData.example,
        ),
        _SliverInputView(
          padding: const EdgeInsets.all(16),
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
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverCrossAxisGroup(
        slivers: [
          SliverCrossAxisExpanded(
            flex: 1,
            sliver: _SliverPartList(
              padding: const EdgeInsets.all(8),
              stores: stores,
              inputData: useFullData.value ? inputData.full : inputData.example,
            ),
          ),
          SliverCrossAxisExpanded(
            flex: 1,
            sliver: MultiSliver(
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  child: SwitchListTile(
                    value: useFullData.value,
                    onChanged: (value) => useFullData.value = value,
                    title: Text(context.l10n.day_useFullInput),
                  ),
                ),
                _SliverInputView(
                  padding: const EdgeInsets.all(8),
                  inputData: inputData.example,
                ),
                _SliverInputView(
                  padding: const EdgeInsets.all(8),
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

  final EdgeInsetsGeometry padding;
  final List<PartStatusStore> stores;
  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          final partStore = stores[index];
          return PartStatus(
            key: PageStorageKey('part-$index'),
            store: partStore,
            data: inputData,
            index: index,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
      ),
    );
  }
}

class _SliverInputView extends StatelessWidget {
  const _SliverInputView({
    required this.padding,
    required this.inputData,
  });

  final EdgeInsetsGeometry padding;
  final PartInput inputData;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverDayInputView(
        key: const PageStorageKey('input'),
        inputData: inputData,
      ),
    );
  }
}
