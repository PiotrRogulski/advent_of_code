import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class BreakpointSelector extends StatelessWidget {
  const BreakpointSelector({super.key, required this.builders});

  final Map<Breakpoint?, WidgetBuilder> builders;

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
