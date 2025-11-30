import 'dart:ui';

extension BrightnessX on Brightness {
  Brightness get opposite => this == .dark ? .light : .dark;
}
