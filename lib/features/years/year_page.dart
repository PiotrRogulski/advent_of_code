import 'package:advent_of_code/design_system/widgets/adaptive_list.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
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
    final yearData = allYears[year]!;

    return AocScaffold(
      key: PageStorageKey(year),
      title: 'Year $year',
      bodySlivers: [
        SliverAdaptiveList(
          items: yearData.days.entries,
          listItemBuilder: (context, entry) {
            final MapEntry(key: day, value: dayData) = entry;
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                title: Text('Day $day'),
                onTap: () {},
              ),
            );
          },
          gridItemBuilder: (context, entry) {
            final MapEntry(key: day, value: dayData) = entry;
            return Card(
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text('Day $day'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
