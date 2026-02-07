// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Hareru';

  @override
  String get settings => '設定';

  @override
  String get household => '家計簿';

  @override
  String get monthlyBudget => '月予算';

  @override
  String get categoryManage => 'カテゴリ管理';

  @override
  String get startDayOfWeek => '週の開始曜日';

  @override
  String get autoExcludeTransfer => '振込自動除外';

  @override
  String get autoExcludeTransferDesc => '口座間の振込を支出から自動で除外します';

  @override
  String get security => 'セキュリティ';

  @override
  String get appLock => 'アプリロック';

  @override
  String get appLockDesc => 'Face IDまたはパスコードでロック';

  @override
  String get icloudBackup => 'iCloudバックアップ';

  @override
  String get app => 'アプリ';

  @override
  String get screenMode => '画面モード';

  @override
  String get inputReminder => '入力リマインダー';

  @override
  String get inputReminderDesc => '毎日設定した時間にお知らせします';

  @override
  String get language => '言語';

  @override
  String get etc => 'その他';

  @override
  String get sendFeedback => 'ご意見を送る';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get madeWith => 'Made with 💙';

  @override
  String get comingSoon => 'coming soon';

  @override
  String get preparingFeature => '準備中の機能です';

  @override
  String get monthlyBudgetSetting => '月予算設定';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get add => '追加';

  @override
  String get delete => '削除';

  @override
  String get monday => '月曜日';

  @override
  String get sunday => '日曜日';

  @override
  String get system => 'システム';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get korean => '한국어';

  @override
  String get japanese => '日本語';

  @override
  String get english => 'English';

  @override
  String monthExpense(int month) {
    return '$month月の支出';
  }

  @override
  String comparedLastMonthDown(String amount) {
    return '先月より ¥$amount ↓ 節約！🎉';
  }

  @override
  String comparedLastMonthUp(String amount) {
    return '先月より ¥$amount ↑ 使いすぎ注意 ⚠️';
  }

  @override
  String budget(String amount) {
    return '予算 ¥$amount';
  }

  @override
  String get todayExpense => '今日の支出';

  @override
  String get total => '合計';

  @override
  String get thisWeekExpense => '今週の支出';

  @override
  String get today => '今日';

  @override
  String get noExpenseToday => '今日はまだ支出がありません';

  @override
  String get home => 'ホーム';

  @override
  String get report => 'レポート';

  @override
  String get input => '入力';

  @override
  String get dictionary => '辞書';

  @override
  String get categoryFood => '食費';

  @override
  String get categoryTransport => '交通';

  @override
  String get categoryShopping => '買物';

  @override
  String get categoryCafe => 'カフェ';

  @override
  String get categoryEntertainment => '娯楽';

  @override
  String get categoryMedical => '医療';

  @override
  String get categoryTransfer => '振込';

  @override
  String get categoryOther => 'その他';

  @override
  String get savingsTransfer => '貯金口座へ振込';

  @override
  String get lunch => 'ランチ';

  @override
  String get transportFee => '交通費';

  @override
  String get coffee => 'コーヒー';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get categoryAdd => 'カテゴリ追加';

  @override
  String get categoryName => 'カテゴリ名';

  @override
  String get notificationTime => '通知時間';
}
