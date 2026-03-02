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
  String get savingsExample => '적립 NISA ¥33,333';

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
  String get guideCategoryDesc => '나만의 카테고리로 맞춤 설정';

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

  @override
  String get appearance => '외관';

  @override
  String get darkMode => '다크 모드';

  @override
  String get notification => '알림';

  @override
  String get recordReminder => '기록 리마인더';

  @override
  String get reminderTime => '리마인더 시간';

  @override
  String get data => '데이터';

  @override
  String get backupData => '데이터 백업';

  @override
  String get restoreData => '데이터 복원';

  @override
  String get resetData => '데이터 초기화';

  @override
  String get restoreConfirm => '현재 데이터가 덮어씌워집니다. 계속하시겠습니까?';

  @override
  String get resetConfirm => '모든 데이터가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get resetDoubleConfirm => '정말 초기화하시겠습니까? \'리셋\'을 입력해주세요';

  @override
  String get resetKeyword => '리셋';

  @override
  String get reset => '초기화';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get feedback => '피드백';

  @override
  String get rateApp => '앱 평가하기';

  @override
  String get rateAppLater => 'App Store 출시 후 이용 가능합니다';

  @override
  String get termsOfService => '이용약관';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String get version => '버전';

  @override
  String get reminderTitle => '가계부를 기록하세요!';

  @override
  String get reminderBody => '오늘의 지출을 기록하고 똑똑하게 관리하세요';

  @override
  String get enableNotificationInSettings => '설정 앱에서 알림을 허용해주세요';

  @override
  String get insurance => '보험';

  @override
  String get example => '예를 들면';

  @override
  String get unlockWithClear => 'Clear 플랜으로 해제';

  @override
  String get unlockWithClearPro => 'ClearPro 플랜으로 해제';

  @override
  String get premiumComingSoon => '프리미엄 기능은 곧 출시 예정입니다';

  @override
  String get noTermsFound => '해당하는 용어를 찾을 수 없습니다';

  @override
  String get interestRate => '금리';

  @override
  String get recommendedFor => '추천';

  @override
  String get allRecords => '전체 기록';

  @override
  String get recordDetail => '기록 상세';

  @override
  String get transactionType => '타입';

  @override
  String get transactionAmount => '금액';

  @override
  String get transactionDateTime => '날짜·시간';

  @override
  String get transactionMemo => '메모';

  @override
  String get noMemo => '메모 없음';

  @override
  String get editRecord => '편집하기';

  @override
  String get deleteRecord => '삭제하기';

  @override
  String get updateRecord => '수정하기';

  @override
  String get deleteConfirm => '이 기록을 삭제할까요?';

  @override
  String get deleteConfirmSub => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get recordDeleted => '기록을 삭제했습니다';

  @override
  String get recordUpdated => '기록을 수정했습니다';

  @override
  String get undoAction => '되돌리기';

  @override
  String get noRecordsEmpty => '기록이 없습니다';

  @override
  String get listView => '리스트';

  @override
  String get calendarView => '캘린더';

  @override
  String get dailyTotal => '합계';

  @override
  String get noRecordsForDay => '이 날의 기록이 없습니다';

  @override
  String get pdfReportTitle => '월간 PDF 리포트';

  @override
  String get pdfReportDescription => '이번 달 가계부를 PDF로 공유하세요';

  @override
  String get pdfShareButton => 'PDF 리포트 공유';

  @override
  String get pdfGenerating => 'PDF 생성 중...';

  @override
  String get pdfMonthlyReport => '월간 리포트';

  @override
  String get pdfApparentExpense => '겉보기 지출';

  @override
  String get pdfDifference => '차이';

  @override
  String pdfTransactionCount(int count) {
    return '$count건';
  }

  @override
  String pdfAndMore(int count) {
    return '외 $count건';
  }

  @override
  String pdfGeneratedOn(String date) {
    return '생성일: $date';
  }

  @override
  String get pdfBrandFooter => 'Hareru - 스마트 가계부';

  @override
  String get addExpense => '지출 추가';

  @override
  String get addIncome => '수입 추가';

  @override
  String get addTransfer => '이체 기록';

  @override
  String get editExpense => '지출 수정';

  @override
  String get editIncome => '수입 수정';

  @override
  String get editTransfer => '이체 수정';

  @override
  String get transferFrom => '출금처';

  @override
  String get transferTo => '입금처';

  @override
  String get addAccountTitle => '계좌 추가';

  @override
  String get addAccountStep1 => '아이콘';

  @override
  String get addAccountStep2 => '계좌 이름';

  @override
  String get addAccountHint => '예: UFJ 생활비, 라쿠텐 저축용';

  @override
  String deleteAccountConfirm(String name) {
    return '「$name」을(를) 삭제하시겠습니까?';
  }

  @override
  String get incomeDepositTo => '입금처';

  @override
  String get addAccountPrompt => '계좌를 추가해주세요';

  @override
  String get paymentMethod => '결제수단';

  @override
  String get creditCard => '신용카드';

  @override
  String get debitCard => '체크카드';

  @override
  String get cash => '현금';

  @override
  String get monthlyRecurring => '매월 반복';

  @override
  String get amountHint => '금액을 입력하세요';

  @override
  String get support => '지원';

  @override
  String get faq => '자주 묻는 질문';

  @override
  String get contactUs => '문의하기';

  @override
  String get contactSubject => '[Hareru] 문의';

  @override
  String contactBody(
    String version,
    String osVersion,
    String device,
    String locale,
  ) {
    return '【문의 내용】\n\n\n---\n앱 버전: $version\niOS: $osVersion\n단말기: $device\n언어: $locale';
  }

  @override
  String get contactFallback => '메일 앱을 찾을 수 없습니다. 주소를 복사해서 이용해주세요.';

  @override
  String get noInternet => '인터넷에 연결해주세요';

  @override
  String get contactDesc => '질문이나 피드백은 이메일로 보내주세요';

  @override
  String get contactCopy => '복사';

  @override
  String get contactOpenMail => '메일 열기';

  @override
  String get contactCopied => '복사되었습니다';

  @override
  String get otherSection => '기타';

  @override
  String get lastUpdatedDate => '최종 업데이트: 2026년 2월 28일';

  @override
  String get appCatchphrase => '복잡한 가계부를,\n깔끔하게 정리하다.';

  @override
  String get copyright => '© 2026 Lunalism';

  @override
  String get accountSection => '계정';

  @override
  String get login => '로그인';

  @override
  String get loginDescription => '로그인하면 다음 기능을 사용할 수 있습니다:';

  @override
  String get loginBenefitBank => '최신 은행 금리 비교';

  @override
  String get loginBenefitAI => 'AI 인사이트 (유료)';

  @override
  String get loginBenefitBackup => '데이터 클라우드 백업';

  @override
  String get signInWithApple => 'Apple로 로그인';

  @override
  String get signInWithGoogle => 'Google로 로그인';

  @override
  String get skipLogin => '건너뛰고 계속하기';

  @override
  String get loginSuccess => '로그인 완료';

  @override
  String get loginError => '로그인에 실패했습니다';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirm => '로그아웃하시겠습니까?';

  @override
  String get bankLoadError => '데이터를 불러오지 못했습니다';

  @override
  String get bankRetry => '다시 시도';

  @override
  String get dictionaryTitle => '금융사전';

  @override
  String get searchPlaceholder => '용어 검색...';

  @override
  String get categoryAll => '전체';

  @override
  String get categoryBanking => '은행';

  @override
  String get categoryHousehold => '가계';

  @override
  String get categoryTax => '세금';

  @override
  String get categoryInsurance => '보험';

  @override
  String get categorySavings => '저축';

  @override
  String get categoryLoan => '대출';

  @override
  String get categorySystem => '제도';

  @override
  String get categoryPayment => '결제';

  @override
  String get sectionExplanation => '설명';

  @override
  String get sectionExample => '예를 들면';

  @override
  String get sectionRelated => '관련 용어';

  @override
  String get aiAskAboutMoney => 'AI에게 돈에 대해 물어보세요';

  @override
  String get aiPersonalizedAdvice => '내 가계에 맞는 맞춤 조언';

  @override
  String get aiLearnMore => '더 자세히 알고 싶으세요?';

  @override
  String get aiExplainForYou => 'AI가 내 상황에 맞춰 설명해줘요';

  @override
  String get webviewLoadError => '페이지를 불러올 수 없습니다';

  @override
  String get retry => '재시도';

  @override
  String get pdfOverBudget => '초과';

  @override
  String get shareReportSubject => 'Hareru 리포트';

  @override
  String get pdfError => '오류';

  @override
  String get notificationChannelName => '매일 알림';

  @override
  String get notificationChannelDesc => '매일 지출 기록 알림';

  @override
  String get paywallTitle => 'Hareru를 더 편리하게';

  @override
  String get paywallMonthly => '월간';

  @override
  String get paywallYearly => '연간';

  @override
  String get paywallYearlyBadge => '추천';

  @override
  String get paywallSaveMonths => '2개월 절약!';

  @override
  String get paywallClearTitle => 'Clear';

  @override
  String get paywallClearProTitle => 'ClearPro';

  @override
  String get paywallClearCta => 'Clear 시작하기';

  @override
  String get paywallClearProCta => 'ClearPro 시작하기';

  @override
  String get paywallRestore => '구매 복원';

  @override
  String get paywallContinueFree => '무료로 계속하기';

  @override
  String get paywallTerms => '이용약관';

  @override
  String get paywallPrivacy => '개인정보처리방침';

  @override
  String get featureNoAds => '광고 없음';

  @override
  String get featureAiInsight => 'AI 분석';

  @override
  String get featureSavingSim => '절약 시뮬레이션';

  @override
  String get featureCsvExport => 'CSV 내보내기';

  @override
  String get featureAiCoaching => 'AI 코칭';

  @override
  String get featurePdfReport => 'PDF 월간 리포트';

  @override
  String get featureSavingGoal => '저축 목표 관리';

  @override
  String get featurePrioritySupport => '우선 지원';

  @override
  String get settingsSubscription => '구독';

  @override
  String get settingsCurrentPlan => '현재 플랜';

  @override
  String get settingsRestorePurchase => '구매 복원';

  @override
  String get settingsManageSubscription => '구독 관리';

  @override
  String get lockClearRequired => 'Clear에서 이용 가능';

  @override
  String get lockClearProRequired => 'ClearPro에서 이용 가능';

  @override
  String get lockUpgrade => '업그레이드';

  @override
  String get purchaseSuccess => '구매가 완료되었습니다!';

  @override
  String get purchaseRestored => '구매를 복원했습니다';

  @override
  String get purchaseError => '구매에 실패했습니다';

  @override
  String get purchaseNotAvailable => '현재 구매할 수 없습니다';

  @override
  String get adPlaceholder => '광고 — Clear에서 숨길 수 있습니다';

  @override
  String get purchaseNotAvailableDesc =>
      '현재 앱 내 구매를 이용할 수 없습니다. 나중에 다시 시도해주세요.';

  @override
  String get restoreNoPurchase => '복원할 구매가 없습니다';

  @override
  String subscriptionExpiresOn(String date) {
    return '유효기간: $date';
  }

  @override
  String get planFree => 'Free';

  @override
  String get planClear => 'Clear';

  @override
  String get planClearPro => 'ClearPro';
}
