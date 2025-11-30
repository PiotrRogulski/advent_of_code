import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/dropdown_list_tile.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:advent_of_code/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SettingsPage extends AocPage {
  const SettingsPage() : super(child: const SettingsScreen());
}

class SettingsScreen extends StatelessObserverWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.l10n;
    final settingsStore = context.read<SettingsStore>();

    return AocScaffold(
      title: s.settings_title,
      bodySlivers: [
        SliverPadding(
          padding: const .all(16),
          sliver: SliverList.list(
            children: [
              Card(
                child: SwitchListTile(
                  title: Text(s.settings_darkMode),
                  onChanged: (value) {
                    settingsStore.themeMode = value ? .dark : .light;
                  },
                  value: settingsStore.themeMode == .dark,
                ),
              ),
              Card(
                child: SwitchListTile(
                  title: Text(s.settings_useSystemTheme),
                  onChanged: (value) {
                    settingsStore.useSystemTheme = value;
                  },
                  value: settingsStore.useSystemTheme,
                ),
              ),
              AocDropdownListTile(
                title: Text(s.settings_language_title),
                onSelected: (locale) {
                  settingsStore.locale = locale;
                },
                items: const [null, ...AppLocalizations.supportedLocales],
                currentValue: settingsStore.locale,
                itemLabelBuilder: (locale) => switch (locale?.languageCode) {
                  null => s.settings_language_systemDefault,
                  'en' => 'English',
                  'fr' => 'Français',
                  'ja' => '日本語',
                  final languageCode => throw UnimplementedError(
                    'Unsupported language: $languageCode',
                  ),
                },
              ),
            ].spaced(height: 16),
          ),
        ),
      ],
    );
  }
}
