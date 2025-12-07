import 'package:advent_of_code/common/utils/persistent_store.dart';
import 'package:advent_of_code/features/settings/app_locale.dart';
import 'package:advent_of_code/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

class SettingsStore extends _SettingsStoreBase
    with _$SettingsStore, PersistentStore<SettingsData> {
  SettingsStore({required AppSharedPreferences prefs}) {
    persist(read: prefs.readSettings, write: prefs.writeSettings);
  }

  @override
  SettingsData get data => .new(
    themeMode: themeMode,
    useSystemTheme: useSystemTheme,
    locale: locale,
  );

  @override
  void restore(SettingsData data) {
    themeMode = data.themeMode;
    useSystemTheme = data.useSystemTheme;
    locale = data.locale;
  }
}

abstract class _SettingsStoreBase with Store {
  @observable
  ThemeMode themeMode = .dark;

  @observable
  bool useSystemTheme = false;

  @observable
  AppLocale locale = .systemDefault;
}

class SettingsData with EquatableMixin {
  const SettingsData({
    required this.themeMode,
    required this.useSystemTheme,
    required this.locale,
  });

  SettingsData.fromJson(Map<String, dynamic> json)
    : themeMode = .values.byName(json['themeMode'] as String),
      useSystemTheme = json['useSystemTheme'] as bool,
      locale = .fromCode(json['locale'] as String?);

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.name,
    'useSystemTheme': useSystemTheme,
    'locale': locale.localeCode,
  };

  final ThemeMode themeMode;
  final bool useSystemTheme;
  final AppLocale locale;

  @override
  List<Object?> get props => [themeMode, useSystemTheme, locale];
}
