import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:flutter/material.dart';

class AocDropdownListTile<T> extends StatelessWidget {
  const AocDropdownListTile({
    super.key,
    required this.title,
    required this.onSelected,
    required this.items,
    required this.currentValue,
    required this.itemLabelBuilder,
  });

  final String title;
  final ValueChanged<T> onSelected;
  final List<T> items;
  final T currentValue;
  final String Function(T) itemLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);

    return AocExpansionCard(
      title: title,
      trailing: Text(
        itemLabelBuilder(currentValue),
        style: textTheme.labelLarge,
      ),
      body: RadioGroup(
        groupValue: currentValue,
        onChanged: (value) {
          if (value != null) {
            onSelected(value);
          }
        },
        child: Padding(
          padding: const .all(8),
          child: Column(
            spacing: 8,
            children: [
              for (final item in items)
                Material(
                  shape: RoundedSuperellipseBorder(
                    borderRadius: .circular(8),
                    side: .new(
                      color: currentValue == item
                          ? Colors.transparent
                          : colorScheme.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  clipBehavior: .antiAlias,
                  child: RadioListTile(
                    title: Text(itemLabelBuilder(item)),
                    value: item,
                    tileColor: currentValue == item
                        ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                        : null,
                    contentPadding: const .symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
