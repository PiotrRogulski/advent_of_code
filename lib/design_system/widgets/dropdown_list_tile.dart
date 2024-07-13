import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AocDropdownListTile<T> extends HookWidget {
  const AocDropdownListTile({
    super.key,
    required this.title,
    required this.onSelected,
    required this.items,
    required this.currentValue,
    required this.itemLabelBuilder,
  });

  final Widget title;
  final ValueChanged<T?> onSelected;
  final List<T> items;
  final T currentValue;
  final String Function(T) itemLabelBuilder;

  @override
  Widget build(BuildContext context) {
    final dropdownKey = useMemoized(GlobalKey<DropdownButton2State<T>>.new);

    return Card(
      child: DropdownButton2(
        key: dropdownKey,
        isExpanded: true,
        underline: const SizedBox(),
        items: [
          for (final item in items)
            DropdownMenuItem(
              value: item,
              child: Text(itemLabelBuilder(item)),
            ),
        ],
        barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        dropdownStyleData: DropdownStyleData(
          useRootNavigator: true,
          elevation: 0,
          offset: const Offset(0, -16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onChanged: onSelected,
        customButton: ListTile(
          title: title,
          trailing: Text(
            itemLabelBuilder(currentValue),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          onTap: () {
            dropdownKey.currentState?.callTap();
          },
        ),
      ),
    );
  }
}
