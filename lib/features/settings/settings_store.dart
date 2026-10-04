import 'package:advent_of_code/common/utils/persistent_store.dart';
import 'package:advent_of_code/features/settings/app_locale.dart';
import 'package:advent_of_code/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rxdart/rxdart.dart';

class SettingsStore({required AppSharedPreferences prefs})
    extends PersistentStore<SettingsData> {
  this : super(read: prefs.readSettings, write: prefs.writeSettings);

  @override
  SettingsData get data => .new(
    themeMode: themeMode.value,
    useSystemTheme: useSystemTheme.value,
    locale: locale.value,
    christmasSpirit: christmasSpirit.value,
  );

  @override
  void restore(SettingsData? data) {
    themeMode = makeSubject(data?.themeMode ?? .dark);
    useSystemTheme = makeSubject(data?.useSystemTheme ?? false);
    locale = makeSubject(data?.locale ?? .systemDefault);
    christmasSpirit = makeSubject(data?.christmasSpirit ?? false);
  }

  late final BehaviorSubject<ThemeMode> themeMode;
  late final BehaviorSubject<bool> useSystemTheme;
  late final BehaviorSubject<AppLocale> locale;
  late final BehaviorSubject<bool> christmasSpirit;
}

class const SettingsData({
  required final ThemeMode themeMode,
  required final bool useSystemTheme,
  required final AppLocale locale,
  required final bool christmasSpirit,
}) with Equatable {
  new fromJson(Map<String, dynamic> json)
    : this(
        themeMode: .values.byName(json['themeMode'] as String),
        useSystemTheme: json['useSystemTheme'] as bool,
        locale: .fromCode(json['locale'] as String?),
        christmasSpirit: json['christmasSpirit'] as bool,
      );

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.name,
    'useSystemTheme': useSystemTheme,
    'locale': locale.localeCode,
    'christmasSpirit': christmasSpirit,
  };

  @override
  List<Object?> get props => [
    themeMode,
    useSystemTheme,
    locale,
    christmasSpirit,
  ];
}
