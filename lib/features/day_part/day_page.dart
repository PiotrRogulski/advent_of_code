import 'package:advent_of_code/design_system/widgets/adaptive_list.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:flutter/material.dart';

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

class DayScreen extends StatelessWidget {
  const DayScreen({
    super.key,
    required this.year,
    required this.day,
  });

  final int year;
  final int day;

  @override
  Widget build(BuildContext context) {
    final dayData = getDay(year, day);

    return AocScaffold(
      title: '$day – $year',
      bodySlivers: [
        SliverAdaptiveList(
          items: dayData.parts.keys,
          listItemBuilder: (context, part) {
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: ListTile(
                title: Text('Part $part'),
                onTap: () =>
                    PartRoute(year: year, day: day, part: part).go(context),
              ),
            );
          },
          gridItemBuilder: (context, part) {
            return Card(
              child: InkWell(
                onTap: () =>
                    PartRoute(year: year, day: day, part: part).go(context),
                child: Center(
                  child: Text('Part $day'),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
