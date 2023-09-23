import 'dart:ui';

extension BrightnessX on Brightness {
  Brightness get opposite =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}
