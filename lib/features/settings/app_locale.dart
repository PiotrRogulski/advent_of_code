import 'dart:ui';

import 'package:advent_of_code/common/extensions.dart';
import 'package:advent_of_code/l10n/app_localizations.dart';

enum AppLocale {
  systemDefault(null),
  english('en'),
  french('fr'),
  japanese('ja');

  const AppLocale(this.localeCode);

  factory AppLocale.fromCode(String? localeCode) => values.firstWhere(
    (e) => e.localeCode == localeCode,
    orElse: () => throw UnimplementedError('Unsupported locale: $localeCode'),
  );

  final String? localeCode;

  Locale? get locale => localeCode?.apply(Locale.new);

  String label(AppLocalizations s) => switch (this) {
    systemDefault => s.settings_language_systemDefault,
    english => 'English',
    french => 'Français',
    japanese => '日本語',
  };
}
