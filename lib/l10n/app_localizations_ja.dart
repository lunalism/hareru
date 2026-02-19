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
  String get realExpense => '本当の支出';

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

  @override
  String get editBudget => '予算変更';

  @override
  String get easySetup => 'かんたん初期設定';

  @override
  String get setupDescription => 'あなたに合わせた家計管理のために、\n2つだけ教えてください';

  @override
  String get payDay => '給料日';

  @override
  String payDayLabel(String day) {
    return '毎月 $day 日';
  }

  @override
  String get payDayEndOfMonth => '末日';

  @override
  String get setPayDay => '給料日を設定';

  @override
  String get getStarted => 'はじめる';

  @override
  String get setupLater => 'あとで設定する';

  @override
  String get everyMonth => '毎月';

  @override
  String get catUtility => '光熱費';

  @override
  String get categoryManagement => 'カテゴリ管理';

  @override
  String get addCategory => 'カテゴリを追加';

  @override
  String get editCategory => 'カテゴリを編集';

  @override
  String get deleteCategory => 'カテゴリを削除';

  @override
  String get categoryName => 'カテゴリ名';

  @override
  String get categoryEmoji => 'アイコン';

  @override
  String get cannotDeleteDefault => 'デフォルトカテゴリは削除できません';

  @override
  String deleteCategoryConfirm(int count) {
    return 'このカテゴリを削除すると、$count件の記録が「その他」に移動します';
  }

  @override
  String get add => '追加';

  @override
  String payDayEveryMonth(String day) {
    return '毎月$day日';
  }

  @override
  String get remaining => '残り';

  @override
  String get savingsRate => '貯蓄率';

  @override
  String get showAll => 'すべて表示';

  @override
  String get showLess => '閉じる';

  @override
  String get budgetNotSet => '予算を設定すると進捗が表示されます';

  @override
  String get notIncludedInReal => '本当の支出に含まれません';

  @override
  String get monthlyInsight => '今月のまとめ';

  @override
  String get noRecordsYet => 'まだ記録がありません';

  @override
  String get noRecordsDescription => '支出を記録するとレポートが表示されます';

  @override
  String get startRecording => '記録する';

  @override
  String savedComparedLastMonth(String amount) {
    return '先月より$amount節約できました！';
  }

  @override
  String spentMoreThanLastMonth(String amount) {
    return '先月より$amount多く使っています';
  }

  @override
  String topCategory(String category, String percent) {
    return '今月は$categoryが一番多く、全体の$percent%です';
  }

  @override
  String get withinBudget => '予算内でやりくりできています！';

  @override
  String overBudgetReport(String amount) {
    return '予算を$amount超えています';
  }

  @override
  String get needMoreData => '記録が増えると、AIがアドバイスをお届けします';

  @override
  String get appearance => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get notification => '通知';

  @override
  String get recordReminder => '記録リマインダー';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String get data => 'データ';

  @override
  String get backupData => 'データをバックアップ';

  @override
  String get restoreData => 'データを復元';

  @override
  String get resetData => 'データを初期化';

  @override
  String get restoreConfirm => '現在のデータは上書きされます。よろしいですか？';

  @override
  String get resetConfirm => 'すべてのデータが削除されます。この操作は元に戻せません。';

  @override
  String get resetDoubleConfirm => '本当に初期化しますか？「リセット」と入力してください';

  @override
  String get resetKeyword => 'リセット';

  @override
  String get reset => '初期化する';

  @override
  String get aboutApp => 'アプリについて';

  @override
  String get feedback => 'フィードバック';

  @override
  String get rateApp => 'アプリを評価する';

  @override
  String get rateAppLater => 'App Store公開後にご利用いただけます';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get version => 'バージョン';

  @override
  String get reminderTitle => '家計簿をつけましょう！';

  @override
  String get reminderBody => '今日の支出を記録して、賢くお金を管理しましょう';

  @override
  String get enableNotificationInSettings => '設定アプリから通知を許可してください';

  @override
  String get dictionary => '辞書';

  @override
  String get searchTerms => '用語を検索...';

  @override
  String get allCategories => '全て';

  @override
  String get householdBasics => '家計の基本';

  @override
  String get taxPension => '税金・年金';

  @override
  String get insurance => '保険';

  @override
  String get savingsInvestment => '貯蓄・投資';

  @override
  String get loanDebt => 'ローン・借入';

  @override
  String get japanSystem => '日本の制度';

  @override
  String get cashlessPayment => 'キャッシュレス・決済';

  @override
  String get explanation => '解説';

  @override
  String get example => 'たとえば';

  @override
  String get relatedTerms => '関連用語';

  @override
  String get askAi => 'AIにお金のことを聞く';

  @override
  String get askAiDescription => '「新NISAって何？」など何でも聞けます';

  @override
  String get learnMoreWithAi => 'この用語をもっと詳しく';

  @override
  String get learnMoreAiDescription => 'AIがあなたの家計に合わせて分かりやすく解説します';

  @override
  String get unlockWithClear => 'Clear プランで解放';

  @override
  String get premiumComingSoon => 'プレミアム機能は近日公開予定です';

  @override
  String get noTermsFound => '該当する用語が見つかりません';

  @override
  String get bankingDeposit => '銀行・預金';

  @override
  String get bankComparison => '積立預金 銀行比較';

  @override
  String get bankComparisonSub => '金利・条件をかんたん比較';

  @override
  String get viewComparison => '比較を見る';

  @override
  String get interestRate => '金利';

  @override
  String get minimumAmount => '最低金額';

  @override
  String get depositPeriod => '期間';

  @override
  String get feature => '特徴';

  @override
  String get recommendedFor => 'おすすめ';

  @override
  String get foreignerTipTitle => '外国人の方へ';

  @override
  String get foreignerTipBody =>
      '在留カードがあれば、ほとんどの銀行で口座開設できます。ゆうちょ銀行は窓口対応が丁寧で、外国人にも人気です。';

  @override
  String get koreaCompareTitle => '';

  @override
  String get koreaCompareBody => '';

  @override
  String get aiBankRecommend => 'あなたに合った銀行は？';

  @override
  String get aiBankQ1 => '「毎月いくら貯めたい？」';

  @override
  String get aiBankQ2 => '「いつまでに必要？」';

  @override
  String get aiBankQ3 => '「ネット銀行はOK？」';

  @override
  String get aiBankDescription => 'AIがあなたの条件に合った最適な銀行を提案します';

  @override
  String get rateDisclaimer => '金利は変動します。最新情報は各銀行の公式サイトをご確認ください。';

  @override
  String get asOf => '2026年2月時点の情報です';
}
