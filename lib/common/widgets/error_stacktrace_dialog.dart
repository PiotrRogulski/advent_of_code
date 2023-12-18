import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/material.dart';

class ErrorStackTraceDialog extends StatelessWidget {
  const ErrorStackTraceDialog._({
    required this.error,
    required this.stackTrace,
  });

  final Object? error;
  final StackTrace? stackTrace;

  static Future<void> show(
    BuildContext context, {
    required Object? error,
    required StackTrace? stackTrace,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ErrorStackTraceDialog._(
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AlertDialog(
      title: Text(s.errorDetails_title),
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
            if (stackTrace != null)
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
          child: Text(s.common_close),
        ),
      ],
    );
  }
}
