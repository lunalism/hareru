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
  String get realExpense => '진짜 지출';

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
  String get monthlyRealExpense => '이번 달 진짜 지출';

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

  @override
  String get settingsTitle => '설정';

  @override
  String get languageTitle => '언어';

  @override
  String get catFood => '식비';

  @override
  String get catTransport => '교통비';

  @override
  String get catDaily => '생활용품';

  @override
  String get catCafe => '카페';

  @override
  String get catHobby => '취미';

  @override
  String get catClothing => '의류';

  @override
  String get catMedical => '의료';

  @override
  String get catPhone => '통신비';

  @override
  String get catHousing => '주거비';

  @override
  String get catSocial => '교제비';

  @override
  String get catEducation => '교육';

  @override
  String get catOther => '기타';

  @override
  String get catBankTransfer => '은행이체';

  @override
  String get catCard => '카드결제';

  @override
  String get catEMoney => '전자머니';

  @override
  String get catTransferOther => '기타이체';

  @override
  String get catSavings => '정기저축';

  @override
  String get catInvestment => '투자';

  @override
  String get catGoal => '목표저축';

  @override
  String get catSavingsOther => '기타저축';

  @override
  String get memoPlaceholder => '메모 입력 (선택)';

  @override
  String get saveRecord => '기록하기';

  @override
  String get recordSaved => '기록했어요!';

  @override
  String get inputAmount => '금액을 입력하세요';

  @override
  String get income => '수입';

  @override
  String get salary => '급여';

  @override
  String get sideJob => '부업';

  @override
  String get bonus => '보너스';

  @override
  String get allowance => '용돈';

  @override
  String get investmentReturn => '투자수익';

  @override
  String get fleaMarket => '중고거래';

  @override
  String get extraIncome => '임시수입';

  @override
  String get otherIncome => '기타';

  @override
  String get setBudget => '예산 설정하기';

  @override
  String get monthlyBudget => '월 예산';

  @override
  String get setBudgetTitle => '월 예산 설정';

  @override
  String remainingBudget(String amount) {
    return '앞으로 $amount 쓸 수 있어요';
  }

  @override
  String overBudget(String amount) {
    return '$amount 초과했어요';
  }

  @override
  String get budgetSettings => '예산 설정';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get editBudget => '예산 수정';

  @override
  String get easySetup => '간단 초기 설정';

  @override
  String get setupDescription => '맞춤 가계부 관리를 위해\n2가지만 알려주세요';

  @override
  String get payDay => '급여일';

  @override
  String payDayLabel(String day) {
    return '매월 $day일';
  }

  @override
  String get payDayEndOfMonth => '말일';

  @override
  String get setPayDay => '급여일 설정';

  @override
  String get getStarted => '시작하기';

  @override
  String get setupLater => '나중에 설정하기';

  @override
  String get everyMonth => '매월';

  @override
  String get catUtility => '공과금';

  @override
  String get categoryManagement => '카테고리 관리';

  @override
  String get addCategory => '카테고리 추가';

  @override
  String get editCategory => '카테고리 편집';

  @override
  String get deleteCategory => '카테고리 삭제';

  @override
  String get categoryName => '카테고리 이름';

  @override
  String get categoryEmoji => '아이콘';

  @override
  String get cannotDeleteDefault => '기본 카테고리는 삭제할 수 없습니다';

  @override
  String deleteCategoryConfirm(int count) {
    return '이 카테고리를 삭제하면 $count건의 기록이 \'기타\'로 이동합니다';
  }

  @override
  String get add => '추가';

  @override
  String payDayEveryMonth(String day) {
    return '매월 $day일';
  }

  @override
  String get remaining => '잔액';

  @override
  String get savingsRate => '저축률';

  @override
  String get showAll => '전체 보기';

  @override
  String get showLess => '접기';

  @override
  String get budgetNotSet => '예산을 설정하면 진행률이 표시됩니다';

  @override
  String get notIncludedInReal => '진짜 지출에 포함되지 않습니다';

  @override
  String get monthlyInsight => '이번 달 요약';

  @override
  String get noRecordsYet => '아직 기록이 없습니다';

  @override
  String get noRecordsDescription => '지출을 기록하면 리포트가 표시됩니다';

  @override
  String get startRecording => '기록하기';

  @override
  String savedComparedLastMonth(String amount) {
    return '지난달보다 $amount 절약했어요!';
  }

  @override
  String spentMoreThanLastMonth(String amount) {
    return '지난달보다 $amount 더 사용했어요';
  }

  @override
  String topCategory(String category, String percent) {
    return '이번 달은 $category이(가) 가장 많아 전체의 $percent%입니다';
  }

  @override
  String get withinBudget => '예산 안에서 잘 관리하고 있어요!';

  @override
  String overBudgetReport(String amount) {
    return '예산을 $amount 초과했어요';
  }

  @override
  String get needMoreData => '기록이 늘어나면 AI가 조언을 드려요';
}
