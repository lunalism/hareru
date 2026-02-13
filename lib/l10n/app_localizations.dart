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

  /// No description provided for @onboardingStart.
  ///
  /// In ja, this message translates to:
  /// **'始めましょう！'**
  String get onboardingStart;

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
  /// **'本当の支出 ✨'**
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
  /// **'貯蓄 ⚠️'**
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
  /// **'下の＋ボタンで\n最初の記録を追加しましょう'**
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
  /// **'月ごとの予算を設定して管理'**
  String get guideBudgetDesc;

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
  /// **'その他貯蓄'**
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
