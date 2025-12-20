import 'package:advent_of_code/design_system/unit.dart';
import 'package:flutter/material.dart';
import 'package:more/collection.dart';

extension WidgetListX<T extends Widget> on List<Widget> {
  List<Widget> spaced({AocUnit width = .zero, AocUnit height = .zero}) =>
      separatedBy(() => SizedBox(width: width, height: height)).toList();
}

extension ListX<T> on List<T> {
  int? maybeIndexOf(T element) => switch (indexOf(element)) {
    -1 => null,
    final index => index,
  };
}
