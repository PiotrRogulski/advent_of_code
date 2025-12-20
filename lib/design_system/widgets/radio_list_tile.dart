import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:flutter/material.dart';

class AocRadioListTile<T> extends StatelessWidget {
  const AocRadioListTile({super.key, required this.title, required this.value});

  final String title;
  final T value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final group = RadioGroup.maybeOf<T>(context);

    return DynamicWeight(
      child: Material(
        shape: AocBorder(
          .small,
          side: .new(
            color: group?.groupValue == value
                ? Colors.transparent
                : theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
        clipBehavior: .antiAlias,
        child: AocListTile(
          title: AocText(title),
          leading: IgnorePointer(child: Radio(value: value)),
          onTap: () => group?.onChanged(value),
          tileColor: group?.groupValue == value
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
              : null,
          contentPadding: const AocEdgeInsets.symmetric(
            horizontal: .medium,
            vertical: .small,
          ),
        ),
      ),
    );
  }
}
