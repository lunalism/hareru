// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작하기!';

  @override
  String get onboarding1Title => '진짜 쓴 돈만\n보여줍니다';

  @override
  String get onboarding1Desc => '계좌 간 이체는 지출이 아닙니다.\nHareru는 \'진짜 지출\'만 보여줍니다.';

  @override
  String get onboarding2Title => '이체는\n자동으로 구분';

  @override
  String get onboarding2Desc => '지출・이체・저축을 자동 분류.\n더 이상 헷갈리지 않습니다.';

  @override
  String get onboarding3Title => '3초면\n입력 끝';

  @override
  String get onboarding3Desc => '금액 → 카테고리 1탭 → 끝.\n세상에서 가장 간단한 가계부.';

  @override
  String get otherApps => '다른 앱';

  @override
  String get looksLikeExpense => '지출로 보임 😰';

  @override
  String get realExpense => '진짜 지출 ✨';

  @override
  String get food => '식비';

  @override
  String get transport => '교통비';

  @override
  String get transfer => '이체';

  @override
  String get transferAlert => '이체 ⚠️';

  @override
  String get savings => '저축';

  @override
  String get savingsAlert => '저축 ⚠️';

  @override
  String get expense => '지출';

  @override
  String get auto => '자동';

  @override
  String get conveniStore => '편의점';

  @override
  String get amountInput => '금액 입력';

  @override
  String get category => '카테고리';

  @override
  String get done => '완료!';

  @override
  String get cafe => '카페';

  @override
  String get transferExample => '→ 저축계좌 ¥30,000';

  @override
  String get savingsExample => '적립NISA ¥33,333';

  @override
  String get expenseExample => '편의점 ¥850';

  @override
  String get homeTab => '홈';

  @override
  String get reportTab => '리포트';

  @override
  String get dictionaryTab => '사전';

  @override
  String get settingsTab => '설정';

  @override
  String monthFormat(int year, int month) {
    return '$year년 $month월';
  }

  @override
  String get totalExpense => '총 지출';

  @override
  String get totalIncome => '총 수입';

  @override
  String get balance => '잔액';

  @override
  String get budget => '예산';

  @override
  String budgetUsed(int percent) {
    return '예산의 $percent% 사용';
  }

  @override
  String budgetRemaining(String amount) {
    return '남은 금액 ¥$amount';
  }

  @override
  String get recentRecords => '최근 기록';

  @override
  String get seeAll => '모두 보기';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get aiInsightTitle => 'AI 인사이트';

  @override
  String get aiInsightMessage => '지난달보다 식비가 12% 줄었어요! 이대로 계속해봐요.';

  @override
  String get emptyStateTitle => '아직 기록이 없어요';

  @override
  String get emptyStateDesc => '아래 + 버튼으로\n첫 번째 기록을 추가해보세요';

  @override
  String get guideExpenseTitle => '지출 기록';

  @override
  String get guideExpenseDesc => '일상 지출을 간편하게 기록';

  @override
  String get guideBudgetTitle => '예산 설정';

  @override
  String get guideBudgetDesc => '월별 예산을 설정하고 관리';

  @override
  String get guideCategoryTitle => '카테고리 관리';

  @override
  String get guideCategoryDesc => '내 취향대로 커스터마이즈';

  @override
  String get preparingFeature => '준비 중';
}
