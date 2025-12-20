import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ja'),
  ];

  /// No description provided for @common_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// No description provided for @common_showDetails.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get common_showDetails;

  /// No description provided for @day_inputData.
  ///
  /// In en, this message translates to:
  /// **'Input data ({label})'**
  String day_inputData({required String label});

  /// No description provided for @day_inputData_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading input data'**
  String get day_inputData_errorLoading;

  /// No description provided for @day_inputData_matrixIndex.
  ///
  /// In en, this message translates to:
  /// **'{index}: '**
  String day_inputData_matrixIndex({required int index});

  /// No description provided for @day_inputData_wrap.
  ///
  /// In en, this message translates to:
  /// **'Wrap'**
  String get day_inputData_wrap;

  /// No description provided for @day_inputExample.
  ///
  /// In en, this message translates to:
  /// **'example'**
  String get day_inputExample;

  /// No description provided for @day_inputFull.
  ///
  /// In en, this message translates to:
  /// **'full'**
  String get day_inputFull;

  /// No description provided for @day_partTitle.
  ///
  /// In en, this message translates to:
  /// **'Part {part}'**
  String day_partTitle({required int part});

  /// No description provided for @day_part_error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get day_part_error;

  /// No description provided for @day_part_noOutput.
  ///
  /// In en, this message translates to:
  /// **'No output'**
  String get day_part_noOutput;

  /// No description provided for @day_part_notRun.
  ///
  /// In en, this message translates to:
  /// **'Not run'**
  String get day_part_notRun;

  /// No description provided for @day_part_notRunSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Run to see the result'**
  String get day_part_notRunSubtitle;

  /// No description provided for @day_part_seeErrorDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to see error details'**
  String get day_part_seeErrorDetails;

  /// No description provided for @day_title.
  ///
  /// In en, this message translates to:
  /// **'{day} – {year}'**
  String day_title({required int day, required int year});

  /// No description provided for @day_useFullInput.
  ///
  /// In en, this message translates to:
  /// **'Use full input'**
  String get day_useFullInput;

  /// No description provided for @errorDetails_title.
  ///
  /// In en, this message translates to:
  /// **'Error details'**
  String get errorDetails_title;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @settings_darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settings_darkMode;

  /// No description provided for @settings_language_systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settings_language_systemDefault;

  /// No description provided for @settings_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language_title;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_useSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Use system theme'**
  String get settings_useSystemTheme;

  /// No description provided for @visualizer_2025_01_timesPassedZero.
  ///
  /// In en, this message translates to:
  /// **'Times passed zero'**
  String get visualizer_2025_01_timesPassedZero;

  /// No description provided for @visualizer_2025_01_timesStoppedAtZero.
  ///
  /// In en, this message translates to:
  /// **'Times stopped at zero'**
  String get visualizer_2025_01_timesStoppedAtZero;

  /// No description provided for @year_day.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String year_day({required int day});

  /// No description provided for @year_title.
  ///
  /// In en, this message translates to:
  /// **'Year {year}'**
  String year_title({required int year});

  /// No description provided for @years_title.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years_title;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
