import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:flutter/material.dart';

class AocSwitchListTile extends StatelessWidget {
  const AocSwitchListTile({
    super.key,
    required this.title,
    required this.onChanged,
    required this.value,
  });

  final String title;
  final ValueChanged<bool> onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return DynamicWeight(
      child: AocListTile(
        title: AocText(title),
        trailing: Switch(value: value, onChanged: onChanged),
        onTap: () => onChanged(!value),
        contentPadding: const AocEdgeInsets.only(
          start: .xlarge,
          end: .medium,
          top: .small,
          bottom: .small,
        ),
      ),
    );
  }
}
