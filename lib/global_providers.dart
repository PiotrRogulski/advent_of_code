import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:advent_of_code/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AocProviders extends StatelessWidget {
  const AocProviders({
    super.key,
    required this.sharedPreferences,
    required this.child,
  });

  final SharedPreferences sharedPreferences;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AppSharedPreferences(sharedPreferences)),
        Provider(
          create: (context) => SettingsStore(prefs: context.read()),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      child: child,
    );
  }
}
