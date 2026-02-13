// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Let\'s get started!';

  @override
  String get onboarding1Title => 'See only what\nyou really spent';

  @override
  String get onboarding1Desc =>
      'Transfers between accounts aren\'t expenses.\nHareru shows your real spending only.';

  @override
  String get onboarding2Title => 'Transfers sorted\nautomatically';

  @override
  String get onboarding2Desc =>
      'Expenses, transfers, and savings\nare classified automatically. No more confusion.';

  @override
  String get onboarding3Title => 'Done in\n3 seconds';

  @override
  String get onboarding3Desc =>
      'Amount → one tap on category → done.\nThe simplest budget app ever.';

  @override
  String get otherApps => 'Other apps';

  @override
  String get looksLikeExpense => 'Looks like spending 😰';

  @override
  String get realExpense => 'Real spending ✨';

  @override
  String get food => 'Food';

  @override
  String get transport => 'Transport';

  @override
  String get transfer => 'Transfer';

  @override
  String get transferAlert => 'Transfer ⚠️';

  @override
  String get savings => 'Savings';

  @override
  String get savingsAlert => 'Savings ⚠️';

  @override
  String get expense => 'Expense';

  @override
  String get auto => 'Auto';

  @override
  String get conveniStore => 'Convenience';

  @override
  String get amountInput => 'Amount';

  @override
  String get category => 'Category';

  @override
  String get done => 'Done!';

  @override
  String get cafe => 'Cafe';

  @override
  String get transferExample => '→ Savings ¥30,000';

  @override
  String get savingsExample => 'NISA ¥33,333';

  @override
  String get expenseExample => 'Convenience ¥850';

  @override
  String get homeTab => 'Home';

  @override
  String get reportTab => 'Report';

  @override
  String get dictionaryTab => 'Dictionary';

  @override
  String get settingsTab => 'Settings';

  @override
  String monthFormat(int year, int month) {
    return '$month/$year';
  }

  @override
  String get monthlyRealExpense => 'Real spending this month';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get balance => 'Balance';

  @override
  String get budget => 'Budget';

  @override
  String budgetUsed(int percent) {
    return '$percent% of budget used';
  }

  @override
  String budgetRemaining(String amount) {
    return '¥$amount remaining';
  }

  @override
  String get recentRecords => 'Recent Records';

  @override
  String get seeAll => 'See all';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get aiInsightTitle => 'AI Insight';

  @override
  String get aiInsightMessage =>
      'Your food expenses decreased by 12% compared to last month! Keep it up.';

  @override
  String get emptyStateTitle => 'No records yet';

  @override
  String get emptyStateDesc =>
      'Tap the + button below\nto add your first record';

  @override
  String get guideExpenseTitle => 'Record Expenses';

  @override
  String get guideExpenseDesc => 'Easily track your daily spending';

  @override
  String get guideBudgetTitle => 'Set Budget';

  @override
  String get guideBudgetDesc => 'Set and manage monthly budgets';

  @override
  String get guideCategoryTitle => 'Manage Categories';

  @override
  String get guideCategoryDesc => 'Customize to your preferences';

  @override
  String get preparingFeature => 'Coming soon';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageTitle => 'Language';

  @override
  String get catFood => 'Food';

  @override
  String get catTransport => 'Transport';

  @override
  String get catDaily => 'Daily';

  @override
  String get catCafe => 'Cafe';

  @override
  String get catHobby => 'Hobby';

  @override
  String get catClothing => 'Clothing';

  @override
  String get catMedical => 'Medical';

  @override
  String get catPhone => 'Phone';

  @override
  String get catHousing => 'Housing';

  @override
  String get catSocial => 'Social';

  @override
  String get catEducation => 'Education';

  @override
  String get catOther => 'Other';

  @override
  String get catBankTransfer => 'Bank Transfer';

  @override
  String get catCard => 'Card Payment';

  @override
  String get catEMoney => 'E-Money';

  @override
  String get catTransferOther => 'Other Transfer';

  @override
  String get catSavings => 'Savings';

  @override
  String get catInvestment => 'Investment';

  @override
  String get catGoal => 'Goal Savings';

  @override
  String get catSavingsOther => 'Other Savings';

  @override
  String get memoPlaceholder => 'Add memo (optional)';

  @override
  String get saveRecord => 'Save';

  @override
  String get recordSaved => 'Record saved!';

  @override
  String get inputAmount => 'Enter amount';

  @override
  String get income => 'Income';

  @override
  String get salary => 'Salary';

  @override
  String get sideJob => 'Side Job';

  @override
  String get bonus => 'Bonus';

  @override
  String get allowance => 'Allowance';

  @override
  String get investmentReturn => 'Investment';

  @override
  String get fleaMarket => 'Flea Market';

  @override
  String get extraIncome => 'Extra Income';

  @override
  String get otherIncome => 'Other';

  @override
  String get setBudget => 'Set your budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get setBudgetTitle => 'Set Monthly Budget';

  @override
  String remainingBudget(String amount) {
    return '$amount remaining';
  }

  @override
  String overBudget(String amount) {
    return '$amount over budget';
  }

  @override
  String get budgetSettings => 'Budget Settings';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';
}
