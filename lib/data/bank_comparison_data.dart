class BankComparison {
  final String id;
  final String emoji;
  final String nameJa;
  final String nameKo;
  final String nameEn;
  final String interestRate;
  final String minAmount;
  final String period;
  final String featureJa;
  final String featureKo;
  final String featureEn;
  final String recommendJa;
  final String recommendKo;
  final String recommendEn;
  final int sortOrder;

  const BankComparison({
    required this.id,
    required this.emoji,
    required this.nameJa,
    required this.nameKo,
    required this.nameEn,
    required this.interestRate,
    required this.minAmount,
    required this.period,
    required this.featureJa,
    required this.featureKo,
    required this.featureEn,
    required this.recommendJa,
    required this.recommendKo,
    required this.recommendEn,
    required this.sortOrder,
  });

  String name(String langCode) => switch (langCode) {
        'ko' => nameKo,
        'en' => nameEn,
        _ => nameJa,
      };

  String feature(String langCode) => switch (langCode) {
        'ko' => featureKo,
        'en' => featureEn,
        _ => featureJa,
      };

  String recommend(String langCode) => switch (langCode) {
        'ko' => recommendKo,
        'en' => recommendEn,
        _ => recommendJa,
      };
}

const List<BankComparison> bankComparisons = [
  BankComparison(
    id: 'aeon',
    emoji: '\u{1F3EA}',
    nameJa: 'イオン銀行',
    nameKo: '이온은행',
    nameEn: 'AEON Bank',
    interestRate: '年0.15%',
    minAmount: '500円〜',
    period: '6ヶ月〜40年',
    featureJa: '年6回増額OK、他行自動入金対応、イオングループ特典あり',
    featureKo: '연 6회 증액 가능, 타행 자동입금 대응, 이온그룹 특전',
    featureEn: '6x yearly bonus deposits, auto-transfer from other banks, AEON Group perks',
    recommendJa: '少額から始めたい人、イオンをよく使う人',
    recommendKo: '소액부터 시작하고 싶은 사람, 이온을 자주 이용하는 사람',
    recommendEn: 'Start small, frequent AEON shoppers',
    sortOrder: 1,
  ),
  BankComparison(
    id: 'sony',
    emoji: '\u{1F310}',
    nameJa: 'ソニー銀行',
    nameKo: '소니은행',
    nameEn: 'Sony Bank',
    interestRate: '年0.20%',
    minAmount: '1,000円〜',
    period: '1ヶ月〜10年',
    featureJa: 'ネット完結、外貨にも強い、ボーナス増額年2回',
    featureKo: '온라인 완결, 외화에도 강함, 보너스 증액 연 2회',
    featureEn: 'Fully online, strong foreign currency, 2x yearly bonus',
    recommendJa: 'ネット銀行派、外貨にも興味がある人',
    recommendKo: '인터넷 뱅킹파, 외화에도 관심 있는 사람',
    recommendEn: 'Online banking fans, interested in foreign currency',
    sortOrder: 2,
  ),
  BankComparison(
    id: 'yucho',
    emoji: '\u{1F3E3}',
    nameJa: 'ゆうちょ銀行',
    nameKo: '유초은행 (우체국)',
    nameEn: 'Japan Post Bank',
    interestRate: '年0.125%',
    minAmount: '1,000円〜',
    period: '3ヶ月〜5年',
    featureJa: '全国どこでも窓口あり、外国人対応◎、3年以上は半年複利',
    featureKo: '전국 어디서나 창구 이용 가능, 외국인 대응 우수, 3년 이상 반년복리',
    featureEn: 'Branches everywhere, foreigner-friendly, semi-annual compound interest for 3yr+',
    recommendJa: '窓口で相談したい人、外国人の方',
    recommendKo: '창구에서 상담받고 싶은 사람, 외국인',
    recommendEn: 'Prefer in-person banking, foreigners in Japan',
    sortOrder: 3,
  ),
  BankComparison(
    id: 'smbc',
    emoji: '\u{1F3DB}\uFE0F',
    nameJa: '三井住友銀行',
    nameKo: '미쓰이스미토모은행',
    nameEn: 'SMBC',
    interestRate: '年0.125%',
    minAmount: '1,000円〜',
    period: '1年〜',
    featureJa: '《りぼん》ブランド、ATMやアプリ充実、給与口座との連携◎',
    featureKo: '《리본》 브랜드, ATM·앱 충실, 급여 계좌 연동 우수',
    featureEn: 'Ribon brand, extensive ATMs & app, great salary account integration',
    recommendJa: '大手銀行の安心感がほしい人、給与口座がSMBCの人',
    recommendKo: '대형은행의 안심감을 원하는 사람, 급여계좌가 SMBC인 사람',
    recommendEn: 'Trust major banks, salary account at SMBC',
    sortOrder: 4,
  ),
  BankComparison(
    id: 'mufg',
    emoji: '\u{1F534}',
    nameJa: '三菱UFJ銀行',
    nameKo: '미쓰비시UFJ은행',
    nameEn: 'MUFG Bank',
    interestRate: '年0.125%',
    minAmount: '1,000円〜',
    period: '1年〜',
    featureJa: '自動つみたて定期、ATM数日本最多、Pontaポイント連携',
    featureKo: '자동적립정기, ATM 수 일본 최다, Ponta포인트 연동',
    featureEn: 'Auto accumulation, most ATMs in Japan, Ponta points',
    recommendJa: 'ATMの多さ重視、Pontaポイントを貯めている人',
    recommendKo: 'ATM 수 중시, Ponta 포인트를 모으는 사람',
    recommendEn: 'Value ATM access, Ponta point collectors',
    sortOrder: 5,
  ),
  BankComparison(
    id: 'rakuten',
    emoji: '\u{1F7E1}',
    nameJa: '楽天銀行',
    nameKo: '라쿠텐은행',
    nameEn: 'Rakuten Bank',
    interestRate: '年0.18%',
    minAmount: '1,000円〜',
    period: '6ヶ月〜',
    featureJa: '楽天ポイント連携、マネーブリッジで普通預金金利UP、アプリ使いやすい',
    featureKo: '라쿠텐포인트 연동, 머니브릿지로 보통예금 금리UP, 앱 사용 편리',
    featureEn: 'Rakuten Points, Money Bridge boosts savings rate, great app UX',
    recommendJa: '楽天経済圏の人、アプリで完結したい人',
    recommendKo: '라쿠텐 경제권 사람, 앱으로 완결하고 싶은 사람',
    recommendEn: 'Rakuten ecosystem users, app-first banking',
    sortOrder: 6,
  ),
];
