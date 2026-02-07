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
}
