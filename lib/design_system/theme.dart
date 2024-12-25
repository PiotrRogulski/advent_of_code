import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:more/more.dart';

class AocTheme {
  static const _seedColor = Color(0xFF00FF00);

  static final dark = _makeTheme.bind0(Brightness.dark);

  static final light = _makeTheme.bind0(Brightness.light);

  static ThemeData _makeTheme(
    Brightness brightness,
    ColorScheme? systemScheme,
  ) {
    final colorScheme = systemScheme ?? _makeColorScheme(brightness);

    final typography = Typography.material2021(colorScheme: colorScheme);
    final baseTextTheme = switch (brightness) {
      Brightness.light => typography.black,
      Brightness.dark => typography.white,
    };

    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: baseTextTheme.apply(fontFamily: FontFamily.robotoFlex),
    ).copyWith(
      splashFactory: InkSparkle.splashFactory,
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: colorScheme.primaryContainer,
        margin: EdgeInsets.zero,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 16,
            cornerSmoothing: 1,
          ),
        ),
      ),
      splashColor: colorScheme.primary.withValues(alpha: 0.15),
      highlightColor: colorScheme.primary.withValues(alpha: 0.1),
      hoverColor: colorScheme.primary.withValues(alpha: 0.05),
      focusColor: colorScheme.primary.withValues(alpha: 0.1),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          for (final type in TargetPlatform.values)
            type: const FadeForwardsPageTransitionsBuilder(),
        },
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false),
    );
  }

  static ColorScheme _makeColorScheme(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
      dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
    );
  }
}

class FontOpticalSizeAdjuster extends StatelessWidget {
  const FontOpticalSizeAdjuster({super.key, required this.child});

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
