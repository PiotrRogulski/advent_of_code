import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/common/utils/persistent_store.dart';
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
  SettingsData get data => SettingsData(
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
  ThemeMode themeMode = ThemeMode.dark;

  @observable
  bool useSystemTheme = false;

  @observable
  Locale? locale;
}

class SettingsData with EquatableMixin {
  const SettingsData({
    required this.themeMode,
    required this.useSystemTheme,
    required this.locale,
  });

  SettingsData.fromJson(Map<String, dynamic> json)
    : themeMode = ThemeMode.values.byName(json['themeMode'] as String),
      useSystemTheme = json['useSystemTheme'] as bool,
      locale = (json['locale'] as String?)?.apply(Locale.new);

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.name,
    'useSystemTheme': useSystemTheme,
    'locale': locale?.toString(),
  };

  final ThemeMode themeMode;
  final bool useSystemTheme;
  final Locale? locale;

  @override
  List<Object?> get props => [themeMode, useSystemTheme, locale];
}
