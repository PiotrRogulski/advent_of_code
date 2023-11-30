import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase with Store {
  @observable
  ThemeMode themeMode = ThemeMode.dark;

  @observable
  bool useSystemTheme = true;

  @observable
  Locale? locale;
}
