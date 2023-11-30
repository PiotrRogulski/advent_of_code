import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class ErrorStackTraceDialog extends StatelessWidget {
  const ErrorStackTraceDialog({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  final Object? error;
  final StackTrace stackTrace;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error details'),
      scrollable: true,
      content: SelectionArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  error.toString(),
                  style: const TextStyle(
                    fontFamily: FontFamily.jetBrainsMono,
                    height: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Card(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                child: Text(
                  stackTrace.toString(),
                  style: const TextStyle(
                    fontFamily: FontFamily.jetBrainsMono,
                    height: 1.2,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ].spaced(height: 8),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
