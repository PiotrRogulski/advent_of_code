import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

class AocApp extends StatelessWidget {
  const AocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0x0000FF00),
          brightness: Brightness.dark,
        ),
      ).copyWith(
        splashFactory: InkSparkle.splashFactory,
      ),
      home: const AdaptiveScaffold(
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
  }
}
