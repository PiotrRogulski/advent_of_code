import 'package:flutter/material.dart';

extension ListX<T> on List<T> {
  List<T> intersperse(T item) {
    return expand((element) => [item, element]).skip(1).toList();
  }
}

extension WidgetListX<T extends Widget> on List<Widget> {
  List<Widget> spaced({double width = 0, double height = 0}) {
    return intersperse(SizedBox(width: width, height: height));
  }
}
