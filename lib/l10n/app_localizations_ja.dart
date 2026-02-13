// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingStart => '始めましょう！';

  @override
  String get onboarding1Title => '本当に使ったお金だけ\n表示します';

  @override
  String get onboarding1Desc => '口座間の振替は支出じゃない。\nHareruは「本当の支出」だけを見せます。';

  @override
  String get onboarding2Title => '振替は\n自動で仕分け';

  @override
  String get onboarding2Desc => '支出・振替・貯蓄を自動で分類。\nもう混乱しません。';

  @override
  String get onboarding3Title => '3秒で\n入力完了';

  @override
  String get onboarding3Desc => '金額 → カテゴリ1タップ → 終わり。\n世界一カンタンな家計簿。';

  @override
  String get otherApps => '他のアプリ';

  @override
  String get looksLikeExpense => '支出に見える 😰';

  @override
  String get realExpense => '本当の支出 ✨';

  @override
  String get food => '食費';

  @override
  String get transport => '交通費';

  @override
  String get transfer => '振替';

  @override
  String get transferAlert => '振込 ⚠️';

  @override
  String get savings => '貯金';

  @override
  String get savingsAlert => '貯蓄 ⚠️';

  @override
  String get expense => '支出';

  @override
  String get auto => '自動';

  @override
  String get conveniStore => 'コンビニ';

  @override
  String get amountInput => '金額入力';

  @override
  String get category => 'カテゴリ';

  @override
  String get done => '完了！';

  @override
  String get cafe => 'カフェ';

  @override
  String get transferExample => '→ 貯蓄口座 ¥30,000';

  @override
  String get savingsExample => '積立NISA ¥33,333';

  @override
  String get expenseExample => 'コンビニ ¥850';

  @override
  String get homeTab => 'ホーム';

  @override
  String get reportTab => 'レポート';

  @override
  String get dictionaryTab => '辞書';

  @override
  String get settingsTab => '設定';

  @override
  String monthFormat(int year, int month) {
    return '$year年$month月';
  }

  @override
  String get monthlyRealExpense => '今月の本当の支出';

  @override
  String get totalExpense => '総支出';

  @override
  String get totalIncome => '総収入';

  @override
  String get balance => '残高';

  @override
  String get budget => '予算';

  @override
  String budgetUsed(int percent) {
    return '予算の$percent%使用';
  }

  @override
  String budgetRemaining(String amount) {
    return '残り ¥$amount';
  }

  @override
  String get recentRecords => '最近の記録';

  @override
  String get seeAll => 'すべて見る';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get aiInsightTitle => 'AIインサイト';

  @override
  String get aiInsightMessage => '先月より食費が12%減りました！この調子で続けましょう。';

  @override
  String get emptyStateTitle => 'まだ記録がありません';

  @override
  String get emptyStateDesc => '下の＋ボタンで\n最初の記録を追加しましょう';

  @override
  String get guideExpenseTitle => '支出を記録';

  @override
  String get guideExpenseDesc => '日々の支出を簡単に記録';

  @override
  String get guideBudgetTitle => '予算を設定';

  @override
  String get guideBudgetDesc => '月ごとの予算を設定して管理';

  @override
  String get guideCategoryTitle => 'カテゴリ管理';

  @override
  String get guideCategoryDesc => 'あなた好みにカスタマイズ';

  @override
  String get preparingFeature => '準備中';

  @override
  String get settingsTitle => '設定';

  @override
  String get languageTitle => '言語';

  @override
  String get catFood => '食費';

  @override
  String get catTransport => '交通費';

  @override
  String get catDaily => '日用品';

  @override
  String get catCafe => 'カフェ';

  @override
  String get catHobby => '趣味';

  @override
  String get catClothing => '衣服';

  @override
  String get catMedical => '医療';

  @override
  String get catPhone => '通信費';

  @override
  String get catHousing => '住居費';

  @override
  String get catSocial => '交際費';

  @override
  String get catEducation => '教育';

  @override
  String get catOther => 'その他';

  @override
  String get catBankTransfer => '銀行振込';

  @override
  String get catCard => 'カード払い';

  @override
  String get catEMoney => '電子マネー';

  @override
  String get catTransferOther => 'その他振替';

  @override
  String get catSavings => '定期貯金';

  @override
  String get catInvestment => '投資';

  @override
  String get catGoal => '目標貯金';

  @override
  String get catSavingsOther => 'その他貯蓄';

  @override
  String get memoPlaceholder => 'メモを入力（任意）';

  @override
  String get saveRecord => '記録する';

  @override
  String get recordSaved => '記録しました！';

  @override
  String get inputAmount => '金額を入力';

  @override
  String get income => '収入';

  @override
  String get salary => '給料';

  @override
  String get sideJob => '副業';

  @override
  String get bonus => 'ボーナス';

  @override
  String get allowance => 'お小遣い';

  @override
  String get investmentReturn => '投資収益';

  @override
  String get fleaMarket => 'フリマ';

  @override
  String get extraIncome => '臨時収入';

  @override
  String get otherIncome => 'その他';

  @override
  String get setBudget => '予算を設定する';

  @override
  String get monthlyBudget => '月の予算';

  @override
  String get setBudgetTitle => '月の予算を設定';

  @override
  String remainingBudget(String amount) {
    return 'あと $amount 使えます';
  }

  @override
  String overBudget(String amount) {
    return '$amount オーバーしています';
  }

  @override
  String get budgetSettings => '予算設定';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';
}
