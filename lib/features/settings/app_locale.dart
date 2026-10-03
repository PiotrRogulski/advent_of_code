import 'dart:ui';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/l10n/app_localizations.dart';

enum AppLocale(final String? localeCode) {
  systemDefault(null),
  english('en'),
  french('fr'),
  japanese('ja');

  factory fromCode(String? localeCode) => values.firstWhere(
    (e) => e.localeCode == localeCode,
    orElse: () => throw UnimplementedError('Unsupported locale: $localeCode'),
  );

  Locale? get locale => localeCode?.apply(Locale.new);

  String label(AppLocalizations s) => switch (this) {
    systemDefault => s.settings_language_systemDefault,
    english => 'English',
    french => 'Français',
    japanese => '日本語',
  };
}
