import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SettingsPage extends AocPage<void> {
  const SettingsPage() : super(child: const SettingsScreen());
}

class SettingsScreen extends StatelessObserverWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsStore = context.read<SettingsStore>();

    return AocScaffold(
      title: 'Settings',
      bodySlivers: [
        SliverList.list(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: SwitchListTile(
                title: const Text('Dark mode'),
                onChanged: (value) {
                  settingsStore.themeMode =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
                value: settingsStore.themeMode == ThemeMode.dark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
