import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class AocTheme {
  static const _seedColor = Color(0xFF00FF00);

  static ThemeData dark = _makeTheme(Brightness.dark);

  static ThemeData light = _makeTheme(Brightness.light);

  static ThemeData _makeTheme(Brightness brightness) {
    final colorScheme = _makeColorScheme(brightness);
    return ThemeData.from(
      colorScheme: colorScheme,
    ).copyWith(
      splashFactory: InkSparkle.splashFactory,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 8,
        ),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: colorScheme.surfaceVariant,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }

  static ColorScheme _makeColorScheme(Brightness brightness) {
    final scheme = SchemeFidelity(
      sourceColorHct: Hct.fromInt(_seedColor.value),
      isDark: brightness == Brightness.dark,
      contrastLevel: 1,
    );
    return CorePalette.fromList([
      ...scheme.primaryPalette.asList,
      ...scheme.secondaryPalette.asList,
      ...scheme.tertiaryPalette.asList,
      ...scheme.neutralPalette.asList,
      ...scheme.neutralVariantPalette.asList,
    ]).toColorScheme(brightness: brightness).harmonized();
  }
}
