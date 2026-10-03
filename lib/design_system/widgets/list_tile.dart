import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:material_ui/material_ui.dart';

class const AocListTile({
  super.key,
  required final Widget title,
  final Widget? subtitle,
  final VoidCallback? onTap,
  final bool? dense,
  final Widget? leading,
  final Widget? trailing,
  final AocEdgeInsets? contentPadding,
  final Color? tileColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is the definition
    // ignore: leancode_lint/use_design_system_item
    return ListTile(
      statesController: DynamicWeight.maybeOf(context)?.controller,
      title: title,
      subtitle: subtitle,
      dense: dense,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      contentPadding: contentPadding,
      tileColor: tileColor,
    );
  }
}
