import 'package:advent_of_code/design_system/dynamic_weight.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:flutter/material.dart';

class AocListTile extends StatelessWidget {
  const AocListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.dense,
    this.leading,
    this.trailing,
    this.contentPadding,
    this.tileColor,
  });

  final Widget title;
  final Widget? subtitle;
  final bool? dense;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AocEdgeInsets? contentPadding;
  final Color? tileColor;

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
