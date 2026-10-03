import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/expansion_card.dart';
import 'package:advent_of_code/design_system/widgets/radio_list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:material_ui/material_ui.dart';

class const AocDropdownListTile<T>({
  super.key,
  required final String title,
  required final ValueChanged<T> onSelected,
  required final List<T> items,
  required final T currentValue,
  required final String Function(T) itemLabelBuilder,
}) extends StatelessWidget {
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
