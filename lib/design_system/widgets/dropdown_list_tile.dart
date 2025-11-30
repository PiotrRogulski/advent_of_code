import 'package:advent_of_code/common/hooks/collect_as_notifier.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

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
    final (theme && ThemeData(:colorScheme, :textTheme)) = Theme.of(context);

    final openDropdownListenable = useValueNotifier(Object());

    void openDropdown() => openDropdownListenable.value = Object();

    final value = useCollectAsNotifier(currentValue);

    return Card(
      child: DropdownButton2(
        openDropdownListenable: openDropdownListenable,
        isExpanded: true,
        underline: const SizedBox(),
        valueListenable: value,
        items: [
          for (final item in items)
            DropdownItem(value: item, child: Text(itemLabelBuilder(item))),
        ],
        barrierColor: colorScheme.surface.withValues(alpha: 0.5),
        dropdownStyleData: .new(
          useRootNavigator: true,
          elevation: 0,
          offset: const .new(0, -16),
          padding: .zero,
          dropdownBuilder: (context, child) => Card(child: child),
        ),
        onChanged: onSelected,
        customButton: ListTile(
          title: title,
          trailing: Text(
            itemLabelBuilder(currentValue),
            style: textTheme.labelLarge,
          ),
          onTap: openDropdown,
        ),
      ),
    );
  }
}
