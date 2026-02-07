// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hareru';

  @override
  String get settings => 'Settings';

  @override
  String get household => 'Budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get categoryManage => 'Category Management';

  @override
  String get startDayOfWeek => 'Start Day of Week';

  @override
  String get autoExcludeTransfer => 'Auto-exclude Transfers';

  @override
  String get autoExcludeTransferDesc =>
      'Automatically excludes transfers between accounts from spending';

  @override
  String get security => 'Security';

  @override
  String get appLock => 'App Lock';

  @override
  String get appLockDesc => 'Lock with Face ID or passcode';

  @override
  String get icloudBackup => 'iCloud Backup';

  @override
  String get app => 'App';

  @override
  String get screenMode => 'Screen Mode';

  @override
  String get inputReminder => 'Input Reminder';

  @override
  String get inputReminderDesc =>
      'We\'ll send you a notification at the set time every day';

  @override
  String get language => 'Language';

  @override
  String get etc => 'Other';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get appInfo => 'App Info';

  @override
  String get madeWith => 'Made with 💙';

  @override
  String get comingSoon => 'coming soon';

  @override
  String get preparingFeature => 'This feature is coming soon';

  @override
  String get monthlyBudgetSetting => 'Monthly Budget Setting';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get monday => 'Monday';

  @override
  String get sunday => 'Sunday';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get korean => '한국어';

  @override
  String get japanese => '日本語';

  @override
  String get english => 'English';

  @override
  String monthExpense(int month) {
    return '$month Spending';
  }

  @override
  String comparedLastMonthDown(String amount) {
    return '¥$amount less than last month ↓ Saved! 🎉';
  }

  @override
  String comparedLastMonthUp(String amount) {
    return '¥$amount more than last month ↑ Watch out! ⚠️';
  }

  @override
  String budget(String amount) {
    return 'Budget ¥$amount';
  }

  @override
  String get todayExpense => 'Today\'s Spending';

  @override
  String get total => 'Total';

  @override
  String get thisWeekExpense => 'This Week';

  @override
  String get today => 'Today';

  @override
  String get noExpenseToday => 'No spending yet today';

  @override
  String get home => 'Home';

  @override
  String get report => 'Report';

  @override
  String get input => 'Input';

  @override
  String get dictionary => 'Dictionary';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryCafe => 'Cafe';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryMedical => 'Medical';

  @override
  String get categoryTransfer => 'Transfer';

  @override
  String get categoryOther => 'Other';

  @override
  String get savingsTransfer => 'Transfer to savings';

  @override
  String get lunch => 'Lunch';

  @override
  String get transportFee => 'Transport';

  @override
  String get coffee => 'Coffee';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get categoryAdd => 'Add Category';

  @override
  String get categoryName => 'Category name';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get receiptScan => 'Scan Receipt';

  @override
  String get manualInput => 'Manual Input';

  @override
  String get receiptScanDesc => 'Take a photo of your receipt';

  @override
  String get manualInputDesc => 'Enter amount and category manually';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get transfer => 'Transfer';

  @override
  String get enterAmount => 'Enter Amount';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get addMemo => 'Add Memo';

  @override
  String get date => 'Date';

  @override
  String get memo => 'Memo';

  @override
  String get fromAccount => 'From Account';

  @override
  String get toAccount => 'To Account';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryAllowance => 'Allowance';

  @override
  String get categorySidejob => 'Side Job';

  @override
  String get categoryInvestment => 'Investment';

  @override
  String get receiptScanTitle => 'Scan Receipt';

  @override
  String get receiptScanComingSoon => 'This feature is coming soon';

  @override
  String get noTransactions => 'No transactions yet';

  @override
  String get addFirstTransaction => 'Tap + to add your first transaction';

  @override
  String get inputMethod => 'Input Method';

  @override
  String get amount => 'Amount';

  @override
  String get savedSuccess => 'Saved successfully';

  @override
  String get reportTitle => 'Report';

  @override
  String get periodWeekly => 'Weekly';

  @override
  String get periodMonthly => 'Monthly';

  @override
  String get periodYearly => 'Yearly';

  @override
  String get realExpense => 'Real Expense';

  @override
  String transferExcluded(String amount) {
    return 'Transfer ¥$amount excluded';
  }

  @override
  String get balance => 'Balance';

  @override
  String get comparedToPrevMonth => 'vs Last Month';

  @override
  String get categoryBreakdown => 'Spending by Category';

  @override
  String get expenseTrend => 'Spending Trend';

  @override
  String get monthlyInsight => 'This Month\'s Insights';

  @override
  String get weeklyInsight => 'This Week\'s Insights';

  @override
  String get yearlyInsight => 'This Year\'s Insights';

  @override
  String get categoryDetail => 'Category Details';

  @override
  String get topSpendingDay => 'Highest Spending Day';

  @override
  String get comparedToPrev => 'Change from Last Month';

  @override
  String get leastSpendingWeek => 'Lowest Spending Week';

  @override
  String get noReportDataTitle => 'No data yet';

  @override
  String get noReportDataDesc =>
      'Start recording expenses\nto see your analysis here';

  @override
  String get recordExpense => 'Record Expense';

  @override
  String get showMore => 'Show more';

  @override
  String transactionCount(int count) {
    return '$count transactions';
  }

  @override
  String dailyAverage(String amount) {
    return 'Avg ¥$amount/day';
  }

  @override
  String get notEnoughData => 'Not enough data yet. Keep recording!';

  @override
  String get increase => 'increase';

  @override
  String get decrease => 'decrease';

  @override
  String yearFormat(int year) {
    return '$year';
  }

  @override
  String monthFormat(int year, int month) {
    return '$month/$year';
  }

  @override
  String weekFormat(int month, int week) {
    return 'Week $week, $month';
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
    return '$category increased by $percent%';
  }

  @override
  String categoryDecreased(String category, int percent) {
    return '$category decreased by $percent%';
  }

  @override
  String nthWeek(int n) {
    return 'Week $n';
  }

  @override
  String get premiumDividerLabel => 'AI Analysis';

  @override
  String get premiumDividerLabelFree => 'AI Analysis (Clear only)';

  @override
  String get premiumBadge => 'Clear';

  @override
  String get aiInsightTitle => 'AI Analysis Report';

  @override
  String get clearComparisonTitle => 'Clear Comparison';

  @override
  String get clearComparisonOtherApp => 'In another app';

  @override
  String get clearComparisonReal => 'Hareru\'s real expense';

  @override
  String clearComparisonSaved(String amount) {
    return 'Hareru automatically cleared ¥$amount of confusion';
  }

  @override
  String get clearComparisonNoTransfer =>
      'No transfers in this period. All spending is real expense ✨';

  @override
  String get aiDiscoveriesTitle => 'Key Discoveries This Week';

  @override
  String aiDiscoveriesLastAnalysis(String date) {
    return 'Last analysis: $date';
  }

  @override
  String get aiSuggestionTitle => 'Next Week\'s Suggestion';

  @override
  String get aiSuggestionGoalButton => 'Set Goal';

  @override
  String get aiSuggestionProOnly => 'Available in Clear Pro';

  @override
  String get aiSuggestionEmpty =>
      'Record more expenses for personalized analysis! 📝';

  @override
  String get savingPotentialTitle => 'Hidden Saving Potential';

  @override
  String savingPotentialMonthly(String amount) {
    return '$amount/mo';
  }

  @override
  String savingPotentialYearly(String amount) {
    return '$amount/yr potential savings! 🎉';
  }

  @override
  String get savingPotentialDetail => 'View Details';

  @override
  String get healthScoreTitle => 'Spending Health Score';

  @override
  String get healthScoreBudget => 'Budget';

  @override
  String get healthScoreSaving => 'Savings';

  @override
  String get healthScoreBalance => 'Balance';

  @override
  String get healthScoreClear => 'Transfers';

  @override
  String get healthGradeExcellent => 'Excellent 🌟';

  @override
  String get healthGradeGood => 'Good 👍';

  @override
  String get healthGradeAverage => 'Average 📊';

  @override
  String get healthGradeCaution => 'Caution ⚠️';

  @override
  String get healthGradeDanger => 'Danger 🚨';

  @override
  String get blurMessageInsight =>
      'Check out your personalized\nAI spending report';

  @override
  String get blurMessageSaving => 'Discover your hidden\nsaving potential';

  @override
  String get blurMessageHealth => 'What\'s your spending\nhealth score?';

  @override
  String get blurCta => 'Start Clear';

  @override
  String get blurPrice => '¥380/mo';

  @override
  String get blurPremiumComingSoon =>
      'Premium features coming in a future update!';

  @override
  String get blurFutureUpdate => 'Coming in future update';
}
