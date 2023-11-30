import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get day_inputData => 'Input data';

  @override
  String day_inputData_matrixIndex(int index) {
    return '$index: ';
  }

  @override
  String get day_inputData_wrap => 'Wrap';

  @override
  String day_partTitle(int part) {
    return 'Part $part';
  }

  @override
  String get day_part_error => 'An error occurred';

  @override
  String get day_part_noOutput => 'No output';

  @override
  String get day_part_notRun => 'Not run';

  @override
  String get day_part_notRunSubtitle => 'Run to see the result';

  @override
  String get day_part_seeErrorDetails => 'Tap to see error details';

  @override
  String day_title(int day, int year) {
    return '$day – $year';
  }

  @override
  String get home_title => 'Home';

  @override
  String get settings_darkMode => 'Dark mode';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_useSystemTheme => 'Use system theme';

  @override
  String year_day(int day) {
    return 'Day $day';
  }

  @override
  String year_title(int year) {
    return 'Year $year';
  }

  @override
  String get years_title => 'Years';
}
