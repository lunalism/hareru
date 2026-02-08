// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Hareru';

  @override
  String get settings => '설정';

  @override
  String get household => '가계부';

  @override
  String get monthlyBudget => '월 예산';

  @override
  String get categoryManage => '카테고리 관리';

  @override
  String get startDayOfWeek => '주 시작 요일';

  @override
  String get autoExcludeTransfer => '이체 자동 제외';

  @override
  String get autoExcludeTransferDesc => '계좌 간 이체를 지출에서 자동으로 제외합니다';

  @override
  String get security => '보안';

  @override
  String get appLock => '앱 잠금';

  @override
  String get appLockDesc => 'Face ID 또는 패스코드로 잠금';

  @override
  String get icloudBackup => 'iCloud 백업';

  @override
  String get app => '앱';

  @override
  String get screenMode => '화면 모드';

  @override
  String get inputReminder => '입력 리마인더';

  @override
  String get inputReminderDesc => '매일 설정한 시간에 알림을 보내드려요';

  @override
  String get language => '언어';

  @override
  String get etc => '기타';

  @override
  String get sendFeedback => '의견 보내기';

  @override
  String get appInfo => '앱 정보';

  @override
  String get madeWith => 'Made with 💙';

  @override
  String get comingSoon => 'coming soon';

  @override
  String get preparingFeature => '준비 중인 기능이에요';

  @override
  String get monthlyBudgetSetting => '월 예산 설정';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get add => '추가';

  @override
  String get delete => '삭제';

  @override
  String get monday => '월요일';

  @override
  String get sunday => '일요일';

  @override
  String get system => '시스템';

  @override
  String get light => '라이트';

  @override
  String get dark => '다크';

  @override
  String get korean => '한국어';

  @override
  String get japanese => '日本語';

  @override
  String get english => 'English';

  @override
  String monthExpense(int month) {
    return '$month월 지출';
  }

  @override
  String comparedLastMonthDown(String amount) {
    return '지난달보다 ¥$amount ↓ 절약! 🎉';
  }

  @override
  String comparedLastMonthUp(String amount) {
    return '지난달보다 ¥$amount ↑ 과소비 주의 ⚠️';
  }

  @override
  String budget(String amount) {
    return '예산 ¥$amount';
  }

  @override
  String get todayExpense => '오늘 지출';

  @override
  String get total => '합계';

  @override
  String get thisWeekExpense => '이번 주 지출';

  @override
  String get today => '오늘';

  @override
  String get noExpenseToday => '오늘은 아직 지출이 없어요';

  @override
  String get home => '홈';

  @override
  String get report => '리포트';

  @override
  String get input => '입력';

  @override
  String get dictionary => '사전';

  @override
  String get categoryFood => '식비';

  @override
  String get categoryTransport => '교통';

  @override
  String get categoryShopping => '쇼핑';

  @override
  String get categoryCafe => '카페';

  @override
  String get categoryEntertainment => '여가';

  @override
  String get categoryMedical => '의료';

  @override
  String get categoryTransfer => '이체';

  @override
  String get categoryOther => '기타';

  @override
  String get savingsTransfer => '저축계좌 이체';

  @override
  String get lunch => '점심';

  @override
  String get transportFee => '교통비';

  @override
  String get coffee => '커피';

  @override
  String get mon => '월';

  @override
  String get tue => '화';

  @override
  String get wed => '수';

  @override
  String get thu => '목';

  @override
  String get fri => '금';

  @override
  String get sat => '토';

  @override
  String get sun => '일';

  @override
  String get categoryAdd => '카테고리 추가';

  @override
  String get categoryName => '카테고리명';

  @override
  String get notificationTime => '알림 시간';

  @override
  String get receiptScan => '영수증 스캔';

  @override
  String get manualInput => '직접 입력';

  @override
  String get receiptScanDesc => '카메라로 영수증을 촬영해요';

  @override
  String get manualInputDesc => '금액과 카테고리를 직접 입력해요';

  @override
  String get expense => '지출';

  @override
  String get income => '수입';

  @override
  String get transfer => '이체';

  @override
  String get enterAmount => '금액 입력';

  @override
  String get selectCategory => '카테고리 선택';

  @override
  String get addMemo => '메모 추가';

  @override
  String get date => '날짜';

  @override
  String get memo => '메모';

  @override
  String get fromAccount => '출금 계좌';

  @override
  String get toAccount => '입금 계좌';

  @override
  String get categorySalary => '급여';

  @override
  String get categoryAllowance => '용돈';

  @override
  String get categorySidejob => '부업';

  @override
  String get categoryInvestment => '투자';

  @override
  String get receiptScanTitle => '영수증 스캔';

  @override
  String get receiptScanComingSoon => '준비 중인 기능이에요';

  @override
  String get noTransactions => '아직 거래 내역이 없어요';

  @override
  String get addFirstTransaction => '+ 버튼을 눌러 첫 거래를 추가해보세요';

  @override
  String get inputMethod => '입력 방법';

  @override
  String get amount => '금액';

  @override
  String get savedSuccess => '저장되었습니다';

  @override
  String get reportTitle => '리포트';

  @override
  String get periodWeekly => '주간';

  @override
  String get periodMonthly => '월간';

  @override
  String get periodYearly => '연간';

  @override
  String get realExpense => '실질 지출';

  @override
  String transferExcluded(String amount) {
    return '이체 ¥$amount 제외';
  }

  @override
  String get balance => '잔액';

  @override
  String get comparedToPrevMonth => '전월 대비';

  @override
  String get categoryBreakdown => '카테고리별 지출';

  @override
  String get expenseTrend => '지출 추이';

  @override
  String get monthlyInsight => '이번 달 인사이트';

  @override
  String get weeklyInsight => '이번 주 인사이트';

  @override
  String get yearlyInsight => '올해 인사이트';

  @override
  String get categoryDetail => '카테고리 상세';

  @override
  String get topSpendingDay => '가장 많이 쓴 날';

  @override
  String get comparedToPrev => '전월 대비 변화';

  @override
  String get leastSpendingWeek => '가장 적게 쓴 주';

  @override
  String get noReportDataTitle => '아직 데이터가 없어요';

  @override
  String get noReportDataDesc => '지출을 기록하면\n여기서 분석을 볼 수 있어요';

  @override
  String get recordExpense => '지출 기록하기';

  @override
  String get showMore => '더 보기';

  @override
  String transactionCount(int count) {
    return '$count건';
  }

  @override
  String dailyAverage(String amount) {
    return '평균 ¥$amount/일';
  }

  @override
  String get notEnoughData => '아직 데이터가 충분하지 않아요. 기록을 계속해보세요!';

  @override
  String get increase => '증가';

  @override
  String get decrease => '감소';

  @override
  String yearFormat(int year) {
    return '$year년';
  }

  @override
  String monthFormat(int year, int month) {
    return '$year년 $month월';
  }

  @override
  String weekFormat(int month, int week) {
    return '$month월 $week주차';
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
    return '$category가 $percent% 증가했어요';
  }

  @override
  String categoryDecreased(String category, int percent) {
    return '$category가 $percent% 감소했어요';
  }

  @override
  String nthWeek(int n) {
    return '$n째 주';
  }

  @override
  String get premiumDividerLabel => 'AI 분석';

  @override
  String get premiumDividerLabelFree => 'AI 분석 (Clear 전용)';

  @override
  String get premiumBadge => 'Clear';

  @override
  String get aiInsightTitle => 'AI 분석 리포트';

  @override
  String get clearComparisonTitle => '클리어 비교';

  @override
  String get clearComparisonOtherApp => '다른 앱이었다면';

  @override
  String get clearComparisonReal => 'Hareru의 실질 지출';

  @override
  String clearComparisonSaved(String amount) {
    return 'Hareru가 ¥$amount의 혼란을 자동으로 정리했어요';
  }

  @override
  String get clearComparisonNoTransfer => '이번 기간에는 이체가 없어요. 모든 지출이 실질 지출이에요 ✨';

  @override
  String get aiDiscoveriesTitle => '이번 주 핵심 발견';

  @override
  String aiDiscoveriesLastAnalysis(String date) {
    return '마지막 분석: $date';
  }

  @override
  String get aiSuggestionTitle => '다음 주 제안';

  @override
  String get aiSuggestionGoalButton => '목표 설정하기';

  @override
  String get aiSuggestionProOnly => 'Clear Pro에서 사용 가능';

  @override
  String get aiSuggestionEmpty => '지출 기록을 더 모으면 맞춤 분석을 해드릴게요! 📝';

  @override
  String get savingPotentialTitle => '숨은 절약 가능 금액';

  @override
  String savingPotentialMonthly(String amount) {
    return '월 $amount';
  }

  @override
  String savingPotentialYearly(String amount) {
    return '연 $amount 절약 가능! 🎉';
  }

  @override
  String get savingPotentialDetail => '상세 보기';

  @override
  String get healthScoreTitle => '지출 건강도';

  @override
  String get healthScoreBudget => '예산 준수';

  @override
  String get healthScoreSaving => '절약 노력';

  @override
  String get healthScoreBalance => '지출 균형';

  @override
  String get healthScoreClear => '이체 정리';

  @override
  String get healthGradeExcellent => '훌륭해요 🌟';

  @override
  String get healthGradeGood => '양호 👍';

  @override
  String get healthGradeAverage => '보통 📊';

  @override
  String get healthGradeCaution => '주의 ⚠️';

  @override
  String get healthGradeDanger => '위험 🚨';

  @override
  String get blurMessageInsight => 'AI가 분석한 당신만의\n지출 리포트를 확인해보세요';

  @override
  String get blurMessageSaving => '숨어있는 절약 가능\n금액을 발견해보세요';

  @override
  String get blurMessageHealth => '나의 지출 건강 점수는\n몇 점일까요?';

  @override
  String get blurCta => 'Clear 시작하기';

  @override
  String get blurPrice => '월 ¥380';

  @override
  String get blurPremiumComingSoon => '프리미엄 기능은 향후 업데이트 예정이에요!';

  @override
  String get blurFutureUpdate => '향후 업데이트 예정';

  @override
  String get account => '계정';

  @override
  String get loginSubtitle => '로그인하면 데이터가 안전하게 백업됩니다';

  @override
  String get loginWithApple => 'Apple로 로그인';

  @override
  String get loginWithGoogle => 'Google로 로그인';

  @override
  String get loginSkip => '로그인하지 않고 시작';

  @override
  String get loginSkipNote => '나중에 설정에서 로그인할 수 있어요';

  @override
  String get loginError => '로그인에 실패했어요. 다시 시도해주세요.';

  @override
  String get notLoggedIn => '미로그인';

  @override
  String get loginPrompt => '로그인하여 데이터를 백업하세요';

  @override
  String loggedInWith(String provider) {
    return '$provider로 로그인 중';
  }

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirm => '로그아웃';

  @override
  String get logoutConfirmDesc => '로그아웃해도 기기의 데이터는 유지됩니다.';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountConfirm => '정말 계정을 삭제하시겠어요?';

  @override
  String get deleteAccountWarning =>
      '클라우드에 저장된 모든 데이터가 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteAccountFinal => '계정을 영구 삭제';

  @override
  String get migrationPrompt => '기존 데이터를 클라우드에 동기화할까요?';

  @override
  String get migrationSync => '동기화';

  @override
  String get migrationLater => '나중에';

  @override
  String get migrationInProgress => '데이터를 동기화하는 중...';

  @override
  String get migrationComplete => '동기화 완료!';

  @override
  String migrationCount(int count) {
    return '$count건의 데이터를 동기화했어요';
  }
}
