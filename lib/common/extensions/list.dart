import 'package:flutter/material.dart';
import 'package:more/collection.dart';

extension WidgetListX<T extends Widget> on List<Widget> {
  List<Widget> spaced({double width = 0, double height = 0}) {
    return separatedBy(() => SizedBox(width: width, height: height)).toList();
  }
}
