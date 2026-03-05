import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ja'),
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @onboardingSkip.
  ///
  /// In ja, this message translates to:
  /// **'スキップ'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In ja, this message translates to:
  /// **'次へ'**
  String get onboardingNext;

  /// No description provided for @onboarding1Title.
  ///
  /// In ja, this message translates to:
  /// **'本当に使ったお金だけ\n表示します'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In ja, this message translates to:
  /// **'口座間の振替は支出じゃない。\nHareruは「本当の支出」だけを見せます。'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In ja, this message translates to:
  /// **'振替は\n自動で仕分け'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In ja, this message translates to:
  /// **'支出・振替・貯蓄を自動で分類。\nもう混乱しません。'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In ja, this message translates to:
  /// **'3秒で\n入力完了'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In ja, this message translates to:
  /// **'金額 → カテゴリ1タップ → 終わり。\n世界一カンタンな家計簿。'**
  String get onboarding3Desc;

  /// No description provided for @otherApps.
  ///
  /// In ja, this message translates to:
  /// **'他のアプリ'**
  String get otherApps;

  /// No description provided for @looksLikeExpense.
  ///
  /// In ja, this message translates to:
  /// **'支出に見える 😰'**
  String get looksLikeExpense;

  /// No description provided for @realExpense.
  ///
  /// In ja, this message translates to:
  /// **'本当の支出'**
  String get realExpense;

  /// No description provided for @food.
  ///
  /// In ja, this message translates to:
  /// **'食費'**
  String get food;

  /// No description provided for @transport.
  ///
  /// In ja, this message translates to:
  /// **'交通費'**
  String get transport;

  /// No description provided for @transfer.
  ///
  /// In ja, this message translates to:
  /// **'振替'**
  String get transfer;

  /// No description provided for @transferAlert.
  ///
  /// In ja, this message translates to:
  /// **'振込 ⚠️'**
  String get transferAlert;

  /// No description provided for @savings.
  ///
  /// In ja, this message translates to:
  /// **'貯金'**
  String get savings;

  /// No description provided for @savingsAlert.
  ///
  /// In ja, this message translates to:
  /// **'貯金 ⚠️'**
  String get savingsAlert;

  /// No description provided for @expense.
  ///
  /// In ja, this message translates to:
  /// **'支出'**
  String get expense;

  /// No description provided for @auto.
  ///
  /// In ja, this message translates to:
  /// **'自動'**
  String get auto;

  /// No description provided for @conveniStore.
  ///
  /// In ja, this message translates to:
  /// **'コンビニ'**
  String get conveniStore;

  /// No description provided for @amountInput.
  ///
  /// In ja, this message translates to:
  /// **'金額入力'**
  String get amountInput;

  /// No description provided for @category.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ'**
  String get category;

  /// No description provided for @done.
  ///
  /// In ja, this message translates to:
  /// **'完了！'**
  String get done;

  /// No description provided for @cafe.
  ///
  /// In ja, this message translates to:
  /// **'カフェ'**
  String get cafe;

  /// No description provided for @transferExample.
  ///
  /// In ja, this message translates to:
  /// **'→ 貯蓄口座 ¥30,000'**
  String get transferExample;

  /// No description provided for @savingsExample.
  ///
  /// In ja, this message translates to:
  /// **'積立NISA ¥33,333'**
  String get savingsExample;

  /// No description provided for @expenseExample.
  ///
  /// In ja, this message translates to:
  /// **'コンビニ ¥850'**
  String get expenseExample;

  /// No description provided for @homeTab.
  ///
  /// In ja, this message translates to:
  /// **'ホーム'**
  String get homeTab;

  /// No description provided for @reportTab.
  ///
  /// In ja, this message translates to:
  /// **'レポート'**
  String get reportTab;

  /// No description provided for @dictionaryTab.
  ///
  /// In ja, this message translates to:
  /// **'辞書'**
  String get dictionaryTab;

  /// No description provided for @settingsTab.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTab;

  /// No description provided for @monthFormat.
  ///
  /// In ja, this message translates to:
  /// **'{year}年{month}月'**
  String monthFormat(int year, int month);

  /// No description provided for @monthlyRealExpense.
  ///
  /// In ja, this message translates to:
  /// **'今月の本当の支出'**
  String get monthlyRealExpense;

  /// No description provided for @totalExpense.
  ///
  /// In ja, this message translates to:
  /// **'総支出'**
  String get totalExpense;

  /// No description provided for @totalIncome.
  ///
  /// In ja, this message translates to:
  /// **'総収入'**
  String get totalIncome;

  /// No description provided for @balance.
  ///
  /// In ja, this message translates to:
  /// **'残高'**
  String get balance;

  /// No description provided for @budget.
  ///
  /// In ja, this message translates to:
  /// **'予算'**
  String get budget;

  /// No description provided for @budgetUsed.
  ///
  /// In ja, this message translates to:
  /// **'予算の{percent}%使用'**
  String budgetUsed(int percent);

  /// No description provided for @budgetRemaining.
  ///
  /// In ja, this message translates to:
  /// **'残り ¥{amount}'**
  String budgetRemaining(String amount);

  /// No description provided for @recentRecords.
  ///
  /// In ja, this message translates to:
  /// **'最近の記録'**
  String get recentRecords;

  /// No description provided for @seeAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて見る'**
  String get seeAll;

  /// No description provided for @today.
  ///
  /// In ja, this message translates to:
  /// **'今日'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日'**
  String get yesterday;

  /// No description provided for @aiInsightTitle.
  ///
  /// In ja, this message translates to:
  /// **'AIインサイト'**
  String get aiInsightTitle;

  /// No description provided for @aiInsightMessage.
  ///
  /// In ja, this message translates to:
  /// **'先月より食費が12%減りました！この調子で続けましょう。'**
  String get aiInsightMessage;

  /// No description provided for @emptyStateTitle.
  ///
  /// In ja, this message translates to:
  /// **'まだ記録がありません'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateDesc.
  ///
  /// In ja, this message translates to:
  /// **'下の＋ボタンで\n最初の記録をつけてみましょう'**
  String get emptyStateDesc;

  /// No description provided for @guideExpenseTitle.
  ///
  /// In ja, this message translates to:
  /// **'支出を記録'**
  String get guideExpenseTitle;

  /// No description provided for @guideExpenseDesc.
  ///
  /// In ja, this message translates to:
  /// **'日々の支出を簡単に記録'**
  String get guideExpenseDesc;

  /// No description provided for @guideBudgetTitle.
  ///
  /// In ja, this message translates to:
  /// **'予算を設定'**
  String get guideBudgetTitle;

  /// No description provided for @guideBudgetDesc.
  ///
  /// In ja, this message translates to:
  /// **'月の予算を設定して管理'**
  String get guideBudgetDesc;

  /// No description provided for @guideBudgetEditTitle.
  ///
  /// In ja, this message translates to:
  /// **'予算を変更'**
  String get guideBudgetEditTitle;

  /// No description provided for @guideBudgetEditDesc.
  ///
  /// In ja, this message translates to:
  /// **'現在 ¥{amount} に設定中'**
  String guideBudgetEditDesc(String amount);

  /// No description provided for @guideCategoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ管理'**
  String get guideCategoryTitle;

  /// No description provided for @guideCategoryDesc.
  ///
  /// In ja, this message translates to:
  /// **'あなた好みにカスタマイズ'**
  String get guideCategoryDesc;

  /// No description provided for @preparingFeature.
  ///
  /// In ja, this message translates to:
  /// **'準備中'**
  String get preparingFeature;

  /// No description provided for @settingsTitle.
  ///
  /// In ja, this message translates to:
  /// **'設定'**
  String get settingsTitle;

  /// No description provided for @languageTitle.
  ///
  /// In ja, this message translates to:
  /// **'言語'**
  String get languageTitle;

  /// No description provided for @catFood.
  ///
  /// In ja, this message translates to:
  /// **'食費'**
  String get catFood;

  /// No description provided for @catTransport.
  ///
  /// In ja, this message translates to:
  /// **'交通費'**
  String get catTransport;

  /// No description provided for @catDaily.
  ///
  /// In ja, this message translates to:
  /// **'日用品'**
  String get catDaily;

  /// No description provided for @catCafe.
  ///
  /// In ja, this message translates to:
  /// **'カフェ'**
  String get catCafe;

  /// No description provided for @catHobby.
  ///
  /// In ja, this message translates to:
  /// **'趣味'**
  String get catHobby;

  /// No description provided for @catClothing.
  ///
  /// In ja, this message translates to:
  /// **'衣服'**
  String get catClothing;

  /// No description provided for @catMedical.
  ///
  /// In ja, this message translates to:
  /// **'医療'**
  String get catMedical;

  /// No description provided for @catPhone.
  ///
  /// In ja, this message translates to:
  /// **'通信費'**
  String get catPhone;

  /// No description provided for @catHousing.
  ///
  /// In ja, this message translates to:
  /// **'住居費'**
  String get catHousing;

  /// No description provided for @catSocial.
  ///
  /// In ja, this message translates to:
  /// **'交際費'**
  String get catSocial;

  /// No description provided for @catEducation.
  ///
  /// In ja, this message translates to:
  /// **'教育'**
  String get catEducation;

  /// No description provided for @catOther.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get catOther;

  /// No description provided for @catBankTransfer.
  ///
  /// In ja, this message translates to:
  /// **'銀行振込'**
  String get catBankTransfer;

  /// No description provided for @catCard.
  ///
  /// In ja, this message translates to:
  /// **'カード払い'**
  String get catCard;

  /// No description provided for @catEMoney.
  ///
  /// In ja, this message translates to:
  /// **'電子マネー'**
  String get catEMoney;

  /// No description provided for @catTransferOther.
  ///
  /// In ja, this message translates to:
  /// **'その他振替'**
  String get catTransferOther;

  /// No description provided for @catSavings.
  ///
  /// In ja, this message translates to:
  /// **'定期貯金'**
  String get catSavings;

  /// No description provided for @catInvestment.
  ///
  /// In ja, this message translates to:
  /// **'投資'**
  String get catInvestment;

  /// No description provided for @catGoal.
  ///
  /// In ja, this message translates to:
  /// **'目標貯金'**
  String get catGoal;

  /// No description provided for @catSavingsOther.
  ///
  /// In ja, this message translates to:
  /// **'その他貯金'**
  String get catSavingsOther;

  /// No description provided for @memoPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'メモを入力（任意）'**
  String get memoPlaceholder;

  /// No description provided for @saveRecord.
  ///
  /// In ja, this message translates to:
  /// **'記録する'**
  String get saveRecord;

  /// No description provided for @recordSaved.
  ///
  /// In ja, this message translates to:
  /// **'記録しました！'**
  String get recordSaved;

  /// No description provided for @inputAmount.
  ///
  /// In ja, this message translates to:
  /// **'金額を入力'**
  String get inputAmount;

  /// No description provided for @income.
  ///
  /// In ja, this message translates to:
  /// **'収入'**
  String get income;

  /// No description provided for @salary.
  ///
  /// In ja, this message translates to:
  /// **'給料'**
  String get salary;

  /// No description provided for @sideJob.
  ///
  /// In ja, this message translates to:
  /// **'副業'**
  String get sideJob;

  /// No description provided for @bonus.
  ///
  /// In ja, this message translates to:
  /// **'ボーナス'**
  String get bonus;

  /// No description provided for @allowance.
  ///
  /// In ja, this message translates to:
  /// **'お小遣い'**
  String get allowance;

  /// No description provided for @investmentReturn.
  ///
  /// In ja, this message translates to:
  /// **'投資収益'**
  String get investmentReturn;

  /// No description provided for @fleaMarket.
  ///
  /// In ja, this message translates to:
  /// **'フリマ'**
  String get fleaMarket;

  /// No description provided for @extraIncome.
  ///
  /// In ja, this message translates to:
  /// **'臨時収入'**
  String get extraIncome;

  /// No description provided for @otherIncome.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get otherIncome;

  /// No description provided for @setBudget.
  ///
  /// In ja, this message translates to:
  /// **'予算を設定する'**
  String get setBudget;

  /// No description provided for @monthlyBudget.
  ///
  /// In ja, this message translates to:
  /// **'月の予算'**
  String get monthlyBudget;

  /// No description provided for @setBudgetTitle.
  ///
  /// In ja, this message translates to:
  /// **'月の予算を設定'**
  String get setBudgetTitle;

  /// No description provided for @remainingBudget.
  ///
  /// In ja, this message translates to:
  /// **'あと {amount} 使えます'**
  String remainingBudget(String amount);

  /// No description provided for @overBudget.
  ///
  /// In ja, this message translates to:
  /// **'{amount} オーバーしています'**
  String overBudget(String amount);

  /// No description provided for @budgetSettings.
  ///
  /// In ja, this message translates to:
  /// **'予算設定'**
  String get budgetSettings;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @editBudget.
  ///
  /// In ja, this message translates to:
  /// **'予算変更'**
  String get editBudget;

  /// No description provided for @easySetup.
  ///
  /// In ja, this message translates to:
  /// **'かんたん初期設定'**
  String get easySetup;

  /// No description provided for @setupDescription.
  ///
  /// In ja, this message translates to:
  /// **'あなたに合わせた家計管理のために、\n2つだけ教えてください'**
  String get setupDescription;

  /// No description provided for @payDay.
  ///
  /// In ja, this message translates to:
  /// **'給料日'**
  String get payDay;

  /// No description provided for @payDayLabel.
  ///
  /// In ja, this message translates to:
  /// **'毎月 {day} 日'**
  String payDayLabel(String day);

  /// No description provided for @payDayEndOfMonth.
  ///
  /// In ja, this message translates to:
  /// **'末日'**
  String get payDayEndOfMonth;

  /// No description provided for @setPayDay.
  ///
  /// In ja, this message translates to:
  /// **'給料日を設定'**
  String get setPayDay;

  /// No description provided for @getStarted.
  ///
  /// In ja, this message translates to:
  /// **'はじめる'**
  String get getStarted;

  /// No description provided for @setupLater.
  ///
  /// In ja, this message translates to:
  /// **'あとで設定する'**
  String get setupLater;

  /// No description provided for @everyMonth.
  ///
  /// In ja, this message translates to:
  /// **'毎月'**
  String get everyMonth;

  /// No description provided for @catUtility.
  ///
  /// In ja, this message translates to:
  /// **'光熱費'**
  String get catUtility;

  /// No description provided for @categoryManagement.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ管理'**
  String get categoryManagement;

  /// No description provided for @addCategory.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリを追加'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリを編集'**
  String get editCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリを削除'**
  String get deleteCategory;

  /// No description provided for @categoryName.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリ名'**
  String get categoryName;

  /// No description provided for @categoryEmoji.
  ///
  /// In ja, this message translates to:
  /// **'アイコン'**
  String get categoryEmoji;

  /// No description provided for @cannotDeleteDefault.
  ///
  /// In ja, this message translates to:
  /// **'デフォルトカテゴリは削除できません'**
  String get cannotDeleteDefault;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In ja, this message translates to:
  /// **'このカテゴリを削除すると、{count}件の記録が「その他」に移動します'**
  String deleteCategoryConfirm(int count);

  /// No description provided for @add.
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get add;

  /// No description provided for @payDayEveryMonth.
  ///
  /// In ja, this message translates to:
  /// **'毎月{day}日'**
  String payDayEveryMonth(String day);

  /// No description provided for @remaining.
  ///
  /// In ja, this message translates to:
  /// **'残り'**
  String get remaining;

  /// No description provided for @savingsRate.
  ///
  /// In ja, this message translates to:
  /// **'貯蓄率'**
  String get savingsRate;

  /// No description provided for @showAll.
  ///
  /// In ja, this message translates to:
  /// **'すべて表示'**
  String get showAll;

  /// No description provided for @showLess.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get showLess;

  /// No description provided for @budgetNotSet.
  ///
  /// In ja, this message translates to:
  /// **'予算を設定すると進捗が表示されます'**
  String get budgetNotSet;

  /// No description provided for @notIncludedInReal.
  ///
  /// In ja, this message translates to:
  /// **'本当の支出に含まれません'**
  String get notIncludedInReal;

  /// No description provided for @monthlyInsight.
  ///
  /// In ja, this message translates to:
  /// **'今月のまとめ'**
  String get monthlyInsight;

  /// No description provided for @noRecordsYet.
  ///
  /// In ja, this message translates to:
  /// **'まだ記録がありません'**
  String get noRecordsYet;

  /// No description provided for @noRecordsDescription.
  ///
  /// In ja, this message translates to:
  /// **'支出を記録するとレポートが表示されます'**
  String get noRecordsDescription;

  /// No description provided for @startRecording.
  ///
  /// In ja, this message translates to:
  /// **'記録する'**
  String get startRecording;

  /// No description provided for @savedComparedLastMonth.
  ///
  /// In ja, this message translates to:
  /// **'先月より{amount}節約できました！'**
  String savedComparedLastMonth(String amount);

  /// No description provided for @spentMoreThanLastMonth.
  ///
  /// In ja, this message translates to:
  /// **'先月より{amount}多く使っています'**
  String spentMoreThanLastMonth(String amount);

  /// No description provided for @topCategory.
  ///
  /// In ja, this message translates to:
  /// **'今月は{category}が一番多く、全体の{percent}%です'**
  String topCategory(String category, String percent);

  /// No description provided for @withinBudget.
  ///
  /// In ja, this message translates to:
  /// **'予算内でやりくりできています！'**
  String get withinBudget;

  /// No description provided for @overBudgetReport.
  ///
  /// In ja, this message translates to:
  /// **'予算を{amount}超えています'**
  String overBudgetReport(String amount);

  /// No description provided for @needMoreData.
  ///
  /// In ja, this message translates to:
  /// **'記録が増えると、AIがアドバイスしてくれます'**
  String get needMoreData;

  /// No description provided for @appearance.
  ///
  /// In ja, this message translates to:
  /// **'外観'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In ja, this message translates to:
  /// **'ダークモード'**
  String get darkMode;

  /// No description provided for @notification.
  ///
  /// In ja, this message translates to:
  /// **'通知'**
  String get notification;

  /// No description provided for @recordReminder.
  ///
  /// In ja, this message translates to:
  /// **'記録リマインダー'**
  String get recordReminder;

  /// No description provided for @reminderTime.
  ///
  /// In ja, this message translates to:
  /// **'リマインダー時間'**
  String get reminderTime;

  /// No description provided for @data.
  ///
  /// In ja, this message translates to:
  /// **'データ'**
  String get data;

  /// No description provided for @backupData.
  ///
  /// In ja, this message translates to:
  /// **'データをバックアップ'**
  String get backupData;

  /// No description provided for @restoreData.
  ///
  /// In ja, this message translates to:
  /// **'データを復元'**
  String get restoreData;

  /// No description provided for @resetData.
  ///
  /// In ja, this message translates to:
  /// **'データを初期化'**
  String get resetData;

  /// No description provided for @restoreConfirm.
  ///
  /// In ja, this message translates to:
  /// **'現在のデータは上書きされます。よろしいですか？'**
  String get restoreConfirm;

  /// No description provided for @resetConfirm.
  ///
  /// In ja, this message translates to:
  /// **'すべてのデータが削除されます。この操作は元に戻せません。'**
  String get resetConfirm;

  /// No description provided for @resetDoubleConfirm.
  ///
  /// In ja, this message translates to:
  /// **'本当に初期化しますか？「リセット」と入力してください'**
  String get resetDoubleConfirm;

  /// No description provided for @resetKeyword.
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get resetKeyword;

  /// No description provided for @reset.
  ///
  /// In ja, this message translates to:
  /// **'初期化する'**
  String get reset;

  /// No description provided for @aboutApp.
  ///
  /// In ja, this message translates to:
  /// **'アプリについて'**
  String get aboutApp;

  /// No description provided for @feedback.
  ///
  /// In ja, this message translates to:
  /// **'フィードバック'**
  String get feedback;

  /// No description provided for @rateApp.
  ///
  /// In ja, this message translates to:
  /// **'アプリを評価する'**
  String get rateApp;

  /// No description provided for @rateAppLater.
  ///
  /// In ja, this message translates to:
  /// **'App Store公開後にご利用いただけます'**
  String get rateAppLater;

  /// No description provided for @termsOfService.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In ja, this message translates to:
  /// **'バージョン'**
  String get version;

  /// No description provided for @reminderTitle.
  ///
  /// In ja, this message translates to:
  /// **'家計簿をつけましょう！'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In ja, this message translates to:
  /// **'今日の支出を記録して、賢くお金を管理しましょう'**
  String get reminderBody;

  /// No description provided for @enableNotificationInSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定アプリから通知を許可してください'**
  String get enableNotificationInSettings;

  /// No description provided for @insurance.
  ///
  /// In ja, this message translates to:
  /// **'保険'**
  String get insurance;

  /// No description provided for @example.
  ///
  /// In ja, this message translates to:
  /// **'たとえば'**
  String get example;

  /// No description provided for @unlockWithClear.
  ///
  /// In ja, this message translates to:
  /// **'Clear プランで解放'**
  String get unlockWithClear;

  /// No description provided for @unlockWithClearPro.
  ///
  /// In ja, this message translates to:
  /// **'ClearPro プランで解放'**
  String get unlockWithClearPro;

  /// No description provided for @premiumComingSoon.
  ///
  /// In ja, this message translates to:
  /// **'プレミアム機能は近日公開予定です'**
  String get premiumComingSoon;

  /// No description provided for @noTermsFound.
  ///
  /// In ja, this message translates to:
  /// **'該当する用語が見つかりません'**
  String get noTermsFound;

  /// No description provided for @interestRate.
  ///
  /// In ja, this message translates to:
  /// **'金利'**
  String get interestRate;

  /// No description provided for @recommendedFor.
  ///
  /// In ja, this message translates to:
  /// **'おすすめ'**
  String get recommendedFor;

  /// No description provided for @allRecords.
  ///
  /// In ja, this message translates to:
  /// **'すべての記録'**
  String get allRecords;

  /// No description provided for @recordDetail.
  ///
  /// In ja, this message translates to:
  /// **'記録の詳細'**
  String get recordDetail;

  /// No description provided for @transactionType.
  ///
  /// In ja, this message translates to:
  /// **'タイプ'**
  String get transactionType;

  /// No description provided for @transactionAmount.
  ///
  /// In ja, this message translates to:
  /// **'金額'**
  String get transactionAmount;

  /// No description provided for @transactionDateTime.
  ///
  /// In ja, this message translates to:
  /// **'日時'**
  String get transactionDateTime;

  /// No description provided for @transactionMemo.
  ///
  /// In ja, this message translates to:
  /// **'メモ'**
  String get transactionMemo;

  /// No description provided for @noMemo.
  ///
  /// In ja, this message translates to:
  /// **'メモなし'**
  String get noMemo;

  /// No description provided for @editRecord.
  ///
  /// In ja, this message translates to:
  /// **'編集する'**
  String get editRecord;

  /// No description provided for @deleteRecord.
  ///
  /// In ja, this message translates to:
  /// **'削除する'**
  String get deleteRecord;

  /// No description provided for @updateRecord.
  ///
  /// In ja, this message translates to:
  /// **'更新する'**
  String get updateRecord;

  /// No description provided for @deleteConfirm.
  ///
  /// In ja, this message translates to:
  /// **'この記録を削除しますか？'**
  String get deleteConfirm;

  /// No description provided for @deleteConfirmSub.
  ///
  /// In ja, this message translates to:
  /// **'この操作は元に戻せません。'**
  String get deleteConfirmSub;

  /// No description provided for @recordDeleted.
  ///
  /// In ja, this message translates to:
  /// **'記録を削除しました'**
  String get recordDeleted;

  /// No description provided for @recordUpdated.
  ///
  /// In ja, this message translates to:
  /// **'記録を更新しました'**
  String get recordUpdated;

  /// No description provided for @undoAction.
  ///
  /// In ja, this message translates to:
  /// **'元に戻す'**
  String get undoAction;

  /// No description provided for @noRecordsEmpty.
  ///
  /// In ja, this message translates to:
  /// **'記録がありません'**
  String get noRecordsEmpty;

  /// No description provided for @listView.
  ///
  /// In ja, this message translates to:
  /// **'リスト'**
  String get listView;

  /// No description provided for @calendarView.
  ///
  /// In ja, this message translates to:
  /// **'カレンダー'**
  String get calendarView;

  /// No description provided for @dailyTotal.
  ///
  /// In ja, this message translates to:
  /// **'合計'**
  String get dailyTotal;

  /// No description provided for @noRecordsForDay.
  ///
  /// In ja, this message translates to:
  /// **'この日の記録はありません'**
  String get noRecordsForDay;

  /// No description provided for @pdfReportTitle.
  ///
  /// In ja, this message translates to:
  /// **'月間PDFレポート'**
  String get pdfReportTitle;

  /// No description provided for @pdfReportDescription.
  ///
  /// In ja, this message translates to:
  /// **'今月の家計簿をPDFで共有しましょう'**
  String get pdfReportDescription;

  /// No description provided for @pdfShareButton.
  ///
  /// In ja, this message translates to:
  /// **'PDFレポートを共有'**
  String get pdfShareButton;

  /// No description provided for @pdfGenerating.
  ///
  /// In ja, this message translates to:
  /// **'PDF作成中...'**
  String get pdfGenerating;

  /// No description provided for @pdfMonthlyReport.
  ///
  /// In ja, this message translates to:
  /// **'月間レポート'**
  String get pdfMonthlyReport;

  /// No description provided for @pdfApparentExpense.
  ///
  /// In ja, this message translates to:
  /// **'見かけの支出'**
  String get pdfApparentExpense;

  /// No description provided for @pdfDifference.
  ///
  /// In ja, this message translates to:
  /// **'差額'**
  String get pdfDifference;

  /// No description provided for @pdfTransactionCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}件'**
  String pdfTransactionCount(int count);

  /// No description provided for @pdfAndMore.
  ///
  /// In ja, this message translates to:
  /// **'他 {count}件'**
  String pdfAndMore(int count);

  /// No description provided for @pdfGeneratedOn.
  ///
  /// In ja, this message translates to:
  /// **'作成日: {date}'**
  String pdfGeneratedOn(String date);

  /// No description provided for @pdfBudgetUsage.
  ///
  /// In ja, this message translates to:
  /// **'予算 {budget} 中 {used} 使用 ({percent}%)'**
  String pdfBudgetUsage(String budget, String used, String percent);

  /// No description provided for @pdfBudgetPaceGood.
  ///
  /// In ja, this message translates to:
  /// **'予算の{percent}%を使用しており、良いペースです'**
  String pdfBudgetPaceGood(String percent);

  /// No description provided for @pdfBudgetPaceOver.
  ///
  /// In ja, this message translates to:
  /// **'予算を{amount}超過しています。支出を見直しましょう'**
  String pdfBudgetPaceOver(String amount);

  /// No description provided for @pdfAdviceTopCategory.
  ///
  /// In ja, this message translates to:
  /// **'来月も{category}の見直しを検討してみましょう'**
  String pdfAdviceTopCategory(String category);

  /// No description provided for @pdfAdviceGeneral.
  ///
  /// In ja, this message translates to:
  /// **'コツコツ記録することが節約への第一歩です'**
  String get pdfAdviceGeneral;

  /// No description provided for @pdfBrandFooter.
  ///
  /// In ja, this message translates to:
  /// **'Hareru - スマート家計簿'**
  String get pdfBrandFooter;

  /// No description provided for @addExpense.
  ///
  /// In ja, this message translates to:
  /// **'支出を記録'**
  String get addExpense;

  /// No description provided for @addIncome.
  ///
  /// In ja, this message translates to:
  /// **'収入を記録'**
  String get addIncome;

  /// No description provided for @addTransfer.
  ///
  /// In ja, this message translates to:
  /// **'振替を記録'**
  String get addTransfer;

  /// No description provided for @editExpense.
  ///
  /// In ja, this message translates to:
  /// **'支出を編集'**
  String get editExpense;

  /// No description provided for @editIncome.
  ///
  /// In ja, this message translates to:
  /// **'収入を編集'**
  String get editIncome;

  /// No description provided for @editTransfer.
  ///
  /// In ja, this message translates to:
  /// **'振替を編集'**
  String get editTransfer;

  /// No description provided for @transferFrom.
  ///
  /// In ja, this message translates to:
  /// **'出金元'**
  String get transferFrom;

  /// No description provided for @transferTo.
  ///
  /// In ja, this message translates to:
  /// **'入金先'**
  String get transferTo;

  /// No description provided for @addAccountTitle.
  ///
  /// In ja, this message translates to:
  /// **'口座を追加'**
  String get addAccountTitle;

  /// No description provided for @addAccountStep1.
  ///
  /// In ja, this message translates to:
  /// **'アイコン'**
  String get addAccountStep1;

  /// No description provided for @addAccountStep2.
  ///
  /// In ja, this message translates to:
  /// **'口座の名前'**
  String get addAccountStep2;

  /// No description provided for @addAccountHint.
  ///
  /// In ja, this message translates to:
  /// **'例: UFJ 生活費, 楽天 貯金用'**
  String get addAccountHint;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？'**
  String deleteAccountConfirm(String name);

  /// No description provided for @incomeDepositTo.
  ///
  /// In ja, this message translates to:
  /// **'入金先'**
  String get incomeDepositTo;

  /// No description provided for @addAccountPrompt.
  ///
  /// In ja, this message translates to:
  /// **'口座を追加してください'**
  String get addAccountPrompt;

  /// No description provided for @paymentMethod.
  ///
  /// In ja, this message translates to:
  /// **'決済方法'**
  String get paymentMethod;

  /// No description provided for @creditCard.
  ///
  /// In ja, this message translates to:
  /// **'クレジット'**
  String get creditCard;

  /// No description provided for @debitCard.
  ///
  /// In ja, this message translates to:
  /// **'デビット'**
  String get debitCard;

  /// No description provided for @cash.
  ///
  /// In ja, this message translates to:
  /// **'現金'**
  String get cash;

  /// No description provided for @monthlyRecurring.
  ///
  /// In ja, this message translates to:
  /// **'毎月繰り返し'**
  String get monthlyRecurring;

  /// No description provided for @amountHint.
  ///
  /// In ja, this message translates to:
  /// **'金額を入力'**
  String get amountHint;

  /// No description provided for @support.
  ///
  /// In ja, this message translates to:
  /// **'サポート'**
  String get support;

  /// No description provided for @faq.
  ///
  /// In ja, this message translates to:
  /// **'よくある質問'**
  String get faq;

  /// No description provided for @contactUs.
  ///
  /// In ja, this message translates to:
  /// **'お問い合わせ'**
  String get contactUs;

  /// No description provided for @contactSubject.
  ///
  /// In ja, this message translates to:
  /// **'[Hareru] お問い合わせ'**
  String get contactSubject;

  /// No description provided for @contactBody.
  ///
  /// In ja, this message translates to:
  /// **'【お問い合わせ内容】\n\n\n---\nアプリバージョン: {version}\niOS: {osVersion}\n端末: {device}\n言語: {locale}'**
  String contactBody(
    String version,
    String osVersion,
    String device,
    String locale,
  );

  /// No description provided for @contactFallback.
  ///
  /// In ja, this message translates to:
  /// **'メールアプリが見つかりません。アドレスをコピーしてご利用ください。'**
  String get contactFallback;

  /// No description provided for @noInternet.
  ///
  /// In ja, this message translates to:
  /// **'インターネットに接続してください'**
  String get noInternet;

  /// No description provided for @contactDesc.
  ///
  /// In ja, this message translates to:
  /// **'ご質問やフィードバックはメールでお送りください'**
  String get contactDesc;

  /// No description provided for @contactCopy.
  ///
  /// In ja, this message translates to:
  /// **'コピー'**
  String get contactCopy;

  /// No description provided for @contactOpenMail.
  ///
  /// In ja, this message translates to:
  /// **'メールを開く'**
  String get contactOpenMail;

  /// No description provided for @contactCopied.
  ///
  /// In ja, this message translates to:
  /// **'コピーしました'**
  String get contactCopied;

  /// No description provided for @otherSection.
  ///
  /// In ja, this message translates to:
  /// **'その他'**
  String get otherSection;

  /// No description provided for @lastUpdatedDate.
  ///
  /// In ja, this message translates to:
  /// **'最終更新日: 2026年2月28日'**
  String get lastUpdatedDate;

  /// No description provided for @appCatchphrase.
  ///
  /// In ja, this message translates to:
  /// **'もやもやした家計を、\nすっきり晴れやかに。'**
  String get appCatchphrase;

  /// No description provided for @copied.
  ///
  /// In ja, this message translates to:
  /// **'コピーしました'**
  String get copied;

  /// No description provided for @copyright.
  ///
  /// In ja, this message translates to:
  /// **'© 2026 Lunalism'**
  String get copyright;

  /// No description provided for @accountSection.
  ///
  /// In ja, this message translates to:
  /// **'アカウント'**
  String get accountSection;

  /// No description provided for @login.
  ///
  /// In ja, this message translates to:
  /// **'ログイン'**
  String get login;

  /// No description provided for @loginDescription.
  ///
  /// In ja, this message translates to:
  /// **'ログインすると、以下の機能がご利用いただけます:'**
  String get loginDescription;

  /// No description provided for @loginBenefitBank.
  ///
  /// In ja, this message translates to:
  /// **'最新の銀行金利比較'**
  String get loginBenefitBank;

  /// No description provided for @loginBenefitAI.
  ///
  /// In ja, this message translates to:
  /// **'AIインサイト（有料）'**
  String get loginBenefitAI;

  /// No description provided for @loginBenefitBackup.
  ///
  /// In ja, this message translates to:
  /// **'データのクラウドバックアップ'**
  String get loginBenefitBackup;

  /// No description provided for @signInWithApple.
  ///
  /// In ja, this message translates to:
  /// **'Appleでサインイン'**
  String get signInWithApple;

  /// No description provided for @signInWithGoogle.
  ///
  /// In ja, this message translates to:
  /// **'Googleでサインイン'**
  String get signInWithGoogle;

  /// No description provided for @skipLogin.
  ///
  /// In ja, this message translates to:
  /// **'スキップして続ける'**
  String get skipLogin;

  /// No description provided for @loginSuccess.
  ///
  /// In ja, this message translates to:
  /// **'ログイン完了'**
  String get loginSuccess;

  /// No description provided for @loginError.
  ///
  /// In ja, this message translates to:
  /// **'ログインに失敗しました'**
  String get loginError;

  /// No description provided for @logout.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In ja, this message translates to:
  /// **'ログアウトしますか？'**
  String get logoutConfirm;

  /// No description provided for @bankLoadError.
  ///
  /// In ja, this message translates to:
  /// **'データの読み込みに失敗しました'**
  String get bankLoadError;

  /// No description provided for @bankRetry.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get bankRetry;

  /// No description provided for @dictionaryTitle.
  ///
  /// In ja, this message translates to:
  /// **'金融辞書'**
  String get dictionaryTitle;

  /// No description provided for @searchPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'用語を検索...'**
  String get searchPlaceholder;

  /// No description provided for @categoryAll.
  ///
  /// In ja, this message translates to:
  /// **'全て'**
  String get categoryAll;

  /// No description provided for @categoryBanking.
  ///
  /// In ja, this message translates to:
  /// **'銀行'**
  String get categoryBanking;

  /// No description provided for @categoryHousehold.
  ///
  /// In ja, this message translates to:
  /// **'家計'**
  String get categoryHousehold;

  /// No description provided for @categoryTax.
  ///
  /// In ja, this message translates to:
  /// **'税金'**
  String get categoryTax;

  /// No description provided for @categoryInsurance.
  ///
  /// In ja, this message translates to:
  /// **'保険'**
  String get categoryInsurance;

  /// No description provided for @categorySavings.
  ///
  /// In ja, this message translates to:
  /// **'貯蓄'**
  String get categorySavings;

  /// No description provided for @categoryLoan.
  ///
  /// In ja, this message translates to:
  /// **'ローン'**
  String get categoryLoan;

  /// No description provided for @categorySystem.
  ///
  /// In ja, this message translates to:
  /// **'制度'**
  String get categorySystem;

  /// No description provided for @categoryPayment.
  ///
  /// In ja, this message translates to:
  /// **'決済'**
  String get categoryPayment;

  /// No description provided for @sectionExplanation.
  ///
  /// In ja, this message translates to:
  /// **'解説'**
  String get sectionExplanation;

  /// No description provided for @sectionExample.
  ///
  /// In ja, this message translates to:
  /// **'たとえば'**
  String get sectionExample;

  /// No description provided for @sectionRelated.
  ///
  /// In ja, this message translates to:
  /// **'関連用語'**
  String get sectionRelated;

  /// No description provided for @aiAskAboutMoney.
  ///
  /// In ja, this message translates to:
  /// **'AIにお金のことを聞いてみよう'**
  String get aiAskAboutMoney;

  /// No description provided for @aiPersonalizedAdvice.
  ///
  /// In ja, this message translates to:
  /// **'あなたの家計に合わせたアドバイス'**
  String get aiPersonalizedAdvice;

  /// No description provided for @aiLearnMore.
  ///
  /// In ja, this message translates to:
  /// **'もっと詳しく知りたい？'**
  String get aiLearnMore;

  /// No description provided for @aiExplainForYou.
  ///
  /// In ja, this message translates to:
  /// **'AIがあなたの家計に合わせて解説'**
  String get aiExplainForYou;

  /// No description provided for @webviewLoadError.
  ///
  /// In ja, this message translates to:
  /// **'ページを読み込めませんでした'**
  String get webviewLoadError;

  /// No description provided for @retry.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get retry;

  /// No description provided for @pdfOverBudget.
  ///
  /// In ja, this message translates to:
  /// **'超過'**
  String get pdfOverBudget;

  /// No description provided for @shareReportSubject.
  ///
  /// In ja, this message translates to:
  /// **'Hareru レポート'**
  String get shareReportSubject;

  /// No description provided for @pdfError.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get pdfError;

  /// No description provided for @notificationChannelName.
  ///
  /// In ja, this message translates to:
  /// **'毎日リマインダー'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDesc.
  ///
  /// In ja, this message translates to:
  /// **'毎日の支出記録リマインダー'**
  String get notificationChannelDesc;

  /// No description provided for @paywallTitle.
  ///
  /// In ja, this message translates to:
  /// **'Hareruをもっと便利に'**
  String get paywallTitle;

  /// No description provided for @paywallMonthly.
  ///
  /// In ja, this message translates to:
  /// **'月額'**
  String get paywallMonthly;

  /// No description provided for @paywallYearly.
  ///
  /// In ja, this message translates to:
  /// **'年額'**
  String get paywallYearly;

  /// No description provided for @paywallYearlyBadge.
  ///
  /// In ja, this message translates to:
  /// **'おすすめ'**
  String get paywallYearlyBadge;

  /// No description provided for @paywallSaveMonths.
  ///
  /// In ja, this message translates to:
  /// **'2ヶ月分お得！'**
  String get paywallSaveMonths;

  /// No description provided for @paywallClearTitle.
  ///
  /// In ja, this message translates to:
  /// **'Clear'**
  String get paywallClearTitle;

  /// No description provided for @paywallClearProTitle.
  ///
  /// In ja, this message translates to:
  /// **'ClearPro'**
  String get paywallClearProTitle;

  /// No description provided for @paywallClearCta.
  ///
  /// In ja, this message translates to:
  /// **'Clearを始める'**
  String get paywallClearCta;

  /// No description provided for @paywallClearProCta.
  ///
  /// In ja, this message translates to:
  /// **'ClearProを始める'**
  String get paywallClearProCta;

  /// No description provided for @paywallRestore.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元する'**
  String get paywallRestore;

  /// No description provided for @paywallContinueFree.
  ///
  /// In ja, this message translates to:
  /// **'無料プランを続ける'**
  String get paywallContinueFree;

  /// No description provided for @paywallTerms.
  ///
  /// In ja, this message translates to:
  /// **'利用規約'**
  String get paywallTerms;

  /// No description provided for @paywallPrivacy.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get paywallPrivacy;

  /// No description provided for @featureNoAds.
  ///
  /// In ja, this message translates to:
  /// **'広告なし'**
  String get featureNoAds;

  /// No description provided for @featureAiInsight.
  ///
  /// In ja, this message translates to:
  /// **'AI分析'**
  String get featureAiInsight;

  /// No description provided for @featureSavingSim.
  ///
  /// In ja, this message translates to:
  /// **'節約シミュレーション'**
  String get featureSavingSim;

  /// No description provided for @featureCsvExport.
  ///
  /// In ja, this message translates to:
  /// **'CSV出力'**
  String get featureCsvExport;

  /// No description provided for @featureAiCoaching.
  ///
  /// In ja, this message translates to:
  /// **'AIコーチング'**
  String get featureAiCoaching;

  /// No description provided for @featurePdfReport.
  ///
  /// In ja, this message translates to:
  /// **'PDF月次レポート'**
  String get featurePdfReport;

  /// No description provided for @featureSavingGoal.
  ///
  /// In ja, this message translates to:
  /// **'貯蓄目標管理'**
  String get featureSavingGoal;

  /// No description provided for @featurePrioritySupport.
  ///
  /// In ja, this message translates to:
  /// **'優先サポート'**
  String get featurePrioritySupport;

  /// No description provided for @settingsSubscription.
  ///
  /// In ja, this message translates to:
  /// **'サブスクリプション'**
  String get settingsSubscription;

  /// No description provided for @settingsCurrentPlan.
  ///
  /// In ja, this message translates to:
  /// **'現在のプラン'**
  String get settingsCurrentPlan;

  /// No description provided for @settingsRestorePurchase.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元'**
  String get settingsRestorePurchase;

  /// No description provided for @settingsManageSubscription.
  ///
  /// In ja, this message translates to:
  /// **'サブスクリプション管理'**
  String get settingsManageSubscription;

  /// No description provided for @lockClearRequired.
  ///
  /// In ja, this message translates to:
  /// **'Clearで利用可能'**
  String get lockClearRequired;

  /// No description provided for @lockClearProRequired.
  ///
  /// In ja, this message translates to:
  /// **'ClearProで利用可能'**
  String get lockClearProRequired;

  /// No description provided for @lockUpgrade.
  ///
  /// In ja, this message translates to:
  /// **'アップグレード'**
  String get lockUpgrade;

  /// No description provided for @purchaseSuccess.
  ///
  /// In ja, this message translates to:
  /// **'購入が完了しました！'**
  String get purchaseSuccess;

  /// No description provided for @purchaseRestored.
  ///
  /// In ja, this message translates to:
  /// **'購入を復元しました'**
  String get purchaseRestored;

  /// No description provided for @purchaseError.
  ///
  /// In ja, this message translates to:
  /// **'購入に失敗しました'**
  String get purchaseError;

  /// No description provided for @purchaseNotAvailable.
  ///
  /// In ja, this message translates to:
  /// **'現在購入できません'**
  String get purchaseNotAvailable;

  /// No description provided for @adPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'広告 — Clearで非表示にできます'**
  String get adPlaceholder;

  /// No description provided for @purchaseNotAvailableDesc.
  ///
  /// In ja, this message translates to:
  /// **'現在、アプリ内購入をご利用いただけません。後ほどお試しください。'**
  String get purchaseNotAvailableDesc;

  /// No description provided for @restoreNoPurchase.
  ///
  /// In ja, this message translates to:
  /// **'復元できる購入がありません'**
  String get restoreNoPurchase;

  /// No description provided for @subscriptionExpiresOn.
  ///
  /// In ja, this message translates to:
  /// **'有効期限: {date}'**
  String subscriptionExpiresOn(String date);

  /// No description provided for @planFree.
  ///
  /// In ja, this message translates to:
  /// **'Free'**
  String get planFree;

  /// No description provided for @planClear.
  ///
  /// In ja, this message translates to:
  /// **'Clear'**
  String get planClear;

  /// No description provided for @planClearPro.
  ///
  /// In ja, this message translates to:
  /// **'ClearPro'**
  String get planClearPro;

  /// No description provided for @todaysTerm.
  ///
  /// In ja, this message translates to:
  /// **'今日の用語'**
  String get todaysTerm;

  /// No description provided for @bookmarkAdd.
  ///
  /// In ja, this message translates to:
  /// **'ブックマークに追加しました'**
  String get bookmarkAdd;

  /// No description provided for @bookmarkRemove.
  ///
  /// In ja, this message translates to:
  /// **'ブックマークから削除しました'**
  String get bookmarkRemove;

  /// No description provided for @reviewTab.
  ///
  /// In ja, this message translates to:
  /// **'復習'**
  String get reviewTab;

  /// No description provided for @learningProgress.
  ///
  /// In ja, this message translates to:
  /// **'{viewed}/{total} 用語を学習済み'**
  String learningProgress(int viewed, int total);

  /// No description provided for @allTermsMastered.
  ///
  /// In ja, this message translates to:
  /// **'すべての用語を学習しました！'**
  String get allTermsMastered;

  /// No description provided for @difficultyBasic.
  ///
  /// In ja, this message translates to:
  /// **'基礎'**
  String get difficultyBasic;

  /// No description provided for @difficultyIntermediate.
  ///
  /// In ja, this message translates to:
  /// **'中級'**
  String get difficultyIntermediate;

  /// No description provided for @difficultyAdvanced.
  ///
  /// In ja, this message translates to:
  /// **'応用'**
  String get difficultyAdvanced;

  /// No description provided for @noBookmarks.
  ///
  /// In ja, this message translates to:
  /// **'まだブックマークがありません'**
  String get noBookmarks;
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
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
