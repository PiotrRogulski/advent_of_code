import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/widgets/adaptive_list.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:flutter/material.dart';

class YearPage extends MaterialPage<void> {
  YearPage({required int year})
      : super(
          child: YearScreen(
            year: year,
          ),
        );
}

class YearScreen extends StatelessWidget {
  const YearScreen({
    super.key,
    required this.year,
  });

  final int year;

  @override
  Widget build(BuildContext context) {
    final yearData = getYear(year);

    return AocScaffold(
      key: PageStorageKey(year),
      title: context.l10n.year_title(year),
      bodySlivers: [
        SliverAdaptiveList(
          items: yearData.days.entries,
          listItemBuilder: (context, entry) {
            final day = entry.key;
            return Card(
              child: ListTile(
                title: Text(context.l10n.year_day(day)),
                onTap: () => DayRoute(year: year, day: day).go(context),
              ),
            );
          },
          gridItemBuilder: (context, entry) {
            final day = entry.key;
            return Card(
              child: InkWell(
                onTap: () => DayRoute(year: year, day: day).go(context),
                child: Center(
                  child: Text(context.l10n.year_day(day)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
