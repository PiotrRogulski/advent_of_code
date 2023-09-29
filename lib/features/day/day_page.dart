import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/day/use_day_input.dart';
import 'package:advent_of_code/features/day/widgets/input_view.dart';
import 'package:advent_of_code/features/day/widgets/part_status.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final dayData = getDay(year, day);
    final parts = dayData.parts.entries.toList();

    final inputData = useDayInput(dayData);

    return AocScaffold(
      title: '$day – $year',
      bodySlivers: [
        if (inputData case final data?)
          SliverList.builder(
            itemCount: parts.length,
            itemBuilder: (context, index) {
              final part = parts[index].value;
              return PartStatus(
                part: part,
                data: data,
                index: index,
              );
            },
          ),
        if (inputData case final data?)
          SliverDayInputView(
            inputData: data,
          ),
      ],
    );
  }
}
