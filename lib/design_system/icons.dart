// ignore_for_file: constant_identifier_names

import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/widgets.dart';

class AocIconData extends IconData {
  const AocIconData(super.codePoint)
      : super(fontFamily: FontFamily.materialSymbolsRounded);
}

@staticIconProvider
final class AocIcons {
  AocIcons._();

  static const calendar_month = AocIconData(0xEBCC);
  static const check = AocIconData(0xE5CA);
  static const home = AocIconData(0xE88A);
  static const play_circle = AocIconData(0xE1C4);
  static const settings = AocIconData(0xE8B8);
}
