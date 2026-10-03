import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:material_ui/material_ui.dart';

class const AocCheckboxListTile({
  super.key,
  required final bool value,
  required final ValueChanged<bool?> onChanged,
  required final String title,
  final bool? dense,
}) extends StatelessWidget {
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
