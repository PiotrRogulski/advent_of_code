import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/widgets/list_tile.dart';
import 'package:advent_of_code/design_system/widgets/text.dart';
import 'package:material_ui/material_ui.dart';

class const AocSwitchListTile({
  super.key,
  required final String title,
  required final ValueChanged<bool> onChanged,
  required final bool value,
}) extends StatelessWidget {
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
