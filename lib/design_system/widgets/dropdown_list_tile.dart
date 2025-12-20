import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/design_system/widgets/radio_list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
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
      trailing: AocText(
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
        child: AocPadding(
          padding: const .all(.small),
          child: Column(
            spacing: 8,
            children: [
              for (final item in items)
                AocRadioListTile(title: itemLabelBuilder(item), value: item),
            ],
          ),
        ),
      ),
    );
  }
}
