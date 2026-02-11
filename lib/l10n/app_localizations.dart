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
  /// **'貯蓄'**
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
