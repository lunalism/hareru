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

  @override
  String get receiptScan => 'レシートスキャン';

  @override
  String get manualInput => '手動入力';

  @override
  String get receiptScanDesc => 'カメラでレシートを撮影します';

  @override
  String get manualInputDesc => '金額とカテゴリを直接入力します';

  @override
  String get expense => '支出';

  @override
  String get income => '収入';

  @override
  String get transfer => '振込';

  @override
  String get enterAmount => '金額入力';

  @override
  String get selectCategory => 'カテゴリ選択';

  @override
  String get addMemo => 'メモ追加';

  @override
  String get date => '日付';

  @override
  String get memo => 'メモ';

  @override
  String get fromAccount => '引落口座';

  @override
  String get toAccount => '入金口座';

  @override
  String get categorySalary => '給料';

  @override
  String get categoryAllowance => 'お小遣い';

  @override
  String get categorySidejob => '副業';

  @override
  String get categoryInvestment => '投資';

  @override
  String get receiptScanTitle => 'レシートスキャン';

  @override
  String get receiptScanComingSoon => '準備中の機能です';

  @override
  String get noTransactions => 'まだ取引履歴がありません';

  @override
  String get addFirstTransaction => '＋ボタンで最初の取引を追加しましょう';

  @override
  String get inputMethod => '入力方法';

  @override
  String get amount => '金額';

  @override
  String get savedSuccess => '保存しました';

  @override
  String get reportTitle => 'レポート';

  @override
  String get periodWeekly => '週間';

  @override
  String get periodMonthly => '月間';

  @override
  String get periodYearly => '年間';

  @override
  String get realExpense => '実質支出';

  @override
  String transferExcluded(String amount) {
    return '振込 ¥$amount 除外';
  }

  @override
  String get balance => '残高';

  @override
  String get comparedToPrevMonth => '前月比';

  @override
  String get categoryBreakdown => 'カテゴリ別支出';

  @override
  String get expenseTrend => '支出推移';

  @override
  String get monthlyInsight => '今月のインサイト';

  @override
  String get weeklyInsight => '今週のインサイト';

  @override
  String get yearlyInsight => '今年のインサイト';

  @override
  String get categoryDetail => 'カテゴリ詳細';

  @override
  String get topSpendingDay => '一番使った日';

  @override
  String get comparedToPrev => '前月比の変化';

  @override
  String get leastSpendingWeek => '一番使わなかった週';

  @override
  String get noReportDataTitle => 'まだデータがありません';

  @override
  String get noReportDataDesc => '支出を記録すると\nここで分析を見られます';

  @override
  String get recordExpense => '支出を記録する';

  @override
  String get showMore => 'もっと見る';

  @override
  String transactionCount(int count) {
    return '$count件';
  }

  @override
  String dailyAverage(String amount) {
    return '平均 ¥$amount/日';
  }

  @override
  String get notEnoughData => 'まだデータが十分ではありません。記録を続けてみましょう！';

  @override
  String get increase => '増加';

  @override
  String get decrease => '減少';

  @override
  String yearFormat(int year) {
    return '$year年';
  }

  @override
  String monthFormat(int year, int month) {
    return '$year年 $month月';
  }

  @override
  String weekFormat(int month, int week) {
    return '$month月 第$week週';
  }

  @override
  String weekRangeFormat(
    int startMonth,
    int startDay,
    int endMonth,
    int endDay,
  ) {
    return '$startMonth/$startDay ~ $endMonth/$endDay';
  }

  @override
  String categoryIncreased(String category, int percent) {
    return '$categoryが$percent%増加しました';
  }

  @override
  String categoryDecreased(String category, int percent) {
    return '$categoryが$percent%減少しました';
  }

  @override
  String nthWeek(int n) {
    return '第$n週';
  }

  @override
  String get premiumDividerLabel => 'AI分析';

  @override
  String get premiumDividerLabelFree => 'AI分析 (Clear専用)';

  @override
  String get premiumBadge => 'Clear';

  @override
  String get aiInsightTitle => 'AI分析レポート';

  @override
  String get clearComparisonTitle => 'クリア比較';

  @override
  String get clearComparisonOtherApp => '他のアプリだったら';

  @override
  String get clearComparisonReal => 'Hareruの実質支出';

  @override
  String clearComparisonSaved(String amount) {
    return 'Hareruが¥$amountの混乱を自動整理しました';
  }

  @override
  String get clearComparisonNoTransfer => 'この期間は振込がありません。すべての支出が実質支出です ✨';

  @override
  String get aiDiscoveriesTitle => '今週の主な発見';

  @override
  String aiDiscoveriesLastAnalysis(String date) {
    return '最終分析: $date';
  }

  @override
  String get aiSuggestionTitle => '来週の提案';

  @override
  String get aiSuggestionGoalButton => '目標を設定する';

  @override
  String get aiSuggestionProOnly => 'Clear Proで利用可能';

  @override
  String get aiSuggestionEmpty => '支出記録をもう少し集めると、カスタム分析をお届けします！📝';

  @override
  String get savingPotentialTitle => '隠れた節約可能額';

  @override
  String savingPotentialMonthly(String amount) {
    return '月 $amount';
  }

  @override
  String savingPotentialYearly(String amount) {
    return '年 $amount 節約可能！🎉';
  }

  @override
  String get savingPotentialDetail => '詳細を見る';

  @override
  String get healthScoreTitle => '支出健康度';

  @override
  String get healthScoreBudget => '予算遵守';

  @override
  String get healthScoreSaving => '節約努力';

  @override
  String get healthScoreBalance => '支出バランス';

  @override
  String get healthScoreClear => '振込整理';

  @override
  String get healthGradeExcellent => '素晴らしい 🌟';

  @override
  String get healthGradeGood => '良好 👍';

  @override
  String get healthGradeAverage => '普通 📊';

  @override
  String get healthGradeCaution => '注意 ⚠️';

  @override
  String get healthGradeDanger => '危険 🚨';

  @override
  String get blurMessageInsight => 'AIが分析したあなただけの\n支出レポートを確認しましょう';

  @override
  String get blurMessageSaving => '隠れた節約可能額を\n発見しましょう';

  @override
  String get blurMessageHealth => '私の支出健康スコアは\n何点でしょう？';

  @override
  String get blurCta => 'Clearを始める';

  @override
  String get blurPrice => '月額 ¥380';

  @override
  String get blurPremiumComingSoon => 'プレミアム機能は今後のアップデートで提供予定です！';

  @override
  String get blurFutureUpdate => '今後のアップデート予定';
}
