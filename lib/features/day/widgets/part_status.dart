import 'package:advent_of_code/features/part/part_implementation.dart';
import 'package:advent_of_code/features/part/part_input.dart';
import 'package:flutter/material.dart';

class PartStatus extends StatelessWidget {
  const PartStatus({
    super.key,
    required this.part,
    required this.data,
    required this.index,
  });

  final PartImplementation part;
  final PartInput data;
  final int index;

  @override
  Widget build(BuildContext context) {
    // TODO: replace with rich output view & progress indicator
    return FilledButton.tonal(
      onPressed: () async {
        final output = await part.run(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(output.toString()),
          ),
        );
      },
      child: Text('Run part ${index + 1}'),
    );
  }
}
