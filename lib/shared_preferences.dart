import 'dart:convert';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/features/settings/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum _Key { settings }

class AppSharedPreferences {
  const AppSharedPreferences(this.prefs);

  final SharedPreferences prefs;

  // region Settings

  SettingsData? readSettings() =>
      _readJson(.settings)?.apply(SettingsData.fromJson);

  Future<void> writeSettings(SettingsData settings) =>
      _writeJson(.settings, settings.toJson());

  // endregion

  Map<String, dynamic>? _readJson(_Key key) =>
      prefs.getString(key.name)?.apply(jsonDecode) as Map<String, dynamic>?;

  Future<void> _writeJson(_Key key, Map<String, dynamic> json) =>
      prefs.setString(key.name, jsonEncode(json));
}
