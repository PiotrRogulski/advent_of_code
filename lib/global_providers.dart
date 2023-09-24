import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AocProviders extends StatelessWidget {
  const AocProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => SettingsStore(),
        ),
      ],
      child: child,
    );
  }
}
