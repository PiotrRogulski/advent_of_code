// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get common_close => 'Fermer';

  @override
  String get common_showDetails => 'Afficher les détails';

  @override
  String day_inputData({required String label}) {
    return 'Données d\'entrée ($label)';
  }

  @override
  String get day_inputData_errorLoading =>
      'Erreur lors du chargement des données d\'entrée';

  @override
  String day_inputData_matrixIndex({required int index}) {
    return '$index: ';
  }

  @override
  String get day_inputData_wrap => 'Habillage';

  @override
  String get day_inputExample => 'exemple';

  @override
  String get day_inputFull => 'complètes';

  @override
  String day_partTitle({required int part}) {
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
  String day_title({required int day, required int year}) {
    return '$day – $year';
  }

  @override
  String get day_useFullInput => 'Utiliser l\'entrée complète';

  @override
  String get errorDetails_title => 'Détails de l\'erreur';

  @override
  String get home_title => 'Accueil';

  @override
  String get settings_darkMode => 'Mode sombre';

  @override
  String get settings_language_systemDefault => 'Défaut du système';

  @override
  String get settings_language_title => 'Langue';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get settings_useSystemTheme => 'Utiliser le thème du système';

  @override
  String get visualizer_2025_01_timesPassedZero =>
      'Nombre de fois passé par zéro';

  @override
  String get visualizer_2025_01_timesStoppedAtZero =>
      'Nombre de fois arrêté à zéro';

  @override
  String get visualizer_2025_04_removedCountLabel => 'Éléments supprimés';

  @override
  String year_day({required int day}) {
    return 'Jour $day';
  }

  @override
  String year_title({required int year}) {
    return 'Année $year';
  }

  @override
  String get years_title => 'Années';
}
