import 'package:advent_of_code/common/widgets/breakpoint_selector.dart';
import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/years/widgets/years_grid.dart';
import 'package:advent_of_code/features/years/widgets/years_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class YearsPage extends AocPage<void> {
  const YearsPage() : super(child: const YearsScreen());
}

class YearsScreen extends StatelessWidget {
  const YearsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AocScaffold(
      title: 'Years',
      bodySlivers: [
        BreakpointSelector(
          builders: {
            Breakpoints.small: (_) => const SliverYearsList(),
            null: (_) => const SliverYearsGrid(),
          },
        ),
      ],
    );
  }
}
