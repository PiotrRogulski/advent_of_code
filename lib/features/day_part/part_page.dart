import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/part/use_part_input.dart';
import 'package:advent_of_code/features/tasks/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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

class PartScreen extends HookWidget {
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
    final partImplementation = getPart(year, day, part);

    final inputData = usePartInput(partImplementation);

    return AocScaffold(
      title: '$part – $day – $year',
      bodySlivers: [
        if (inputData case final data?)
          // TODO: replace with rich output view & progress indicator
          SliverToBoxAdapter(
            child: FilledButton.tonal(
              onPressed: () async {
                final output = await partImplementation.run(data);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(output.toString()),
                  ),
                );
              },
              child: const Text('Run'),
            ),
          ),
        // TODO: replace with rich input view
        SliverToBoxAdapter(
          child: Text(
            inputData.toString(),
          ),
        ),
      ],
    );
  }
}
