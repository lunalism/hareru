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
}
