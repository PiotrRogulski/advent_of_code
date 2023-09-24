import 'package:advent_of_code/design_system/widgets/scaffold.dart';
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
    return AocScaffold(
      title: 'Year $year',
    );
  }
}
