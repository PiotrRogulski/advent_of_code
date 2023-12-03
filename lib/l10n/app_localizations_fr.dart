import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get day_inputData => 'Données d\'entrée';

  @override
  String day_inputData_matrixIndex(int index) {
    return '$index: ';
  }

  @override
  String get day_inputData_wrap => 'Habillage';

  @override
  String day_partTitle(int part) {
    return 'Partie $part';
  }

  @override
  String get day_part_error => 'Une erreur s\'est produite';

  @override
  String get day_part_noOutput => 'Aucune sortie';

  @override
  String get day_part_notRun => 'Non exécuté';

  @override
  String get day_part_notRunSubtitle => 'Exécuter pour voir le résultat';

  @override
  String get day_part_seeErrorDetails =>
      'Appuyez pour voir les détails de l\'erreur';

  @override
  String day_title(int day, int year) {
    return '$day – $year';
  }

  @override
  String get day_useFullInput => 'Utiliser l\'entrée complète';

  @override
  String get home_title => 'Accueil';

  @override
  String get settings_darkMode => 'Mode sombre';

  @override
  String settings_language(String lang) {
    String _temp0 = intl.Intl.selectLogic(
      lang,
      {
        'en': 'English',
        'fr': 'Français',
        'ja': '日本語',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get settings_language_systemDefault => 'Défaut du système';

  @override
  String get settings_language_title => 'Langue';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get settings_useSystemTheme => 'Utiliser le thème du système';

  @override
  String year_day(int day) {
    return 'Jour $day';
  }

  @override
  String year_title(int year) {
    return 'Année $year';
  }

  @override
  String get years_title => 'Années';
}
