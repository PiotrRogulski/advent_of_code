import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get day_inputData => '入力データ';

  @override
  String day_inputData_matrixIndex(int index) {
    return '$index: ';
  }

  @override
  String get day_inputData_wrap => '折り返し';

  @override
  String day_partTitle(int part) {
    return 'パート $part';
  }

  @override
  String get day_part_error => 'エラーが発生しました';

  @override
  String get day_part_noOutput => '出力なし';

  @override
  String get day_part_notRun => '実行されていません';

  @override
  String get day_part_notRunSubtitle => '結果を確認するには、実行してください';

  @override
  String get day_part_seeErrorDetails => 'タップするとエラーの詳細が表示されます';

  @override
  String day_title(int day, int year) {
    return '$day日目 – $year年';
  }

  @override
  String get home_title => 'ホーム';

  @override
  String get settings_darkMode => 'ダークモード';

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
  String get settings_language_systemDefault => 'システムデフォルト';

  @override
  String get settings_language_title => '言語';

  @override
  String get settings_title => '設定';

  @override
  String get settings_useSystemTheme => 'システムテーマを使用する';

  @override
  String year_day(int day) {
    return '$day日目';
  }

  @override
  String year_title(int year) {
    return '$year年';
  }

  @override
  String get years_title => '年々';
}
