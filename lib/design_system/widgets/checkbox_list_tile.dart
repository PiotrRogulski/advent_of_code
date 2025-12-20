import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:flutter/material.dart';

class AocCheckboxListTile extends StatelessWidget {
  const AocCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.dense,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String title;
  final bool? dense;

  @override
  Widget build(BuildContext context) {
    return DynamicWeight(
      child: AocListTile(
        title: AocText(title),
        dense: dense,
        leading: Checkbox(
          value: value,
          onChanged: onChanged,
          visualDensity: .compact,
        ),
        onTap: () => onChanged(!value),
        contentPadding: const AocEdgeInsets.symmetric(horizontal: .large),
      ),
    );
  }
}
