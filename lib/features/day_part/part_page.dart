import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:flutter/material.dart';

class PartPage extends MaterialPage<void> {
  PartPage({
    required int year,
    required int day,
    required int part,
  }) : super(
          child: PartScreen(
            year: year,
            day: day,
            part: part,
          ),
        );
}

class PartScreen extends StatelessWidget {
  const PartScreen({
    super.key,
    required this.year,
    required this.day,
    required this.part,
  });

  final int year;
  final int day;
  final int part;

  @override
  Widget build(BuildContext context) {
    return AocScaffold(
      title: '$part – $day – $year',
    );
  }
}
