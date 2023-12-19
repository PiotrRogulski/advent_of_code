import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class AocTheme {
  static const _seedColor = Color(0xFF00FF00);

  static ThemeData dark(ColorScheme? systemScheme) =>
      _makeTheme(Brightness.dark, systemScheme);

  static ThemeData light(ColorScheme? systemScheme) =>
      _makeTheme(Brightness.light, systemScheme);

  static ThemeData _makeTheme(
    Brightness brightness,
    ColorScheme? systemScheme,
  ) {
    final colorScheme = systemScheme ?? _makeColorScheme(brightness);

    final typography = Typography.material2021(
      colorScheme: colorScheme,
    );
    final baseTextTheme = switch (brightness) {
      Brightness.light => typography.black,
      Brightness.dark => typography.white,
    };

    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: baseTextTheme.apply(
        fontFamily: FontFamily.robotoFlex,
      ),
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
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbIcon: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            // TODO: use AocIcons
            // ignore: use_design_system_item_AocIcon
            return const Icon(Icons.check_rounded);
          } else {
            return null;
          }
        }),
      ),
      splashColor: colorScheme.primary.withOpacity(0.15),
      highlightColor: colorScheme.primary.withOpacity(0.1),
      hoverColor: colorScheme.primary.withOpacity(0.05),
      focusColor: colorScheme.primary.withOpacity(0.1),
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

class FontOpticalSizeAdjuster extends StatelessWidget {
  const FontOpticalSizeAdjuster({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final textTheme = baseTheme.textTheme;

    return Theme(
      data: baseTheme.copyWith(
        textTheme: textTheme.copyWith(
          displayLarge: textTheme.displayLarge?.withOpticalSize,
          displayMedium: textTheme.displayMedium?.withOpticalSize,
          displaySmall: textTheme.displaySmall?.withOpticalSize,
          headlineLarge: textTheme.headlineLarge?.withOpticalSize,
          headlineMedium: textTheme.headlineMedium?.withOpticalSize,
          headlineSmall: textTheme.headlineSmall?.withOpticalSize,
          titleLarge: textTheme.titleLarge?.withOpticalSize,
          titleMedium: textTheme.titleMedium?.withOpticalSize,
          titleSmall: textTheme.titleSmall?.withOpticalSize,
          bodyLarge: textTheme.bodyLarge?.withOpticalSize,
          bodyMedium: textTheme.bodyMedium?.withOpticalSize,
          bodySmall: textTheme.bodySmall?.withOpticalSize,
          labelLarge: textTheme.labelLarge?.withOpticalSize,
          labelMedium: textTheme.labelMedium?.withOpticalSize,
          labelSmall: textTheme.labelSmall?.withOpticalSize,
        ),
      ),
      child: child,
    );
  }
}

extension on TextStyle {
  TextStyle get withOpticalSize => copyWith(
        fontVariations: [
          ...?fontVariations,
          if (fontSize case final size?) FontVariation.opticalSize(size),
        ],
      );
}
