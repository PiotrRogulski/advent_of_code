// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStoreBase, Store {
  late final _$themeModeAtom = Atom(
    name: '_SettingsStoreBase.themeMode',
    context: context,
  );

  @override
  ThemeMode get themeMode {
    _$themeModeAtom.reportRead();
    return super.themeMode;
  }

  @override
  set themeMode(ThemeMode value) {
    _$themeModeAtom.reportWrite(value, super.themeMode, () {
      super.themeMode = value;
    });
  }

  late final _$useSystemThemeAtom = Atom(
    name: '_SettingsStoreBase.useSystemTheme',
    context: context,
  );

  @override
  bool get useSystemTheme {
    _$useSystemThemeAtom.reportRead();
    return super.useSystemTheme;
  }

  @override
  set useSystemTheme(bool value) {
    _$useSystemThemeAtom.reportWrite(value, super.useSystemTheme, () {
      super.useSystemTheme = value;
    });
  }

  late final _$localeAtom = Atom(
    name: '_SettingsStoreBase.locale',
    context: context,
  );

  @override
  Locale? get locale {
    _$localeAtom.reportRead();
    return super.locale;
  }

  @override
  set locale(Locale? value) {
    _$localeAtom.reportWrite(value, super.locale, () {
      super.locale = value;
    });
  }

  @override
  String toString() {
    return '''
themeMode: ${themeMode},
useSystemTheme: ${useSystemTheme},
locale: ${locale}
    ''';
  }
}
