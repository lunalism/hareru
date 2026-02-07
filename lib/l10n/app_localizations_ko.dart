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
}
