import 'package:advent_of_code/design_system/border.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:material_ui/material_ui.dart';
import 'package:more/more.dart';

class AocTheme() {
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
        contentPadding: AocEdgeInsets.symmetric(
          horizontal: .xlarge,
          vertical: .small,
        ),
      ),
      cardTheme: .new(
        clipBehavior: .antiAlias,
        elevation: 0,
        color: colorScheme.primaryContainer,
        margin: AocEdgeInsets.zero,
        shape: AocBorder(.large),
      ),
      splashColor: colorScheme.primary.withValues(alpha: 0.15),
      highlightColor: colorScheme.primary.withValues(alpha: 0.1),
      hoverColor: colorScheme.primary.withValues(alpha: 0.05),
      focusColor: colorScheme.primary.withValues(alpha: 0.1),
      pageTransitionsTheme: .new(
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

class const AocTextTheme({super.key, required final Widget child})
    extends StatelessWidget {
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
    fontFamily: 'Google Sans Flex',
    fontFamilyFallback: ['Roboto Flex', 'Noto Sans JP'],
    fontVariations: [
      ...?fontVariations,
      .weight((fontWeight ?? .normal).value.toDouble()),
      if (fontSize case final size?) .opticalSize(size),
      const .new('ROND', 100),
    ],
  );
}
