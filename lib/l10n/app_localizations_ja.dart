// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get common_close => '閉じる';

  @override
  String get common_showDetails => '詳細を表示';

  @override
  String day_inputData({required String label}) {
    return '入力データ（$label）';
  }

  @override
  String get day_inputData_errorLoading => '入力データを読み込めませんでした';

  @override
  String day_inputData_matrixIndex({required int index}) {
    return '$index: ';
  }

  @override
  String get day_inputData_wrap => '折り返し';

  @override
  String get day_inputExample => 'サンプル';

  @override
  String get day_inputFull => '完全';

  @override
  String day_partTitle({required int part}) {
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
  String day_title({required int day, required int year}) {
    return '$day日目 – $year年';
  }

  @override
  String get day_useFullInput => '完全な入力を使用する';

  @override
  String get errorDetails_title => 'エラーの詳細';

  @override
  String get home_title => 'ホーム';

  @override
  String get settings_darkMode => 'ダークモード';

  @override
  String get settings_language_systemDefault => 'システムデフォルト';

  @override
  String get settings_language_title => '言語';

  @override
  String get settings_title => '設定';

  @override
  String get settings_useSystemTheme => 'システムテーマを使用する';

  @override
  String year_day({required int day}) {
    return '$day日目';
  }

  @override
  String year_title({required int year}) {
    return '$year年';
  }

  @override
  String get years_title => '年々';
}
