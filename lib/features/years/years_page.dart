import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/icons.dart';
import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/adaptive_list.dart';
import 'package:advent_of_code/design_system/widgets/icon.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart' hide TextDirection;

part 'widgets/year_grid_tile.dart';
part 'widgets/year_list_tile.dart';

class YearsPage extends AocPage<void> {
  const YearsPage() : super(child: const YearsScreen());
}

class YearsScreen extends StatelessWidget {
  const YearsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AocScaffold(
      title: s.years_title,
      bodySlivers: [
        SliverAdaptiveList(
          items: allYears.entries,
          listItemBuilder: (context, entry) {
            final MapEntry(key: year, value: yearData) = entry;
            return _YearListTile(
              year: year,
              progress: yearData.progress,
              completeProgress: yearData.completeProgress,
            );
          },
          gridItemBuilder: (context, entry) {
            final MapEntry(key: year, value: yearData) = entry;
            return _YearGridTile(
              year: year,
              progress: yearData.progress,
              completeProgress: yearData.completeProgress,
            );
          },
        ),
      ],
    );
  }
}
