import 'package:advent_of_code/common/extensions/brightness.dart';
import 'package:advent_of_code/design_system/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AocApp extends StatelessWidget {
  const AocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: AocTheme.light,
      darkTheme: AocTheme.dark,
      home: Builder(
        builder: (context) {
          final brightness = Theme.of(context).brightness;
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
              statusBarColor: Colors.transparent,
              systemStatusBarContrastEnforced: false,
              statusBarBrightness: brightness,
              statusBarIconBrightness: brightness.opposite,
              systemNavigationBarIconBrightness: brightness.opposite,
            ),
            child: const AdaptiveScaffold(
              useDrawer: false,
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_month),
                  label: 'Days',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
