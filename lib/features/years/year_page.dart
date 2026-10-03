import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/widgets/adaptive_list.dart';
import 'package:advent_of_code/design_system/widgets/ink_well.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:material_ui/material_ui.dart';

// Bug in the lint: https://github.com/dart-lang/sdk/issues/64037
// ignore: prefer_const_constructors_in_immutables
class YearPage({required int year}) extends MaterialPage<void> {
  this : super(child: YearScreen(year: year));
}

class const YearScreen({super.key, required final int year})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final theme = Theme.of(context);
    final yearData = getYear(year);

    return AocScaffold(
      key: PageStorageKey(year),
      title: s.year_title(year: year),
      bodySlivers: [
        SliverAdaptiveList(
          items: yearData.days.entries,
          itemWrapper: (context, child) => DynamicWeight(child: child),
          listItemBuilder: (context, entry) {
            final day = entry.key;
            return Card(
              child: AocListTile(
                title: AocText(s.year_day(day: day)),
                onTap: () => DayRoute(year: year, day: day).go(context),
              ),
            );
          },
          gridItemBuilder: (context, entry) {
            final day = entry.key;
            return Card(
              child: AocInkWell(
                onTap: () => DayRoute(year: year, day: day).go(context),
                child: Center(
                  child: AocText(
                    s.year_day(day: day),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
