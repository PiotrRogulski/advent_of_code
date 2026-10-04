import 'package:collection/collection.dart';
import 'package:custom_adaptive_scaffold/custom_adaptive_scaffold.dart';
import 'package:material_ui/material_ui.dart';

class const BreakpointSelector({
  super.key,
  required final Map<Breakpoint?, WidgetBuilder> builders,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final builder =
        builders.entries
            .firstWhereOrNull((entry) => entry.key?.isActive(context) ?? false)
            ?.value ??
        builders[null]!;

    return builder(context);
  }
}
