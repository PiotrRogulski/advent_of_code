import 'package:advent_of_code/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:more/more.dart';

class AocTheme {
  static const _seedColor = Color(0xFF00FF00);

  static final dark = _makeTheme.bind0(.dark);

  static final light = _makeTheme.bind0(.light);

  static ThemeData _makeTheme(
    Brightness brightness,
    ColorScheme? systemScheme,
  ) {
    final colorScheme = systemScheme ?? _makeColorScheme(brightness);

    return .from(colorScheme: colorScheme).copyWith(
      splashFactory: InkSparkle.splashFactory,
      listTileTheme: const .new(
        contentPadding: .symmetric(horizontal: 32, vertical: 8),
      ),
      cardTheme: .new(
        clipBehavior: .antiAlias,
        elevation: 0,
        color: colorScheme.primaryContainer,
        margin: .zero,
        shape: RoundedSuperellipseBorder(borderRadius: .circular(24)),
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
      // Remove when it's the default
      // ignore: deprecated_member_use
      progressIndicatorTheme: const .new(year2023: false),
    );
  }

  static ColorScheme _makeColorScheme(Brightness brightness) => .fromSeed(
    seedColor: _seedColor,
    brightness: brightness,
    dynamicSchemeVariant: .vibrant,
  );
}

class AocTextTheme extends StatelessWidget {
  const AocTextTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final textTheme = baseTheme.textTheme;

    return Theme(
      data: baseTheme.copyWith(
        textTheme: textTheme.copyWith(
          displayLarge: textTheme.displayLarge?.variable,
          displayMedium: textTheme.displayMedium?.variable,
          displaySmall: textTheme.displaySmall?.variable,
          headlineLarge: textTheme.headlineLarge?.variable,
          headlineMedium: textTheme.headlineMedium?.variable,
          headlineSmall: textTheme.headlineSmall?.variable,
          titleLarge: textTheme.titleLarge?.variable,
          titleMedium: textTheme.titleMedium?.variable,
          titleSmall: textTheme.titleSmall?.variable,
          bodyLarge: textTheme.bodyLarge?.variable,
          bodyMedium: textTheme.bodyMedium?.variable,
          bodySmall: textTheme.bodySmall?.variable,
          labelLarge: textTheme.labelLarge?.variable,
          labelMedium: textTheme.labelMedium?.variable,
          labelSmall: textTheme.labelSmall?.variable,
        ),
      ),
      child: child,
    );
  }
}

extension on TextStyle {
  TextStyle get variable => copyWith(
    fontFamily: FontFamily.robotoFlex,
    fontVariations: [
      ...?fontVariations,
      .weight((fontWeight ?? .normal).value.toDouble()),
      if (fontSize case final size?) .opticalSize(size),
    ],
  );
}
