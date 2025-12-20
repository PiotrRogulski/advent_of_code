// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_close => 'Close';

  @override
  String get common_showDetails => 'Show details';

  @override
  String day_inputData({required String label}) {
    return 'Input data ($label)';
  }

  @override
  String get day_inputData_errorLoading => 'Error loading input data';

  @override
  String day_inputData_matrixIndex({required int index}) {
    return '$index: ';
  }

  @override
  String get day_inputData_wrap => 'Wrap';

  @override
  String get day_inputExample => 'example';

  @override
  String get day_inputFull => 'full';

  @override
  String day_partTitle({required int part}) {
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
  String day_title({required int day, required int year}) {
    return '$day – $year';
  }

  @override
  String get day_useFullInput => 'Use full input';

  @override
  String get errorDetails_title => 'Error details';

  @override
  String get home_title => 'Home';

  @override
  String get settings_darkMode => 'Dark mode';

  @override
  String get settings_language_systemDefault => 'System default';

  @override
  String get settings_language_title => 'Language';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_useSystemTheme => 'Use system theme';

  @override
  String get visualizer_2025_01_timesPassedZero => 'Times passed zero';

  @override
  String get visualizer_2025_01_timesStoppedAtZero => 'Times stopped at zero';

  @override
  String year_day({required int day}) {
    return 'Day $day';
  }

  @override
  String year_title({required int year}) {
    return 'Year $year';
  }

  @override
  String get years_title => 'Years';
}
