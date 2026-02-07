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
/// import 'generated/app_localizations.dart';
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
    Locale('ko'),
    Locale('ja'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'Hareru'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @household.
  ///
  /// In ko, this message translates to:
  /// **'가계부'**
  String get household;

  /// No description provided for @monthlyBudget.
  ///
  /// In ko, this message translates to:
  /// **'월 예산'**
  String get monthlyBudget;

  /// No description provided for @categoryManage.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 관리'**
  String get categoryManage;

  /// No description provided for @startDayOfWeek.
  ///
  /// In ko, this message translates to:
  /// **'주 시작 요일'**
  String get startDayOfWeek;

  /// No description provided for @autoExcludeTransfer.
  ///
  /// In ko, this message translates to:
  /// **'이체 자동 제외'**
  String get autoExcludeTransfer;

  /// No description provided for @autoExcludeTransferDesc.
  ///
  /// In ko, this message translates to:
  /// **'계좌 간 이체를 지출에서 자동으로 제외합니다'**
  String get autoExcludeTransferDesc;

  /// No description provided for @security.
  ///
  /// In ko, this message translates to:
  /// **'보안'**
  String get security;

  /// No description provided for @appLock.
  ///
  /// In ko, this message translates to:
  /// **'앱 잠금'**
  String get appLock;

  /// No description provided for @appLockDesc.
  ///
  /// In ko, this message translates to:
  /// **'Face ID 또는 패스코드로 잠금'**
  String get appLockDesc;

  /// No description provided for @icloudBackup.
  ///
  /// In ko, this message translates to:
  /// **'iCloud 백업'**
  String get icloudBackup;

  /// No description provided for @app.
  ///
  /// In ko, this message translates to:
  /// **'앱'**
  String get app;

  /// No description provided for @screenMode.
  ///
  /// In ko, this message translates to:
  /// **'화면 모드'**
  String get screenMode;

  /// No description provided for @inputReminder.
  ///
  /// In ko, this message translates to:
  /// **'입력 리마인더'**
  String get inputReminder;

  /// No description provided for @inputReminderDesc.
  ///
  /// In ko, this message translates to:
  /// **'매일 설정한 시간에 알림을 보내드려요'**
  String get inputReminderDesc;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @etc.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get etc;

  /// No description provided for @sendFeedback.
  ///
  /// In ko, this message translates to:
  /// **'의견 보내기'**
  String get sendFeedback;

  /// No description provided for @appInfo.
  ///
  /// In ko, this message translates to:
  /// **'앱 정보'**
  String get appInfo;

  /// No description provided for @madeWith.
  ///
  /// In ko, this message translates to:
  /// **'Made with 💙'**
  String get madeWith;

  /// No description provided for @comingSoon.
  ///
  /// In ko, this message translates to:
  /// **'coming soon'**
  String get comingSoon;

  /// No description provided for @preparingFeature.
  ///
  /// In ko, this message translates to:
  /// **'준비 중인 기능이에요'**
  String get preparingFeature;

  /// No description provided for @monthlyBudgetSetting.
  ///
  /// In ko, this message translates to:
  /// **'월 예산 설정'**
  String get monthlyBudgetSetting;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @monday.
  ///
  /// In ko, this message translates to:
  /// **'월요일'**
  String get monday;

  /// No description provided for @sunday.
  ///
  /// In ko, this message translates to:
  /// **'일요일'**
  String get sunday;

  /// No description provided for @system.
  ///
  /// In ko, this message translates to:
  /// **'시스템'**
  String get system;

  /// No description provided for @light.
  ///
  /// In ko, this message translates to:
  /// **'라이트'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In ko, this message translates to:
  /// **'다크'**
  String get dark;

  /// No description provided for @korean.
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @japanese.
  ///
  /// In ko, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @english.
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @monthExpense.
  ///
  /// In ko, this message translates to:
  /// **'{month}월 지출'**
  String monthExpense(int month);

  /// No description provided for @comparedLastMonthDown.
  ///
  /// In ko, this message translates to:
  /// **'지난달보다 ¥{amount} ↓ 절약! 🎉'**
  String comparedLastMonthDown(String amount);

  /// No description provided for @comparedLastMonthUp.
  ///
  /// In ko, this message translates to:
  /// **'지난달보다 ¥{amount} ↑ 과소비 주의 ⚠️'**
  String comparedLastMonthUp(String amount);

  /// No description provided for @budget.
  ///
  /// In ko, this message translates to:
  /// **'예산 ¥{amount}'**
  String budget(String amount);

  /// No description provided for @todayExpense.
  ///
  /// In ko, this message translates to:
  /// **'오늘 지출'**
  String get todayExpense;

  /// No description provided for @total.
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get total;

  /// No description provided for @thisWeekExpense.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 지출'**
  String get thisWeekExpense;

  /// No description provided for @today.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get today;

  /// No description provided for @noExpenseToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘은 아직 지출이 없어요'**
  String get noExpenseToday;

  /// No description provided for @home.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get home;

  /// No description provided for @report.
  ///
  /// In ko, this message translates to:
  /// **'리포트'**
  String get report;

  /// No description provided for @input.
  ///
  /// In ko, this message translates to:
  /// **'입력'**
  String get input;

  /// No description provided for @dictionary.
  ///
  /// In ko, this message translates to:
  /// **'사전'**
  String get dictionary;

  /// No description provided for @categoryFood.
  ///
  /// In ko, this message translates to:
  /// **'식비'**
  String get categoryFood;

  /// No description provided for @categoryTransport.
  ///
  /// In ko, this message translates to:
  /// **'교통'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑'**
  String get categoryShopping;

  /// No description provided for @categoryCafe.
  ///
  /// In ko, this message translates to:
  /// **'카페'**
  String get categoryCafe;

  /// No description provided for @categoryEntertainment.
  ///
  /// In ko, this message translates to:
  /// **'여가'**
  String get categoryEntertainment;

  /// No description provided for @categoryMedical.
  ///
  /// In ko, this message translates to:
  /// **'의료'**
  String get categoryMedical;

  /// No description provided for @categoryTransfer.
  ///
  /// In ko, this message translates to:
  /// **'이체'**
  String get categoryTransfer;

  /// No description provided for @categoryOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get categoryOther;

  /// No description provided for @savingsTransfer.
  ///
  /// In ko, this message translates to:
  /// **'저축계좌 이체'**
  String get savingsTransfer;

  /// No description provided for @lunch.
  ///
  /// In ko, this message translates to:
  /// **'점심'**
  String get lunch;

  /// No description provided for @transportFee.
  ///
  /// In ko, this message translates to:
  /// **'교통비'**
  String get transportFee;

  /// No description provided for @coffee.
  ///
  /// In ko, this message translates to:
  /// **'커피'**
  String get coffee;

  /// No description provided for @mon.
  ///
  /// In ko, this message translates to:
  /// **'월'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In ko, this message translates to:
  /// **'화'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In ko, this message translates to:
  /// **'수'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In ko, this message translates to:
  /// **'목'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In ko, this message translates to:
  /// **'금'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In ko, this message translates to:
  /// **'토'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In ko, this message translates to:
  /// **'일'**
  String get sun;

  /// No description provided for @categoryAdd.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 추가'**
  String get categoryAdd;

  /// No description provided for @categoryName.
  ///
  /// In ko, this message translates to:
  /// **'카테고리명'**
  String get categoryName;

  /// No description provided for @notificationTime.
  ///
  /// In ko, this message translates to:
  /// **'알림 시간'**
  String get notificationTime;

  /// No description provided for @receiptScan.
  ///
  /// In ko, this message translates to:
  /// **'영수증 스캔'**
  String get receiptScan;

  /// No description provided for @manualInput.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get manualInput;

  /// No description provided for @receiptScanDesc.
  ///
  /// In ko, this message translates to:
  /// **'카메라로 영수증을 촬영해요'**
  String get receiptScanDesc;

  /// No description provided for @manualInputDesc.
  ///
  /// In ko, this message translates to:
  /// **'금액과 카테고리를 직접 입력해요'**
  String get manualInputDesc;

  /// No description provided for @expense.
  ///
  /// In ko, this message translates to:
  /// **'지출'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In ko, this message translates to:
  /// **'수입'**
  String get income;

  /// No description provided for @transfer.
  ///
  /// In ko, this message translates to:
  /// **'이체'**
  String get transfer;

  /// No description provided for @enterAmount.
  ///
  /// In ko, this message translates to:
  /// **'금액 입력'**
  String get enterAmount;

  /// No description provided for @selectCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 선택'**
  String get selectCategory;

  /// No description provided for @addMemo.
  ///
  /// In ko, this message translates to:
  /// **'메모 추가'**
  String get addMemo;

  /// No description provided for @date.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get date;

  /// No description provided for @memo.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get memo;

  /// No description provided for @fromAccount.
  ///
  /// In ko, this message translates to:
  /// **'출금 계좌'**
  String get fromAccount;

  /// No description provided for @toAccount.
  ///
  /// In ko, this message translates to:
  /// **'입금 계좌'**
  String get toAccount;

  /// No description provided for @categorySalary.
  ///
  /// In ko, this message translates to:
  /// **'급여'**
  String get categorySalary;

  /// No description provided for @categoryAllowance.
  ///
  /// In ko, this message translates to:
  /// **'용돈'**
  String get categoryAllowance;

  /// No description provided for @categorySidejob.
  ///
  /// In ko, this message translates to:
  /// **'부업'**
  String get categorySidejob;

  /// No description provided for @categoryInvestment.
  ///
  /// In ko, this message translates to:
  /// **'투자'**
  String get categoryInvestment;

  /// No description provided for @receiptScanTitle.
  ///
  /// In ko, this message translates to:
  /// **'영수증 스캔'**
  String get receiptScanTitle;

  /// No description provided for @receiptScanComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'준비 중인 기능이에요'**
  String get receiptScanComingSoon;

  /// No description provided for @noTransactions.
  ///
  /// In ko, this message translates to:
  /// **'아직 거래 내역이 없어요'**
  String get noTransactions;

  /// No description provided for @addFirstTransaction.
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼을 눌러 첫 거래를 추가해보세요'**
  String get addFirstTransaction;

  /// No description provided for @inputMethod.
  ///
  /// In ko, this message translates to:
  /// **'입력 방법'**
  String get inputMethod;

  /// No description provided for @amount.
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get amount;

  /// No description provided for @savedSuccess.
  ///
  /// In ko, this message translates to:
  /// **'저장되었습니다'**
  String get savedSuccess;

  /// No description provided for @reportTitle.
  ///
  /// In ko, this message translates to:
  /// **'리포트'**
  String get reportTitle;

  /// No description provided for @periodWeekly.
  ///
  /// In ko, this message translates to:
  /// **'주간'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In ko, this message translates to:
  /// **'월간'**
  String get periodMonthly;

  /// No description provided for @periodYearly.
  ///
  /// In ko, this message translates to:
  /// **'연간'**
  String get periodYearly;

  /// No description provided for @realExpense.
  ///
  /// In ko, this message translates to:
  /// **'실질 지출'**
  String get realExpense;

  /// No description provided for @transferExcluded.
  ///
  /// In ko, this message translates to:
  /// **'이체 ¥{amount} 제외'**
  String transferExcluded(String amount);

  /// No description provided for @balance.
  ///
  /// In ko, this message translates to:
  /// **'잔액'**
  String get balance;

  /// No description provided for @comparedToPrevMonth.
  ///
  /// In ko, this message translates to:
  /// **'전월 대비'**
  String get comparedToPrevMonth;

  /// No description provided for @categoryBreakdown.
  ///
  /// In ko, this message translates to:
  /// **'카테고리별 지출'**
  String get categoryBreakdown;

  /// No description provided for @expenseTrend.
  ///
  /// In ko, this message translates to:
  /// **'지출 추이'**
  String get expenseTrend;

  /// No description provided for @monthlyInsight.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 인사이트'**
  String get monthlyInsight;

  /// No description provided for @weeklyInsight.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 인사이트'**
  String get weeklyInsight;

  /// No description provided for @yearlyInsight.
  ///
  /// In ko, this message translates to:
  /// **'올해 인사이트'**
  String get yearlyInsight;

  /// No description provided for @categoryDetail.
  ///
  /// In ko, this message translates to:
  /// **'카테고리 상세'**
  String get categoryDetail;

  /// No description provided for @topSpendingDay.
  ///
  /// In ko, this message translates to:
  /// **'가장 많이 쓴 날'**
  String get topSpendingDay;

  /// No description provided for @comparedToPrev.
  ///
  /// In ko, this message translates to:
  /// **'전월 대비 변화'**
  String get comparedToPrev;

  /// No description provided for @leastSpendingWeek.
  ///
  /// In ko, this message translates to:
  /// **'가장 적게 쓴 주'**
  String get leastSpendingWeek;

  /// No description provided for @noReportDataTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 데이터가 없어요'**
  String get noReportDataTitle;

  /// No description provided for @noReportDataDesc.
  ///
  /// In ko, this message translates to:
  /// **'지출을 기록하면\n여기서 분석을 볼 수 있어요'**
  String get noReportDataDesc;

  /// No description provided for @recordExpense.
  ///
  /// In ko, this message translates to:
  /// **'지출 기록하기'**
  String get recordExpense;

  /// No description provided for @showMore.
  ///
  /// In ko, this message translates to:
  /// **'더 보기'**
  String get showMore;

  /// No description provided for @transactionCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}건'**
  String transactionCount(int count);

  /// No description provided for @dailyAverage.
  ///
  /// In ko, this message translates to:
  /// **'평균 ¥{amount}/일'**
  String dailyAverage(String amount);

  /// No description provided for @notEnoughData.
  ///
  /// In ko, this message translates to:
  /// **'아직 데이터가 충분하지 않아요. 기록을 계속해보세요!'**
  String get notEnoughData;

  /// No description provided for @increase.
  ///
  /// In ko, this message translates to:
  /// **'증가'**
  String get increase;

  /// No description provided for @decrease.
  ///
  /// In ko, this message translates to:
  /// **'감소'**
  String get decrease;

  /// No description provided for @yearFormat.
  ///
  /// In ko, this message translates to:
  /// **'{year}년'**
  String yearFormat(int year);

  /// No description provided for @monthFormat.
  ///
  /// In ko, this message translates to:
  /// **'{year}년 {month}월'**
  String monthFormat(int year, int month);

  /// No description provided for @weekFormat.
  ///
  /// In ko, this message translates to:
  /// **'{month}월 {week}주차'**
  String weekFormat(int month, int week);

  /// No description provided for @weekRangeFormat.
  ///
  /// In ko, this message translates to:
  /// **'{startMonth}/{startDay} ~ {endMonth}/{endDay}'**
  String weekRangeFormat(
    int startMonth,
    int startDay,
    int endMonth,
    int endDay,
  );

  /// No description provided for @categoryIncreased.
  ///
  /// In ko, this message translates to:
  /// **'{category}가 {percent}% 증가했어요'**
  String categoryIncreased(String category, int percent);

  /// No description provided for @categoryDecreased.
  ///
  /// In ko, this message translates to:
  /// **'{category}가 {percent}% 감소했어요'**
  String categoryDecreased(String category, int percent);

  /// No description provided for @nthWeek.
  ///
  /// In ko, this message translates to:
  /// **'{n}째 주'**
  String nthWeek(int n);

  /// No description provided for @premiumDividerLabel.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석'**
  String get premiumDividerLabel;

  /// No description provided for @premiumDividerLabelFree.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 (Clear 전용)'**
  String get premiumDividerLabelFree;

  /// No description provided for @premiumBadge.
  ///
  /// In ko, this message translates to:
  /// **'Clear'**
  String get premiumBadge;

  /// No description provided for @aiInsightTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 리포트'**
  String get aiInsightTitle;

  /// No description provided for @clearComparisonTitle.
  ///
  /// In ko, this message translates to:
  /// **'클리어 비교'**
  String get clearComparisonTitle;

  /// No description provided for @clearComparisonOtherApp.
  ///
  /// In ko, this message translates to:
  /// **'다른 앱이었다면'**
  String get clearComparisonOtherApp;

  /// No description provided for @clearComparisonReal.
  ///
  /// In ko, this message translates to:
  /// **'Hareru의 실질 지출'**
  String get clearComparisonReal;

  /// No description provided for @clearComparisonSaved.
  ///
  /// In ko, this message translates to:
  /// **'Hareru가 ¥{amount}의 혼란을 자동으로 정리했어요'**
  String clearComparisonSaved(String amount);

  /// No description provided for @clearComparisonNoTransfer.
  ///
  /// In ko, this message translates to:
  /// **'이번 기간에는 이체가 없어요. 모든 지출이 실질 지출이에요 ✨'**
  String get clearComparisonNoTransfer;

  /// No description provided for @aiDiscoveriesTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 핵심 발견'**
  String get aiDiscoveriesTitle;

  /// No description provided for @aiDiscoveriesLastAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'마지막 분석: {date}'**
  String aiDiscoveriesLastAnalysis(String date);

  /// No description provided for @aiSuggestionTitle.
  ///
  /// In ko, this message translates to:
  /// **'다음 주 제안'**
  String get aiSuggestionTitle;

  /// No description provided for @aiSuggestionGoalButton.
  ///
  /// In ko, this message translates to:
  /// **'목표 설정하기'**
  String get aiSuggestionGoalButton;

  /// No description provided for @aiSuggestionProOnly.
  ///
  /// In ko, this message translates to:
  /// **'Clear Pro에서 사용 가능'**
  String get aiSuggestionProOnly;

  /// No description provided for @aiSuggestionEmpty.
  ///
  /// In ko, this message translates to:
  /// **'지출 기록을 더 모으면 맞춤 분석을 해드릴게요! 📝'**
  String get aiSuggestionEmpty;

  /// No description provided for @savingPotentialTitle.
  ///
  /// In ko, this message translates to:
  /// **'숨은 절약 가능 금액'**
  String get savingPotentialTitle;

  /// No description provided for @savingPotentialMonthly.
  ///
  /// In ko, this message translates to:
  /// **'월 {amount}'**
  String savingPotentialMonthly(String amount);

  /// No description provided for @savingPotentialYearly.
  ///
  /// In ko, this message translates to:
  /// **'연 {amount} 절약 가능! 🎉'**
  String savingPotentialYearly(String amount);

  /// No description provided for @savingPotentialDetail.
  ///
  /// In ko, this message translates to:
  /// **'상세 보기'**
  String get savingPotentialDetail;

  /// No description provided for @healthScoreTitle.
  ///
  /// In ko, this message translates to:
  /// **'지출 건강도'**
  String get healthScoreTitle;

  /// No description provided for @healthScoreBudget.
  ///
  /// In ko, this message translates to:
  /// **'예산 준수'**
  String get healthScoreBudget;

  /// No description provided for @healthScoreSaving.
  ///
  /// In ko, this message translates to:
  /// **'절약 노력'**
  String get healthScoreSaving;

  /// No description provided for @healthScoreBalance.
  ///
  /// In ko, this message translates to:
  /// **'지출 균형'**
  String get healthScoreBalance;

  /// No description provided for @healthScoreClear.
  ///
  /// In ko, this message translates to:
  /// **'이체 정리'**
  String get healthScoreClear;

  /// No description provided for @healthGradeExcellent.
  ///
  /// In ko, this message translates to:
  /// **'훌륭해요 🌟'**
  String get healthGradeExcellent;

  /// No description provided for @healthGradeGood.
  ///
  /// In ko, this message translates to:
  /// **'양호 👍'**
  String get healthGradeGood;

  /// No description provided for @healthGradeAverage.
  ///
  /// In ko, this message translates to:
  /// **'보통 📊'**
  String get healthGradeAverage;

  /// No description provided for @healthGradeCaution.
  ///
  /// In ko, this message translates to:
  /// **'주의 ⚠️'**
  String get healthGradeCaution;

  /// No description provided for @healthGradeDanger.
  ///
  /// In ko, this message translates to:
  /// **'위험 🚨'**
  String get healthGradeDanger;

  /// No description provided for @blurMessageInsight.
  ///
  /// In ko, this message translates to:
  /// **'AI가 분석한 당신만의\n지출 리포트를 확인해보세요'**
  String get blurMessageInsight;

  /// No description provided for @blurMessageSaving.
  ///
  /// In ko, this message translates to:
  /// **'숨어있는 절약 가능\n금액을 발견해보세요'**
  String get blurMessageSaving;

  /// No description provided for @blurMessageHealth.
  ///
  /// In ko, this message translates to:
  /// **'나의 지출 건강 점수는\n몇 점일까요?'**
  String get blurMessageHealth;

  /// No description provided for @blurCta.
  ///
  /// In ko, this message translates to:
  /// **'Clear 시작하기'**
  String get blurCta;

  /// No description provided for @blurPrice.
  ///
  /// In ko, this message translates to:
  /// **'월 ¥380'**
  String get blurPrice;

  /// No description provided for @blurPremiumComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'프리미엄 기능은 향후 업데이트 예정이에요!'**
  String get blurPremiumComingSoon;

  /// No description provided for @blurFutureUpdate.
  ///
  /// In ko, this message translates to:
  /// **'향후 업데이트 예정'**
  String get blurFutureUpdate;
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
