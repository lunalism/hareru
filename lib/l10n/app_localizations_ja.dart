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
  String get savingsAlert => '貯金 ⚠️';

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
  String get emptyStateDesc => '下の＋ボタンで\n最初の記録をつけてみましょう';

  @override
  String get guideExpenseTitle => '支出を記録';

  @override
  String get guideExpenseDesc => '日々の支出を簡単に記録';

  @override
  String get guideBudgetTitle => '予算を設定';

  @override
  String get guideBudgetDesc => '月の予算を設定して管理';

  @override
  String get guideBudgetEditTitle => '予算を変更';

  @override
  String guideBudgetEditDesc(String amount) {
    return '現在 ¥$amount に設定中';
  }

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
  String get catSavingsOther => 'その他貯金';

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
  String get needMoreData => '記録が増えると、AIがアドバイスしてくれます';

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
  String get backupWarning => 'バックアップファイルには取引履歴・予算・設定が含まれます。安全な場所に保管してください。';

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
  String get insurance => '保険';

  @override
  String get example => 'たとえば';

  @override
  String get unlockWithClear => 'Clear プランで解放';

  @override
  String get unlockWithClearPro => 'ClearPro プランで解放';

  @override
  String get premiumComingSoon => 'プレミアム機能は近日公開予定です';

  @override
  String get noTermsFound => '該当する用語が見つかりません';

  @override
  String get interestRate => '金利';

  @override
  String get recommendedFor => 'おすすめ';

  @override
  String get allRecords => 'すべての記録';

  @override
  String get recordDetail => '記録の詳細';

  @override
  String get transactionType => 'タイプ';

  @override
  String get transactionAmount => '金額';

  @override
  String get transactionDateTime => '日時';

  @override
  String get transactionMemo => 'メモ';

  @override
  String get noMemo => 'メモなし';

  @override
  String get editRecord => '編集する';

  @override
  String get deleteRecord => '削除する';

  @override
  String get updateRecord => '更新する';

  @override
  String get deleteConfirm => 'この記録を削除しますか？';

  @override
  String get deleteConfirmSub => 'この操作は元に戻せません。';

  @override
  String get recordDeleted => '記録を削除しました';

  @override
  String get recordUpdated => '記録を更新しました';

  @override
  String get undoAction => '元に戻す';

  @override
  String get noRecordsEmpty => '記録がありません';

  @override
  String get listView => 'リスト';

  @override
  String get calendarView => 'カレンダー';

  @override
  String get dailyTotal => '合計';

  @override
  String get noRecordsForDay => 'この日の記録はありません';

  @override
  String get pdfReportTitle => '月間PDFレポート';

  @override
  String get pdfReportDescription => '今月の家計簿をPDFで共有しましょう';

  @override
  String get pdfShareButton => 'PDFレポートを共有';

  @override
  String get pdfGenerating => 'PDF作成中...';

  @override
  String get pdfMonthlyReport => '月間レポート';

  @override
  String get pdfApparentExpense => '見かけの支出';

  @override
  String get pdfDifference => '差額';

  @override
  String pdfTransactionCount(int count) {
    return '$count件';
  }

  @override
  String pdfAndMore(int count) {
    return '他 $count件';
  }

  @override
  String pdfGeneratedOn(String date) {
    return '作成日: $date';
  }

  @override
  String pdfBudgetUsage(String budget, String used, String percent) {
    return '予算 $budget 中 $used 使用 ($percent%)';
  }

  @override
  String pdfBudgetPaceGood(String percent) {
    return '予算の$percent%を使用しており、良いペースです';
  }

  @override
  String pdfBudgetPaceOver(String amount) {
    return '予算を$amount超過しています。支出を見直しましょう';
  }

  @override
  String pdfAdviceTopCategory(String category) {
    return '来月も$categoryの見直しを検討してみましょう';
  }

  @override
  String get pdfAdviceGeneral => 'コツコツ記録することが節約への第一歩です';

  @override
  String get pdfBrandFooter => 'Hareru - スマート家計簿';

  @override
  String get addExpense => '支出を記録';

  @override
  String get addIncome => '収入を記録';

  @override
  String get addTransfer => '振替を記録';

  @override
  String get editExpense => '支出を編集';

  @override
  String get editIncome => '収入を編集';

  @override
  String get editTransfer => '振替を編集';

  @override
  String get transferFrom => '出金元';

  @override
  String get transferTo => '入金先';

  @override
  String get addAccountTitle => '口座を追加';

  @override
  String get addAccountStep1 => 'アイコン';

  @override
  String get addAccountStep2 => '口座の名前';

  @override
  String get addAccountHint => '例: UFJ 生活費, 楽天 貯金用';

  @override
  String deleteAccountConfirm(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get incomeDepositTo => '入金先';

  @override
  String get addAccountPrompt => '口座を追加してください';

  @override
  String get paymentMethod => '決済方法';

  @override
  String get creditCard => 'クレジット';

  @override
  String get debitCard => 'デビット';

  @override
  String get cash => '現金';

  @override
  String get monthlyRecurring => '毎月繰り返し';

  @override
  String get amountHint => '金額を入力';

  @override
  String get support => 'サポート';

  @override
  String get faq => 'よくある質問';

  @override
  String get contactUs => 'お問い合わせ';

  @override
  String get contactSubject => '[Hareru] お問い合わせ';

  @override
  String contactBody(
    String version,
    String osVersion,
    String device,
    String locale,
  ) {
    return '【お問い合わせ内容】\n\n\n---\nアプリバージョン: $version\niOS: $osVersion\n端末: $device\n言語: $locale';
  }

  @override
  String get contactFallback => 'メールアプリが見つかりません。アドレスをコピーしてご利用ください。';

  @override
  String get noInternet => 'インターネットに接続してください';

  @override
  String get contactDesc => 'ご質問やフィードバックはメールでお送りください';

  @override
  String get contactCopy => 'コピー';

  @override
  String get contactOpenMail => 'メールを開く';

  @override
  String get contactCopied => 'コピーしました';

  @override
  String get otherSection => 'その他';

  @override
  String get lastUpdatedDate => '最終更新日: 2026年2月28日';

  @override
  String get appCatchphrase => 'もやもやした家計を、\nすっきり晴れやかに。';

  @override
  String get copied => 'コピーしました';

  @override
  String get copyright => '© 2026 Lunalism';

  @override
  String get accountSection => 'アカウント';

  @override
  String get login => 'ログイン';

  @override
  String get loginDescription => 'ログインすると、以下の機能がご利用いただけます:';

  @override
  String get loginBenefitBank => '最新の銀行金利比較';

  @override
  String get loginBenefitAI => 'AIインサイト（有料）';

  @override
  String get loginBenefitBackup => 'データのクラウドバックアップ';

  @override
  String get signInWithApple => 'Appleでサインイン';

  @override
  String get skipLogin => 'スキップして続ける';

  @override
  String get loginSuccess => 'ログイン完了';

  @override
  String get loginError => 'ログインに失敗しました';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirm => 'ログアウトしますか？';

  @override
  String get bankLoadError => 'データの読み込みに失敗しました';

  @override
  String get bankRetry => '再試行';

  @override
  String get dictionaryTitle => '金融辞書';

  @override
  String get searchPlaceholder => '用語を検索...';

  @override
  String get categoryAll => '全て';

  @override
  String get categoryBanking => '銀行';

  @override
  String get categoryHousehold => '家計';

  @override
  String get categoryTax => '税金';

  @override
  String get categoryInsurance => '保険';

  @override
  String get categorySavings => '貯蓄';

  @override
  String get categoryLoan => 'ローン';

  @override
  String get categorySystem => '制度';

  @override
  String get categoryPayment => '決済';

  @override
  String get sectionExplanation => '解説';

  @override
  String get sectionExample => 'たとえば';

  @override
  String get sectionRelated => '関連用語';

  @override
  String get aiAskAboutMoney => 'AIにお金のことを聞いてみよう';

  @override
  String get aiPersonalizedAdvice => 'あなたの家計に合わせたアドバイス';

  @override
  String get aiLearnMore => 'もっと詳しく知りたい？';

  @override
  String get aiExplainForYou => 'AIがあなたの家計に合わせて解説';

  @override
  String get webviewLoadError => 'ページを読み込めませんでした';

  @override
  String get retry => '再試行';

  @override
  String get pdfOverBudget => '超過';

  @override
  String get shareReportSubject => 'Hareru レポート';

  @override
  String get pdfError => 'エラー';

  @override
  String get notificationChannelName => '毎日リマインダー';

  @override
  String get notificationChannelDesc => '毎日の支出記録リマインダー';

  @override
  String get paywallTitle => 'Hareruをもっと便利に';

  @override
  String get paywallMonthly => '月額';

  @override
  String get paywallYearly => '年額';

  @override
  String get paywallYearlyBadge => 'おすすめ';

  @override
  String get paywallSaveMonths => '2ヶ月分お得！';

  @override
  String get paywallClearTitle => 'Clear';

  @override
  String get paywallClearProTitle => 'ClearPro';

  @override
  String get paywallClearCta => 'Clearを始める';

  @override
  String get paywallClearProCta => 'ClearProを始める';

  @override
  String get paywallRestore => '購入を復元する';

  @override
  String get paywallContinueFree => '無料プランを続ける';

  @override
  String get paywallTerms => '利用規約';

  @override
  String get paywallPrivacy => 'プライバシーポリシー';

  @override
  String get featureNoAds => '広告なし';

  @override
  String get featureAiInsight => 'AI分析';

  @override
  String get featureSavingSim => '節約シミュレーション';

  @override
  String get featureCsvExport => 'CSV出力';

  @override
  String get featureAiCoaching => 'AIコーチング';

  @override
  String get featurePdfReport => 'PDF月次レポート';

  @override
  String get featureSavingGoal => '貯蓄目標管理';

  @override
  String get featurePrioritySupport => '優先サポート';

  @override
  String get settingsSubscription => 'サブスクリプション';

  @override
  String get settingsCurrentPlan => '現在のプラン';

  @override
  String get settingsRestorePurchase => '購入を復元';

  @override
  String get settingsManageSubscription => 'サブスクリプション管理';

  @override
  String get lockClearRequired => 'Clearで利用可能';

  @override
  String get lockClearProRequired => 'ClearProで利用可能';

  @override
  String get lockUpgrade => 'アップグレード';

  @override
  String get purchaseSuccess => '購入が完了しました！';

  @override
  String get purchaseRestored => '購入を復元しました';

  @override
  String get purchaseError => '購入に失敗しました';

  @override
  String get purchaseNotAvailable => '現在購入できません';

  @override
  String get purchaseNotAvailableDesc => '現在、アプリ内購入をご利用いただけません。後ほどお試しください。';

  @override
  String get restoreNoPurchase => '復元できる購入がありません';

  @override
  String subscriptionExpiresOn(String date) {
    return '有効期限: $date';
  }

  @override
  String get planFree => 'Free';

  @override
  String get planClear => 'Clear';

  @override
  String get planClearPro => 'ClearPro';

  @override
  String get todaysTerm => '今日の用語';

  @override
  String get bookmarkAdd => 'ブックマークに追加しました';

  @override
  String get bookmarkRemove => 'ブックマークから削除しました';

  @override
  String get reviewTab => '復習';

  @override
  String learningProgress(int viewed, int total) {
    return '$viewed/$total 用語を学習済み';
  }

  @override
  String get allTermsMastered => 'すべての用語を学習しました！';

  @override
  String get difficultyBasic => '基礎';

  @override
  String get difficultyIntermediate => '中級';

  @override
  String get difficultyAdvanced => '応用';

  @override
  String get noBookmarks => 'まだブックマークがありません';

  @override
  String get welcomeTitle => 'Hareruへようこそ';

  @override
  String get welcomeSubtitle => '振替・貯金を自動で分けて\n本当の支出だけを見える化';

  @override
  String get continueAsGuest => 'アカウントなしで始める';

  @override
  String get loginBackupHint => 'ログインするとデータが安全にクラウドへバックアップされます';
}
