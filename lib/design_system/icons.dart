// ignore_for_file: constant_identifier_names

import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/widgets.dart';

class AocIconData extends IconData {
  const AocIconData(super.codePoint)
      : super(fontFamily: FontFamily.materialSymbolsRounded);
}

final class AocIcons {
  AocIcons._();

  static const IconData calendar_month = AocIconData(0xEBCC);
  static const IconData home = AocIconData(0xE88A);
  static const IconData settings = AocIconData(0xE8B8);
}
