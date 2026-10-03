import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/unit.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:material_ui/material_ui.dart';

class const ErrorStackTraceDialog._({
  required final Object? error,
  required final StackTrace? stackTrace,
}) extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Object? error,
    required StackTrace? stackTrace,
  }) => showDialog(
    context: context,
    builder: (context) =>
        ErrorStackTraceDialog._(error: error, stackTrace: stackTrace),
  );

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;

    return AlertDialog(
      title: AocText(s.errorDetails_title),
      scrollable: true,
      content: SelectionArea(
        child: Column(
          crossAxisAlignment: .stretch,
          spacing: AocUnit.small,
          children: [
            Card(
              child: AocPadding(
                padding: const .all(.medium),
                child: AocText(error.toString(), monospaced: true),
              ),
            ),
            if (stackTrace != null)
              Card(
                child: SingleChildScrollView(
                  padding: const AocEdgeInsets.all(.medium),
                  scrollDirection: .horizontal,
                  child: AocText(stackTrace.toString(), monospaced: true),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: AocText(s.common_close),
        ),
      ],
    );
  }
}
