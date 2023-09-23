import 'package:advent_of_code/design_system/theme.dart';
import 'package:advent_of_code/router/routes.dart';
import 'package:flutter/material.dart';

class AocApp extends StatelessWidget {
  const AocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: ThemeMode.dark,
      theme: AocTheme.light,
      darkTheme: AocTheme.dark,
      routerConfig: router,
    );
  }
}
