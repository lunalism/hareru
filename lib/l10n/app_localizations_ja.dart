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
  String get realExpense => '本当の支出 ✨';

  @override
  String get food => '食費';

  @override
  String get transport => '交通費';

  @override
  String get transfer => '振替';

  @override
  String get transferAlert => '振込 ⚠️';

  @override
  String get savings => '貯蓄';

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
}
