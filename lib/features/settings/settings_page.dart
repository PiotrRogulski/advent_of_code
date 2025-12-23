import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/design_system/padding.dart';
import 'package:advent_of_code/design_system/page.dart';
import 'package:advent_of_code/design_system/widgets/dropdown_list_tile.dart';
import 'package:advent_of_code/design_system/widgets/scaffold.dart';
import 'package:advent_of_code/design_system/widgets/switch_list_tile.dart';
import 'package:advent_of_code/features/settings/app_locale.dart';
import 'package:advent_of_code/features/settings/settings_store.dart';
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
        AocSliverPadding(
          padding: const .all(.medium),
          sliver: SliverList.list(
            children: [
              Card(
                child: AocSwitchListTile(
                  title: s.settings_darkMode,
                  onChanged: (value) {
                    settingsStore.themeMode = value ? .dark : .light;
                  },
                  value: settingsStore.themeMode == .dark,
                ),
              ),
              Card(
                child: AocSwitchListTile(
                  title: s.settings_useSystemTheme,
                  onChanged: (value) {
                    settingsStore.useSystemTheme = value;
                  },
                  value: settingsStore.useSystemTheme,
                ),
              ),
              Card(
                child: AocSwitchListTile(
                  title: s.settings_christmasSpirit,
                  onChanged: (value) {
                    settingsStore.christmasSpirit = value;
                  },
                  value: settingsStore.christmasSpirit,
                ),
              ),
              AocDropdownListTile(
                title: s.settings_language_title,
                onSelected: (locale) {
                  settingsStore.locale = locale;
                },
                items: AppLocale.values,
                currentValue: settingsStore.locale,
                itemLabelBuilder: (locale) => locale.label(s),
              ),
            ].spaced(height: .medium),
          ),
        ),
      ],
    );
  }
}
