import 'package:hareru/models/financial_guide.dart';

const List<FinancialGuide> financialGuidesData = [
  // ============================================================
  // Category 1: daily (日常の節約)
  // ============================================================

  // 1. daily_01
  FinancialGuide(
    id: 'daily_01',
    icon: '🛒',
    category: 'daily',
    titleJa: 'コンビニ vs スーパー：月1万円の差が出る買い物術',
    titleKo: '편의점 vs 슈퍼마켓: 월 1만엔 차이가 나는 장보기 기술',
    titleEn: 'Convenience Store vs Supermarket: Shopping Tips That Save ¥10,000/Month',
    bodyJa:
        'コンビニのおにぎりは約150円、スーパーなら100円前後。'
        '毎日のちょっとした買い物の積み重ねで、月に約1万円もの差が出ることがあります。'
        'まずは週末にスーパーでまとめ買いする習慣をつけてみましょう。'
        'お惣菜も閉店前の割引タイムを狙うと、食費がぐっと抑えられますよ。'
        'Hareruで食費の推移を記録して、変化を実感してみてくださいね。',
    bodyKo:
        '편의점 주먹밥은 약 150엔, 슈퍼에서는 100엔 전후입니다. '
        '매일의 작은 지출이 쌓이면 한 달에 약 1만엔이나 차이가 날 수 있어요. '
        '먼저 주말에 슈퍼에서 한꺼번에 장을 보는 습관을 들여보세요. '
        '반찬도 폐점 전 할인 시간을 노리면 식비를 많이 줄일 수 있답니다. '
        'Hareru에서 식비 추이를 기록하고 변화를 직접 확인해보세요.',
    bodyEn:
        'A rice ball costs about ¥150 at a convenience store but only around ¥100 at a supermarket. '
        'These small daily differences can add up to about ¥10,000 per month. '
        'Try building a habit of doing bulk shopping at the supermarket on weekends. '
        'You can also save on prepared foods by shopping during pre-closing discount hours. '
        'Track your food spending trends in Hareru and see the difference for yourself!',
    tags: ['コンビニ', 'スーパー', '食費'],
    relatedSpendingCategories: ['food', 'shopping'],
    difficulty: 'beginner',
  ),

  // 2. daily_02
  FinancialGuide(
    id: 'daily_02',
    icon: '📱',
    category: 'daily',
    titleJa: 'サブスク見直しチェックリスト：使っていないサービスはありませんか？',
    titleKo: '구독 서비스 점검 체크리스트: 사용하지 않는 서비스는 없나요?',
    titleEn: 'Subscription Review Checklist: Any Services You\'re Not Using?',
    bodyJa:
        '動画配信、音楽、クラウドストレージ…気づけばサブスクだらけ、ということはありませんか？'
        '平均的な人は月に約5,000〜8,000円をサブスクに使っているそうです。'
        'まずはスマホの「設定」→「サブスクリプション」で一覧を確認してみましょう。'
        '1ヶ月以上使っていないサービスは、思い切って解約するのがおすすめです。'
        '年間で数万円の節約になることもありますよ。',
    bodyKo:
        '영상 스트리밍, 음악, 클라우드 저장소... 어느새 구독 서비스가 잔뜩 쌓여있지 않나요? '
        '보통 한 달에 약 5,000~8,000엔을 구독에 쓰고 있다고 해요. '
        '먼저 스마트폰의 "설정" → "구독"에서 목록을 확인해보세요. '
        '1개월 이상 사용하지 않는 서비스는 과감하게 해지하는 것을 추천해요. '
        '연간 수만 엔을 절약할 수 있답니다.',
    bodyEn:
        'Video streaming, music, cloud storage... Have subscriptions piled up without you noticing? '
        'The average person spends about ¥5,000-8,000 per month on subscriptions. '
        'Start by checking your phone\'s Settings > Subscriptions to see the full list. '
        'If you haven\'t used a service in over a month, consider canceling it. '
        'This alone could save you tens of thousands of yen per year.',
    tags: ['サブスク', '固定費', '通信'],
    relatedSpendingCategories: ['entertainment', 'shopping'],
    difficulty: 'beginner',
  ),

  // 3. daily_03
  FinancialGuide(
    id: 'daily_03',
    icon: '🚃',
    category: 'daily',
    titleJa: '交通費を賢く：定期券・回数券・ICカードの使い分け',
    titleKo: '교통비를 똑똑하게: 정기권·회수권·IC카드 사용법',
    titleEn: 'Smart Commuting: How to Choose Between Passes, Tickets & IC Cards',
    bodyJa:
        '通勤で毎日電車に乗るなら、定期券が圧倒的にお得です。'
        '例えば片道200円の区間なら、1ヶ月定期で約4,000円の節約になります。'
        '週3日以下の通勤なら、回数券やICカードの方がお得な場合も。'
        '自分の通勤パターンを振り返って、最適な方法を選びましょう。'
        'Hareruの交通費カテゴリで月ごとの支出を確認すると、判断しやすくなりますよ。',
    bodyKo:
        '매일 전철로 출퇴근한다면 정기권이 압도적으로 유리해요. '
        '예를 들어 편도 200엔 구간이라면 1개월 정기권으로 약 4,000엔을 절약할 수 있습니다. '
        '주 3일 이하 출근이라면 회수권이나 IC카드가 더 유리할 수도 있어요. '
        '자신의 출퇴근 패턴을 돌아보고 최적의 방법을 골라보세요. '
        'Hareru의 교통비 카테고리에서 월별 지출을 확인하면 판단이 쉬워져요.',
    bodyEn:
        'If you commute by train every day, a commuter pass is by far the best deal. '
        'For example, a ¥200 one-way fare section can save you about ¥4,000 with a monthly pass. '
        'If you commute 3 days or fewer per week, prepaid tickets or IC cards might be cheaper. '
        'Review your commuting pattern and choose the most cost-effective option. '
        'Check your monthly transport spending in Hareru to help you decide.',
    tags: ['交通費', '定期券', '通勤'],
    relatedSpendingCategories: ['transport'],
    difficulty: 'beginner',
  ),

  // 4. daily_04
  FinancialGuide(
    id: 'daily_04',
    icon: '🍳',
    category: 'daily',
    titleJa: '外食費をコントロール：自炊と外食のベストバランス',
    titleKo: '외식비 조절하기: 자취 요리와 외식의 최적 균형',
    titleEn: 'Control Dining Out Costs: Finding the Best Balance with Home Cooking',
    bodyJa:
        '外食は1回あたり800〜1,500円、自炊なら1食200〜400円程度。'
        '完全自炊は大変なので、「平日の昼はお弁当、週末は外食OK」のようにルールを決めるのがコツです。'
        '月の外食回数を8回から4回に減らすだけでも、約4,000〜6,000円の節約に。'
        '無理せず、楽しみながら続けられるバランスを見つけましょう。'
        'Hareruで外食の回数と金額を記録すると、自分のパターンが見えてきますよ。',
    bodyKo:
        '외식은 1회에 800~1,500엔, 자취 요리는 1끼에 200~400엔 정도예요. '
        '완전 자취 요리는 힘드니까, "평일 점심은 도시락, 주말은 외식 OK" 같은 규칙을 정하는 게 포인트입니다. '
        '월 외식 횟수를 8회에서 4회로 줄이면 약 4,000~6,000엔을 절약할 수 있어요. '
        '무리하지 말고 즐기면서 지속할 수 있는 균형을 찾아보세요. '
        'Hareru에서 외식 횟수와 금액을 기록하면 나만의 패턴이 보여요.',
    bodyEn:
        'Eating out costs about ¥800-1,500 per meal, while home cooking is only ¥200-400. '
        'Since cooking every meal is tough, try setting rules like "pack lunch on weekdays, eat out on weekends." '
        'Just reducing dining out from 8 to 4 times a month can save ¥4,000-6,000. '
        'Find a sustainable balance you can enjoy without stressing yourself out. '
        'Track your dining out frequency and amounts in Hareru to spot your patterns.',
    tags: ['外食', '自炊', '食費'],
    relatedSpendingCategories: ['food', 'cafe'],
    difficulty: 'beginner',
  ),

  // 5. daily_05
  FinancialGuide(
    id: 'daily_05',
    icon: '💡',
    category: 'daily',
    titleJa: '光熱費の節約：季節ごとのポイント',
    titleKo: '공과금 절약: 계절별 포인트',
    titleEn: 'Saving on Utility Bills: Seasonal Tips',
    bodyJa:
        '光熱費は夏と冬に跳ね上がりがち。エアコンの設定温度を1度変えるだけで、約10%の節電になると言われています。'
        '夏は28度、冬は20度が目安です。'
        'また、使っていない家電のコンセントを抜くだけでも、月に約500〜1,000円の節約に。'
        'お風呂は追い焚きを減らして、続けて入るのがポイント。'
        '季節の変わり目にHareruで光熱費を比較して、効果を確認してみましょう。',
    bodyKo:
        '공과금은 여름과 겨울에 크게 오르기 마련이에요. 에어컨 설정 온도를 1도만 바꿔도 약 10% 절전이 된다고 해요. '
        '여름은 28도, 겨울은 20도가 기준이에요. '
        '또한 사용하지 않는 가전의 플러그를 뽑는 것만으로도 월 약 500~1,000엔을 절약할 수 있어요. '
        '목욕은 재가열을 줄이고 연달아 들어가는 것이 포인트예요. '
        '계절이 바뀔 때 Hareru에서 공과금을 비교해 효과를 확인해보세요.',
    bodyEn:
        'Utility bills tend to spike in summer and winter. Adjusting your AC by just 1 degree can save about 10% on electricity. '
        'Aim for 28°C in summer and 20°C in winter. '
        'Simply unplugging unused appliances can save about ¥500-1,000 per month. '
        'For baths, reduce reheating by bathing one after another. '
        'Compare your utility bills across seasons in Hareru to see the impact of your efforts.',
    tags: ['光熱費', '電気', 'ガス', '水道'],
    relatedSpendingCategories: ['other'],
    seasonalMonths: [1, 2, 7, 8],
    difficulty: 'beginner',
  ),

  // ============================================================
  // Category 2: tax (税金・控除)
  // ============================================================

  // 6. tax_01
  FinancialGuide(
    id: 'tax_01',
    icon: '📋',
    category: 'tax',
    titleJa: '確定申告の基本：会社員でも知っておくべきこと',
    titleKo: '확정신고 기본: 직장인도 알아야 할 것들',
    titleEn: 'Tax Filing Basics: What Salaried Workers Should Know',
    bodyJa:
        '会社員は年末調整で税金の手続きが終わることが多いですが、'
        '医療費が年間10万円を超えた場合やふるさと納税をした場合は、確定申告で税金が戻ることがあります。'
        '確定申告の期間は毎年2月16日〜3月15日。e-Taxを使えば自宅からオンラインで手続きできます。'
        '源泉徴収票や領収書を早めに準備しておくとスムーズですよ。'
        'Hareruの記録が医療費の集計に役立つかもしれません。',
    bodyKo:
        '직장인은 연말정산으로 세금 수속이 끝나는 경우가 많지만, '
        '의료비가 연간 10만엔을 초과하거나 후루사토 납세를 한 경우에는 확정신고로 세금을 돌려받을 수 있어요. '
        '확정신고 기간은 매년 2월 16일~3월 15일이에요. e-Tax를 사용하면 집에서 온라인으로 수속할 수 있습니다. '
        '원천징수표와 영수증을 미리 준비해두면 수월해요. '
        'Hareru의 기록이 의료비 집계에 도움이 될 수 있어요.',
    bodyEn:
        'Most salaried workers handle taxes through year-end adjustment, but if your medical expenses exceed ¥100,000 '
        'or you made hometown tax donations, filing a tax return could get you a refund. '
        'The filing period is February 16 to March 15 each year. With e-Tax, you can file online from home. '
        'Prepare your withholding slip and receipts early for a smooth process. '
        'Your Hareru records might come in handy for tallying medical expenses.',
    tags: ['確定申告', '税金', '年末調整'],
    seasonalMonths: [1, 2, 3],
    difficulty: 'intermediate',
  ),

  // 7. tax_02
  FinancialGuide(
    id: 'tax_02',
    icon: '🎁',
    category: 'tax',
    titleJa: 'ふるさと納税入門：実質2,000円で特産品をもらう方法',
    titleKo: '후루사토 납세 입문: 실질 2,000엔으로 특산품 받는 방법',
    titleEn: 'Hometown Tax Intro: How to Get Local Specialties for Just ¥2,000',
    bodyJa:
        'ふるさと納税は、好きな自治体に寄付すると、実質2,000円の自己負担で地域の特産品がもらえる制度です。'
        '寄付額の上限は年収や家族構成で変わるので、シミュレーションサイトで確認しましょう。'
        '年収400万円の独身の方なら、上限は約43,000円が目安です。'
        '12月末が締め切りなので、10〜11月に検討するのがおすすめ。'
        'ワンストップ特例制度を使えば、確定申告なしで控除が受けられますよ。',
    bodyKo:
        '후루사토 납세는 원하는 지자체에 기부하면 실질 2,000엔 자기부담으로 지역 특산품을 받을 수 있는 제도예요. '
        '기부 한도는 연수입과 가족 구성에 따라 달라지니 시뮬레이션 사이트에서 확인해보세요. '
        '연수입 400만엔 독신이라면 한도는 약 43,000엔이 기준이에요. '
        '12월 말이 마감이니 10~11월에 검토하는 것을 추천해요. '
        '원스톱 특례제도를 이용하면 확정신고 없이 공제를 받을 수 있어요.',
    bodyEn:
        'Hometown Tax (Furusato Nouzei) lets you donate to any municipality and receive local specialties '
        'with just ¥2,000 out of pocket. Your donation limit depends on income and family size -- '
        'check a simulation site to find yours. For a single person earning ¥4M, the limit is about ¥43,000. '
        'The deadline is December 31, so start looking in October-November. '
        'Use the One-Stop Exception system to get deductions without filing a tax return.',
    tags: ['ふるさと納税', '控除', '節税'],
    seasonalMonths: [10, 11, 12],
    difficulty: 'beginner',
  ),

  // 8. tax_03
  FinancialGuide(
    id: 'tax_03',
    icon: '🏥',
    category: 'tax',
    titleJa: '医療費控除：年間10万円超えたら申請しよう',
    titleKo: '의료비 공제: 연간 10만엔 초과하면 신청하세요',
    titleEn: 'Medical Expense Deduction: Apply If You Exceed ¥100,000/Year',
    bodyJa:
        '1年間に支払った医療費が10万円（または総所得の5%）を超えた場合、確定申告で税金が戻ります。'
        '対象になるのは、病院の治療費だけでなく、薬局の薬代や通院の交通費も含まれます。'
        '家族全員分を合算できるので、意外と10万円を超えていることも。'
        '領収書は1年間しっかり保管しておきましょう。'
        'Hareruの医療費カテゴリの記録が、集計のときにきっと役立ちますよ。',
    bodyKo:
        '1년간 지불한 의료비가 10만엔(또는 총소득의 5%)을 초과하면 확정신고로 세금을 돌려받을 수 있어요. '
        '대상은 병원 치료비뿐만 아니라 약국 약값이나 통원 교통비도 포함됩니다. '
        '가족 전원분을 합산할 수 있어서 의외로 10만엔을 초과하는 경우가 있어요. '
        '영수증은 1년간 꼼꼼히 보관해두세요. '
        'Hareru의 의료비 카테고리 기록이 집계할 때 분명 도움이 될 거예요.',
    bodyEn:
        'If your annual medical expenses exceed ¥100,000 (or 5% of total income), you can get a tax refund by filing. '
        'This includes not just hospital fees but also pharmacy costs and transportation to clinics. '
        'You can combine expenses for your entire family, so you might be over the threshold without realizing it. '
        'Keep all receipts throughout the year. '
        'Your medical expense records in Hareru will be a big help when it\'s time to add everything up.',
    tags: ['医療費', '控除', '確定申告'],
    relatedSpendingCategories: ['medical'],
    seasonalMonths: [1, 2, 3],
    difficulty: 'intermediate',
  ),

  // 9. tax_04
  FinancialGuide(
    id: 'tax_04',
    icon: '📄',
    category: 'tax',
    titleJa: '住民税のしくみ：6月に届く通知書の見方',
    titleKo: '주민세 구조: 6월에 届く 통지서 보는 법',
    titleEn: 'How Resident Tax Works: Reading Your June Tax Notice',
    bodyJa:
        '住民税は前年の所得に基づいて計算され、6月から翌年5月まで毎月給与から天引きされます。'
        '6月に届く「住民税決定通知書」には、年間の税額や控除の内訳が書かれています。'
        '一般的に、年収300万円の場合は年間約12万円が住民税の目安です。'
        '転職や退職をした年は特に注意が必要で、翌年に一括で請求されることも。'
        '通知書が届いたら、控除が正しく反映されているかチェックしましょう。',
    bodyKo:
        '주민세는 전년 소득을 기준으로 계산되며, 6월부터 다음 해 5월까지 매월 급여에서 공제돼요. '
        '6월에 届く "주민세 결정 통지서"에는 연간 세액과 공제 내역이 적혀 있어요. '
        '일반적으로 연수입 300만엔이면 연간 약 12만엔이 주민세 기준이에요. '
        '전직이나 퇴직한 해는 특히 주의가 필요하며, 다음 해에 일괄 청구될 수도 있어요. '
        '통지서가 도착하면 공제가 올바르게 반영되었는지 확인하세요.',
    bodyEn:
        'Resident tax is calculated based on the previous year\'s income and deducted monthly from June to May. '
        'The "Resident Tax Decision Notice" you receive in June shows your annual tax amount and deduction details. '
        'As a rough guide, someone earning ¥3M per year pays about ¥120,000 in resident tax. '
        'Be especially careful the year you change or leave a job -- you may get a lump-sum bill the following year. '
        'When you receive the notice, check that all deductions are correctly reflected.',
    tags: ['住民税', '税金', '給与'],
    seasonalMonths: [5, 6],
    difficulty: 'intermediate',
  ),

  // 10. tax_05
  FinancialGuide(
    id: 'tax_05',
    icon: '👨‍👩‍👧',
    category: 'tax',
    titleJa: '扶養控除って何？配偶者の収入と税金の関係',
    titleKo: '부양 공제란? 배우자 수입과 세금의 관계',
    titleEn: 'What Is Dependent Deduction? Spouse Income & Tax Relationship',
    bodyJa:
        '配偶者の年収が103万円以下なら、扶養控除（配偶者控除）を受けられ、税金が軽くなります。'
        '103万円を超えると段階的に控除が減り、150万円を超えると配偶者特別控除もなくなります。'
        'また、130万円を超えると社会保険の扶養からも外れるため、保険料の負担が増えます。'
        'いわゆる「103万円の壁」「130万円の壁」を意識しておくと、世帯全体の手取りを考えやすくなりますよ。'
        'パートナーと一緒にHareruで収入を確認してみてくださいね。',
    bodyKo:
        '배우자의 연수입이 103만엔 이하이면 부양 공제(배우자 공제)를 받아 세금이 줄어들어요. '
        '103만엔을 초과하면 단계적으로 공제가 줄고, 150만엔을 넘으면 배우자 특별 공제도 없어져요. '
        '또한 130만엔을 초과하면 사회보험 부양에서도 빠지기 때문에 보험료 부담이 늘어나요. '
        '이른바 "103만엔의 벽", "130만엔의 벽"을 의식해두면 가구 전체의 실수령액을 계산하기 쉬워져요. '
        '파트너와 함께 Hareru에서 수입을 확인해보세요.',
    bodyEn:
        'If your spouse earns ¥1.03M or less per year, you can receive a dependent deduction that reduces your taxes. '
        'Above ¥1.03M, the deduction gradually decreases, and above ¥1.5M, the special spouse deduction disappears entirely. '
        'At ¥1.3M, your spouse also loses social insurance dependent status, increasing insurance costs. '
        'Being aware of the "¥1.03M wall" and "¥1.3M wall" helps you think about your household\'s total take-home pay. '
        'Check income together with your partner using Hareru.',
    tags: ['扶養控除', '配偶者', '103万円の壁'],
    difficulty: 'intermediate',
  ),

  // ============================================================
  // Category 3: investment (貯蓄・投資)
  // ============================================================

  // 11. invest_01
  FinancialGuide(
    id: 'invest_01',
    icon: '🏦',
    category: 'investment',
    titleJa: '先取り貯金のすすめ：給料日に自動で貯める仕組み',
    titleKo: '선취 저축 추천: 월급날에 자동으로 모으는 구조',
    titleEn: 'Pay Yourself First: Auto-Save on Payday',
    bodyJa:
        '「余ったら貯金しよう」では、なかなか貯まりません。'
        '給料が入ったらまず一定額を貯金用口座に自動振替する「先取り貯金」がおすすめです。'
        '目安は手取りの10〜20%。手取り20万円なら、月2〜4万円を先に貯金に回しましょう。'
        '銀行の自動振替サービスを使えば、意識しなくても自然にお金が貯まります。'
        'まずは少額から始めて、慣れてきたら金額を増やしていくのがコツですよ。',
    bodyKo:
        '"남으면 저축하자"는 생각으로는 좀처럼 모이지 않아요. '
        '월급이 들어오면 먼저 일정 금액을 저축 계좌로 자동 이체하는 "선취 저축"을 추천해요. '
        '기준은 실수령액의 10~20%. 실수령 20만엔이면 월 2~4만엔을 먼저 저축으로 돌려보세요. '
        '은행의 자동 이체 서비스를 이용하면 의식하지 않아도 자연스럽게 돈이 모여요. '
        '먼저 소액부터 시작해서 익숙해지면 금액을 늘려가는 것이 요령이에요.',
    bodyEn:
        'Waiting to "save what\'s left over" rarely works. '
        'Instead, set up automatic transfers to a savings account on payday -- this is called "pay yourself first." '
        'Aim for 10-20% of your take-home pay. If you take home ¥200,000, save ¥20,000-40,000 first. '
        'Use your bank\'s automatic transfer service so savings happen without you thinking about it. '
        'Start small and gradually increase the amount as you get comfortable.',
    tags: ['先取り貯金', '貯金', '自動'],
    difficulty: 'beginner',
  ),

  // 12. invest_02
  FinancialGuide(
    id: 'invest_02',
    icon: '📊',
    category: 'investment',
    titleJa: '新NISAかんたんガイド：2024年からの変更点',
    titleKo: '신NISA 간단 가이드: 2024년부터의 변경점',
    titleEn: 'New NISA Simple Guide: Changes from 2024',
    bodyJa:
        '2024年から始まった新NISAは、投資の利益が非課税になるお得な制度です。'
        'つみたて投資枠（年120万円）と成長投資枠（年240万円）の2つがあり、併用もできます。'
        '非課税保有限度額は合計1,800万円で、期間は無期限になりました。'
        '毎月少額からコツコツ積み立てるスタイルが、初心者には特に向いています。'
        'まずは証券口座を開設して、つみたて投資枠から始めてみましょう。'
        '※投資には元本割れのリスクがあります。ご自身の判断で行いましょう。',
    bodyKo:
        '2024년부터 시작된 신NISA는 투자 이익이 비과세가 되는 유리한 제도예요. '
        '적립 투자 한도(연 120만엔)와 성장 투자 한도(연 240만엔) 두 가지가 있으며 병용도 가능해요. '
        '비과세 보유 한도는 합계 1,800만엔이고 기간은 무기한이 되었어요. '
        '매월 소액으로 꾸준히 적립하는 스타일이 초보자에게 특히 적합해요. '
        '먼저 증권 계좌를 개설하고 적립 투자 한도부터 시작해보세요. '
        '※투자에는 원금 손실 위험이 있습니다. 본인의 판단으로 진행하세요.',
    bodyEn:
        'The new NISA, launched in 2024, makes investment profits tax-free. '
        'It has two tiers: the Tsumitate (savings) frame at ¥1.2M/year and the Growth frame at ¥2.4M/year, usable together. '
        'The total tax-free holding limit is ¥18M, and the period is now unlimited. '
        'Starting small with regular monthly contributions is especially suited for beginners. '
        'Open a securities account and start with the Tsumitate frame. '
        '*Investments carry the risk of losing principal. Please invest based on your own judgment.',
    tags: ['NISA', '投資', '非課税'],
    difficulty: 'intermediate',
  ),

  // 13. invest_03
  FinancialGuide(
    id: 'invest_03',
    icon: '🔄',
    category: 'investment',
    titleJa: 'iDeCo入門：老後のために今から始める節税投資',
    titleKo: 'iDeCo 입문: 노후를 위해 지금부터 시작하는 절세 투자',
    titleEn: 'iDeCo Introduction: Tax-Saving Investment for Your Retirement',
    bodyJa:
        'iDeCo（個人型確定拠出年金）は、自分で積み立てて運用する年金制度です。'
        '掛金が全額所得控除になるため、節税効果が大きいのが特徴。'
        '会社員の場合、月の上限は12,000〜23,000円（企業年金の有無で変動）です。'
        '例えば月23,000円を積み立てると、年間約55,000円の節税になるケースも。'
        'ただし、原則60歳まで引き出せないので、余裕資金で始めることが大切です。'
        '※投資には元本割れのリスクがあります。',
    bodyKo:
        'iDeCo(개인형 확정거출 연금)는 스스로 적립하고 운용하는 연금 제도예요. '
        '납부금이 전액 소득공제가 되어 절세 효과가 큰 것이 특징이에요. '
        '직장인의 경우 월 상한은 12,000~23,000엔(기업연금 유무에 따라 변동)이에요. '
        '예를 들어 월 23,000엔을 적립하면 연간 약 55,000엔의 절세가 가능한 경우도 있어요. '
        '다만 원칙적으로 60세까지 인출할 수 없으니 여유 자금으로 시작하는 것이 중요해요. '
        '※투자에는 원금 손실 위험이 있습니다.',
    bodyEn:
        'iDeCo (Individual Defined Contribution) is a pension system where you save and invest on your own. '
        'Contributions are fully tax-deductible, making it a powerful tax-saving tool. '
        'For company employees, the monthly limit is ¥12,000-23,000 depending on your corporate pension plan. '
        'Contributing ¥23,000/month could save you about ¥55,000 in taxes per year. '
        'However, you generally cannot withdraw until age 60, so start with money you can spare. '
        '*Investments carry the risk of losing principal.',
    tags: ['iDeCo', '年金', '節税', '投資'],
    difficulty: 'intermediate',
  ),

  // 14. invest_04
  FinancialGuide(
    id: 'invest_04',
    icon: '🆘',
    category: 'investment',
    titleJa: '緊急資金の作り方：生活費3ヶ月分を目指そう',
    titleKo: '비상금 만드는 법: 생활비 3개월분을 목표로',
    titleEn: 'Building an Emergency Fund: Aim for 3 Months of Living Expenses',
    bodyJa:
        '急な病気、失業、家電の故障…予想外の出費はいつやってくるかわかりません。'
        'まずは生活費の3ヶ月分を緊急資金として貯めておくと安心です。'
        '月の生活費が15万円なら、目標は約45万円。'
        'いきなり大きな金額を目指すのではなく、まずは「1ヶ月分」を目標にしましょう。'
        '緊急資金は、すぐに引き出せる普通預金口座に入れておくのがポイントです。'
        'Hareruで月の生活費を把握して、自分に必要な金額を計算してみてくださいね。',
    bodyKo:
        '갑작스러운 병, 실직, 가전 고장... 예상치 못한 지출은 언제 올지 모릅니다. '
        '먼저 생활비 3개월분을 비상금으로 모아두면 안심이에요. '
        '월 생활비가 15만엔이면 목표는 약 45만엔이에요. '
        '처음부터 큰 금액을 목표로 하기보다, 먼저 "1개월분"을 목표로 해보세요. '
        '비상금은 바로 인출할 수 있는 보통예금 계좌에 넣어두는 것이 포인트예요. '
        'Hareru에서 월 생활비를 파악하고 자신에게 필요한 금액을 계산해보세요.',
    bodyEn:
        'Sudden illness, job loss, broken appliances -- unexpected expenses can hit anytime. '
        'Having 3 months of living expenses saved as an emergency fund gives you peace of mind. '
        'If your monthly expenses are ¥150,000, aim for about ¥450,000. '
        'Rather than targeting the full amount right away, start with just 1 month as your first goal. '
        'Keep your emergency fund in a regular savings account where you can withdraw it immediately. '
        'Use Hareru to understand your monthly expenses and calculate how much you need.',
    tags: ['緊急資金', '貯金', '備え'],
    difficulty: 'beginner',
  ),

  // 15. invest_05
  FinancialGuide(
    id: 'invest_05',
    icon: '✉️',
    category: 'investment',
    titleJa: '袋分け管理法：昔ながらの知恵をデジタルで',
    titleKo: '봉투 분류 관리법: 옛날 지혜를 디지털로',
    titleEn: 'Envelope Budgeting: Traditional Wisdom Goes Digital',
    bodyJa:
        '「袋分け」は、食費・交通費・娯楽費などカテゴリごとに予算を分けて管理する方法です。'
        '昔はお給料を現金で封筒に分けていましたが、今はアプリで同じことができます。'
        '例えば食費3万円、交通費1万円、娯楽費1万円のように予算を決めて、それぞれの枠内でやりくりしましょう。'
        '予算を決めることで「あといくら使えるか」が明確になり、使い過ぎを防げます。'
        'Hareruのカテゴリ別集計で、デジタル袋分けを実践してみてくださいね。',
    bodyKo:
        '"봉투 분류"는 식비·교통비·오락비 등 카테고리별로 예산을 나눠 관리하는 방법이에요. '
        '예전에는 월급을 현금으로 봉투에 나눴지만, 지금은 앱으로 같은 것을 할 수 있어요. '
        '예를 들어 식비 3만엔, 교통비 1만엔, 오락비 1만엔처럼 예산을 정해 각 범위 안에서 운용해보세요. '
        '예산을 정하면 "얼마나 더 쓸 수 있는지"가 명확해지고 과소비를 막을 수 있어요. '
        'Hareru의 카테고리별 집계로 디지털 봉투 분류를 실천해보세요.',
    bodyEn:
        'Envelope budgeting means dividing your money into categories like food, transport, and entertainment. '
        'People used to split cash into physical envelopes, but now apps can do the same thing. '
        'Set budgets like ¥30,000 for food, ¥10,000 for transport, and ¥10,000 for fun, and stay within each limit. '
        'Having set budgets makes it clear "how much is left to spend," preventing overspending. '
        'Try digital envelope budgeting with Hareru\'s category-based summaries.',
    tags: ['袋分け', 'やりくり', '家計管理'],
    difficulty: 'beginner',
  ),

  // ============================================================
  // Category 4: insurance (保険・社会保障)
  // ============================================================

  // 16. ins_01
  FinancialGuide(
    id: 'ins_01',
    icon: '🏢',
    category: 'insurance',
    titleJa: '社会保険と国民健康保険の違い',
    titleKo: '사회보험과 국민건강보험의 차이',
    titleEn: 'Social Insurance vs National Health Insurance: What\'s the Difference?',
    bodyJa:
        '会社に勤めている人は「社会保険（健康保険＋厚生年金）」に加入し、保険料は会社と折半です。'
        'フリーランスや無職の方は「国民健康保険＋国民年金」に自分で加入し、全額自己負担になります。'
        '社会保険の方が保障が手厚く、傷病手当金（給与の約2/3）や出産手当金も支給されます。'
        '転職や退職の際は、14日以内に国民健康保険への切り替え手続きが必要です。'
        '保険料は前年の所得で決まるので、退職直後は高くなることがあります。',
    bodyKo:
        '회사에 다니는 사람은 "사회보험(건강보험+후생연금)"에 가입하며 보험료는 회사와 절반씩 부담해요. '
        '프리랜서나 무직인 분은 "국민건강보험+국민연금"에 직접 가입하며 전액 자기부담이에요. '
        '사회보험이 보장이 더 넓어서 상병수당금(급여의 약 2/3)이나 출산수당금도 지급돼요. '
        '전직이나 퇴직 시에는 14일 이내에 국민건강보험으로 전환 수속이 필요해요. '
        '보험료는 전년 소득으로 정해지니 퇴직 직후에는 높을 수 있어요.',
    bodyEn:
        'Company employees join Social Insurance (health insurance + employee pension), splitting premiums with their employer. '
        'Freelancers and unemployed individuals join National Health Insurance + National Pension, paying the full cost themselves. '
        'Social Insurance offers broader coverage, including sickness allowance (about 2/3 of salary) and maternity benefits. '
        'When changing or leaving jobs, you must switch to NHI within 14 days. '
        'Premiums are based on previous year\'s income, so they can be high right after leaving a job.',
    tags: ['社会保険', '健康保険', '国保'],
    difficulty: 'intermediate',
  ),

  // 17. ins_02
  FinancialGuide(
    id: 'ins_02',
    icon: '🛡️',
    category: 'insurance',
    titleJa: '生命保険は本当に必要？20代・30代の保険の考え方',
    titleKo: '생명보험이 정말 필요할까? 20대·30대의 보험 생각법',
    titleEn: 'Do You Really Need Life Insurance? Insurance Thinking for Your 20s-30s',
    bodyJa:
        '独身で扶養家族がいない20代なら、高額な生命保険は必要ない場合が多いです。'
        '日本の公的医療保険制度は充実していて、医療費の自己負担は原則3割。'
        '高額療養費制度もあるので、まずは公的制度でどこまでカバーされるか確認しましょう。'
        '結婚や子どもの誕生など、ライフステージが変わったときに見直すのがおすすめです。'
        '保険料は月5,000〜10,000円が平均ですが、本当に必要な保障だけに絞ると節約になりますよ。',
    bodyKo:
        '독신으로 부양가족이 없는 20대라면 고액 생명보험이 필요 없는 경우가 많아요. '
        '일본의 공적 의료보험 제도는 충실해서 의료비 자기부담은 원칙적으로 3할이에요. '
        '고액요양비 제도도 있으니 먼저 공적 제도로 어디까지 커버되는지 확인해보세요. '
        '결혼이나 아이 출생 등 생활 단계가 바뀔 때 다시 검토하는 것을 추천해요. '
        '보험료는 월 5,000~10,000엔이 평균인데, 정말 필요한 보장만 골라 줄이면 절약이 돼요.',
    bodyEn:
        'If you\'re single with no dependents in your 20s, expensive life insurance often isn\'t necessary. '
        'Japan\'s public health insurance is comprehensive -- your medical copay is typically just 30%. '
        'With the High-Cost Medical Expense system as a safety net, first check what public programs cover. '
        'Consider reviewing your insurance when major life changes happen, like marriage or having children. '
        'Average premiums are ¥5,000-10,000/month, but trimming to only essential coverage can save you money.',
    tags: ['生命保険', '医療保険', '保障'],
    difficulty: 'intermediate',
  ),

  // 18. ins_03
  FinancialGuide(
    id: 'ins_03',
    icon: '💊',
    category: 'insurance',
    titleJa: '高額療養費制度：医療費が高額になったときの味方',
    titleKo: '고액요양비 제도: 의료비가 높아졌을 때의 아군',
    titleEn: 'High-Cost Medical Expense System: Your Ally When Bills Get High',
    bodyJa:
        '高額療養費制度は、1ヶ月の医療費の自己負担が一定額を超えた場合、超過分が払い戻される制度です。'
        '70歳未満で年収約370万円以下の方なら、上限は約57,600円。'
        'つまり、入院や手術で100万円かかっても、実際の負担は約6万円程度で済みます。'
        '事前に「限度額適用認定証」を申請しておくと、窓口での支払いが上限額までになります。'
        '知っているだけで安心感が全然違いますよ。',
    bodyKo:
        '고액요양비 제도는 1개월 의료비 자기부담이 일정액을 초과하면 초과분이 환급되는 제도예요. '
        '70세 미만으로 연수입 약 370만엔 이하라면 상한은 약 57,600엔이에요. '
        '즉, 입원이나 수술로 100만엔이 들어도 실제 부담은 약 6만엔 정도로 끝나요. '
        '사전에 "한도액 적용 인정증"을 신청해두면 창구 지불이 상한액까지로 제한돼요. '
        '알고 있는 것만으로도 안심감이 완전히 달라져요.',
    bodyEn:
        'The High-Cost Medical Expense system refunds you when your monthly medical copay exceeds a set limit. '
        'For those under 70 earning about ¥3.7M or less, the cap is approximately ¥57,600. '
        'This means even if hospitalization costs ¥1,000,000, you only actually pay about ¥60,000. '
        'Apply for a "Limit Application Certificate" in advance to cap your payment at the hospital window. '
        'Just knowing this system exists can make a huge difference in your peace of mind.',
    tags: ['高額療養費', '医療費', '制度'],
    relatedSpendingCategories: ['medical'],
    difficulty: 'intermediate',
  ),

  // 19. ins_04
  FinancialGuide(
    id: 'ins_04',
    icon: '📦',
    category: 'insurance',
    titleJa: '失業保険（雇用保険）：退職後にもらえるお金',
    titleKo: '실업보험(고용보험): 퇴직 후 받을 수 있는 돈',
    titleEn: 'Unemployment Insurance: Money You Can Receive After Leaving a Job',
    bodyJa:
        '雇用保険に12ヶ月以上加入していた方は、退職後に失業手当（基本手当）を受け取れます。'
        '支給額は退職前の給与の約50〜80%で、日額上限は年齢によって異なります。'
        '自己都合退職の場合は、申請から約2ヶ月の待機期間があるので注意。'
        '受給にはハローワークでの求職登録が必要です。'
        '退職が決まったら、離職票の準備や手続きのスケジュールを早めに確認しておきましょう。'
        '退職後の生活費の見通しを立てるのに、Hareruの支出記録が役立ちますよ。',
    bodyKo:
        '고용보험에 12개월 이상 가입했던 분은 퇴직 후 실업수당(기본수당)을 받을 수 있어요. '
        '지급액은 퇴직 전 급여의 약 50~80%이며 일일 상한은 나이에 따라 달라요. '
        '자기 사정으로 퇴직한 경우 신청 후 약 2개월의 대기 기간이 있으니 주의하세요. '
        '수급에는 헬로워크에서 구직 등록이 필요해요. '
        '퇴직이 정해지면 이직표 준비나 수속 스케줄을 미리 확인해두세요. '
        '퇴직 후 생활비 전망을 세우는 데 Hareru의 지출 기록이 도움이 돼요.',
    bodyEn:
        'If you\'ve been enrolled in employment insurance for 12+ months, you can receive unemployment benefits after leaving your job. '
        'Benefits are about 50-80% of your previous salary, with daily caps varying by age. '
        'For voluntary resignation, there\'s a roughly 2-month waiting period after application, so plan ahead. '
        'You need to register as a job seeker at Hello Work to receive benefits. '
        'Once resignation is decided, prepare your separation notice and check procedure timelines early. '
        'Your spending records in Hareru can help you plan your post-job living expenses.',
    tags: ['失業保険', '雇用保険', '退職'],
    difficulty: 'intermediate',
  ),

  // 20. ins_05
  FinancialGuide(
    id: 'ins_05',
    icon: '👴',
    category: 'insurance',
    titleJa: '年金の仕組み：国民年金と厚生年金の違い',
    titleKo: '연금 구조: 국민연금과 후생연금의 차이',
    titleEn: 'Pension System: National Pension vs Employee Pension',
    bodyJa:
        '日本の年金は2階建て構造。全員が加入する「国民年金」の上に、会社員が加入する「厚生年金」があります。'
        '国民年金の満額は月約65,000円（40年加入の場合）。厚生年金は給与に応じて上乗せされます。'
        '会社員は給与から自動的に天引きされますが、フリーランスは自分で国民年金保険料（月約16,500円）を支払います。'
        '将来の年金額は「ねんきんネット」で確認できるので、一度チェックしてみましょう。'
        '年金だけでは不安な方は、iDeCoやNISAで自分年金を作ることも考えてみてくださいね。',
    bodyKo:
        '일본의 연금은 2층 구조예요. 전원이 가입하는 "국민연금" 위에 회사원이 가입하는 "후생연금"이 있어요. '
        '국민연금 만액은 월 약 65,000엔(40년 가입 시)이에요. 후생연금은 급여에 따라 추가돼요. '
        '회사원은 급여에서 자동으로 공제되지만, 프리랜서는 직접 국민연금 보험료(월 약 16,500엔)를 내요. '
        '장래 연금액은 "연금네트"에서 확인할 수 있으니 한번 체크해보세요. '
        '연금만으로 불안하다면 iDeCo나 NISA로 자기만의 연금을 만드는 것도 생각해보세요.',
    bodyEn:
        'Japan\'s pension has a two-tier structure: everyone joins the National Pension, and company employees add the Employee Pension on top. '
        'The full National Pension is about ¥65,000/month (with 40 years of enrollment). Employee Pension adds more based on salary. '
        'Company employees have premiums auto-deducted, but freelancers pay National Pension premiums (about ¥16,500/month) themselves. '
        'Check your future pension amount on "Nenkin Net" -- it\'s worth looking at least once. '
        'If the pension alone feels insufficient, consider building your own with iDeCo or NISA.',
    tags: ['年金', '国民年金', '厚生年金'],
    difficulty: 'intermediate',
  ),

  // ============================================================
  // Category 5: foreigner (外国人向け)
  // ============================================================

  // 21. foreign_01
  FinancialGuide(
    id: 'foreign_01',
    icon: '🏧',
    category: 'foreigner',
    titleJa: '日本の銀行口座開設ガイド：必要書類と手順',
    titleKo: '일본 은행 계좌 개설 가이드: 필요 서류와 절차',
    titleEn: 'Japan Bank Account Guide: Required Documents & Steps',
    bodyJa:
        '日本で銀行口座を開くには、在留カード、パスポート、印鑑（サインでOKの銀行もあります）が必要です。'
        '来日直後はゆうちょ銀行が開設しやすくておすすめ。全国どこにでもATMがあるのも便利です。'
        '一般的に、来日6ヶ月未満だと口座開設に制限がある場合もあるので、事前に確認しましょう。'
        'ネット銀行は手数料が安いですが、開設にはある程度の日本語力が求められることも。'
        'まずは1つ口座を作って、Hareruで収支管理を始めましょう。',
    bodyKo:
        '일본에서 은행 계좌를 개설하려면 재류카드, 여권, 도장(사인으로 OK인 은행도 있어요)이 필요해요. '
        '입국 직후에는 우체국 은행(ゆうちょ)이 개설하기 쉽고 추천이에요. 전국 어디에나 ATM이 있어 편리하답니다. '
        '일반적으로 입국 6개월 미만이면 계좌 개설에 제한이 있을 수 있으니 사전에 확인하세요. '
        '인터넷 은행은 수수료가 저렴하지만 개설에 어느 정도 일본어 능력이 필요할 수 있어요. '
        '먼저 계좌 하나를 만들고 Hareru에서 수입과 지출 관리를 시작해보세요.',
    bodyEn:
        'To open a bank account in Japan, you need your Residence Card, passport, and a seal (some banks accept signatures). '
        'Japan Post Bank (Yucho) is easiest to open right after arrival, with ATMs available nationwide. '
        'Note that if you\'ve been in Japan less than 6 months, some banks may restrict account opening. '
        'Online banks have lower fees, but the application process may require some Japanese ability. '
        'Start with one account and begin tracking your finances with Hareru.',
    tags: ['銀行', '口座開設', '在留カード'],
    foreignerRelevant: true,
    difficulty: 'beginner',
  ),

  // 22. foreign_02
  FinancialGuide(
    id: 'foreign_02',
    icon: '📝',
    category: 'foreigner',
    titleJa: '住民税の仕組み：外国人も払う必要がある？',
    titleKo: '주민세 구조: 외국인도 낼 필요가 있을까?',
    titleEn: 'Resident Tax: Do Foreigners Need to Pay?',
    bodyJa:
        'はい、1月1日時点で日本に住所がある外国人も住民税を支払う義務があります。'
        '住民税は前年の所得に基づいて計算され、6月から翌年5月にかけて支払います。'
        '年収250万円の場合、住民税は年間約10万円が目安。'
        '帰国する場合は、出国前に「納税管理人届」を提出するか、残りの住民税を一括で支払う必要があります。'
        '届出を忘れると未払いになってしまうので、帰国前に必ず市区町村役場に確認しましょう。',
    bodyKo:
        '네, 1월 1일 시점에 일본에 주소가 있는 외국인도 주민세를 납부할 의무가 있어요. '
        '주민세는 전년 소득을 기준으로 계산되며 6월부터 다음 해 5월에 걸쳐 납부해요. '
        '연수입 250만엔이면 주민세는 연간 약 10만엔이 기준이에요. '
        '귀국하는 경우 출국 전에 "납세관리인 신고서"를 제출하거나 남은 주민세를 일괄 납부해야 해요. '
        '신고를 잊으면 미납이 되니 귀국 전에 반드시 시구정촌 관공서에 확인하세요.',
    bodyEn:
        'Yes, foreigners registered as residents in Japan as of January 1 must pay resident tax. '
        'It\'s calculated based on the previous year\'s income and paid from June to the following May. '
        'For an annual income of ¥2.5M, expect about ¥100,000 in resident tax per year. '
        'If returning to your home country, submit a "Tax Agent Notification" before departure or pay remaining tax in a lump sum. '
        'Forgetting this can lead to unpaid taxes, so always check with your municipal office before leaving.',
    tags: ['住民税', '外国人', '税金'],
    foreignerRelevant: true,
    difficulty: 'beginner',
  ),

  // 23. foreign_03
  FinancialGuide(
    id: 'foreign_03',
    icon: '🩺',
    category: 'foreigner',
    titleJa: '国民健康保険：外国人の加入と負担額',
    titleKo: '국민건강보험: 외국인의 가입과 부담액',
    titleEn: 'National Health Insurance: Enrollment & Costs for Foreigners',
    bodyJa:
        '3ヶ月以上の在留資格を持つ外国人は、国民健康保険への加入が義務です（会社の社会保険に入っている場合を除く）。'
        '保険に入ると、医療費の自己負担が3割になり、安心して病院にかかれます。'
        '保険料は前年の所得と住んでいる市区町村で変わりますが、年間約10〜30万円が目安。'
        '来日したばかりで所得がない場合は、保険料が低く設定されることが多いです。'
        '転入届を出すときに一緒に手続きできるので、忘れずに申請しましょう。',
    bodyKo:
        '3개월 이상의 재류자격을 가진 외국인은 국민건강보험 가입이 의무예요(회사 사회보험에 가입한 경우는 제외). '
        '보험에 가입하면 의료비 자기부담이 3할이 되어 안심하고 병원에 갈 수 있어요. '
        '보험료는 전년 소득과 거주 시구정촌에 따라 다르지만 연간 약 10~30만엔이 기준이에요. '
        '입국 직후 소득이 없는 경우에는 보험료가 낮게 설정되는 경우가 많아요. '
        '전입신고를 할 때 함께 수속할 수 있으니 잊지 말고 신청하세요.',
    bodyEn:
        'Foreigners with a residence status of 3 months or more must enroll in NHI (unless covered by company insurance). '
        'With insurance, your medical copay drops to just 30%, making it much more affordable to see a doctor. '
        'Premiums vary by previous income and municipality, roughly ¥100,000-300,000 per year. '
        'If you just arrived and have no prior income, premiums are often set low. '
        'You can enroll when submitting your move-in registration, so don\'t forget to apply.',
    tags: ['健康保険', '国保', '外国人'],
    foreignerRelevant: true,
    difficulty: 'beginner',
  ),

  // 24. foreign_04
  FinancialGuide(
    id: 'foreign_04',
    icon: '💸',
    category: 'foreigner',
    titleJa: '海外送金の方法比較：銀行 vs Wise vs その他',
    titleKo: '해외송금 방법 비교: 은행 vs Wise vs 기타',
    titleEn: 'International Transfers Compared: Banks vs Wise vs Others',
    bodyJa:
        '海外に送金する方法はいくつかありますが、手数料と為替レートで大きな差が出ます。'
        '銀行の海外送金は1回あたり3,000〜7,000円の手数料がかかることが多いです。'
        'Wiseなどのオンライン送金サービスは手数料が安く、為替レートも有利な傾向があります。'
        '10万円を送金する場合、銀行とWiseで数千円の差になることも。'
        '送金額や頻度に応じて、自分に合った方法を選びましょう。'
        '毎月の送金額をHareruで記録して、年間のコストを把握しておくと安心です。',
    bodyKo:
        '해외에 송금하는 방법은 여러 가지가 있지만 수수료와 환율에서 큰 차이가 나요. '
        '은행 해외송금은 1회에 3,000~7,000엔의 수수료가 드는 경우가 많아요. '
        'Wise 등의 온라인 송금 서비스는 수수료가 저렴하고 환율도 유리한 경향이 있어요. '
        '10만엔을 송금할 경우 은행과 Wise에서 수천 엔 차이가 날 수도 있어요. '
        '송금액과 빈도에 맞춰 자신에게 맞는 방법을 골라보세요. '
        '매월 송금액을 Hareru에서 기록하고 연간 비용을 파악해두면 안심이에요.',
    bodyEn:
        'There are several ways to send money abroad, but fees and exchange rates vary greatly. '
        'Bank transfers often charge ¥3,000-7,000 per transaction. '
        'Online services like Wise tend to have lower fees and better exchange rates. '
        'Sending ¥100,000 could mean a difference of several thousand yen between a bank and Wise. '
        'Choose the method that fits your transfer amount and frequency. '
        'Track your monthly transfer amounts in Hareru to keep tabs on annual costs.',
    tags: ['海外送金', '送金', '為替'],
    foreignerRelevant: true,
    difficulty: 'beginner',
  ),

  // 25. foreign_05
  FinancialGuide(
    id: 'foreign_05',
    icon: '💳',
    category: 'foreigner',
    titleJa: '日本のクレジットカード：外国人が作りやすいカード',
    titleKo: '일본 신용카드: 외국인이 만들기 쉬운 카드',
    titleEn: 'Japan Credit Cards: Cards That Are Easier for Foreigners to Get',
    bodyJa:
        '日本でクレジットカードを作るには、銀行口座と在留カードが必要です。'
        '外国人にも審査が通りやすいカードとして、楽天カードやエポスカードなどが知られています。'
        '在留期間が1年以上あると審査に通りやすく、年収や勤務先も確認されます。'
        '最初は年会費無料のカードから始めるのがおすすめです。'
        'クレジットカードがあると、ネットショッピングやポイント還元でお得になりますよ。'
        '利用額はHareruで管理して、使いすぎを防ぎましょう。',
    bodyKo:
        '일본에서 신용카드를 만들려면 은행 계좌와 재류카드가 필요해요. '
        '외국인도 심사가 통과하기 쉬운 카드로는 라쿠텐 카드나 에포스 카드 등이 알려져 있어요. '
        '재류기간이 1년 이상이면 심사에 통과하기 쉽고, 연수입이나 근무처도 확인돼요. '
        '처음에는 연회비 무료 카드부터 시작하는 것을 추천해요. '
        '신용카드가 있으면 온라인 쇼핑이나 포인트 적립으로 혜택이 많아요. '
        '이용액은 Hareru에서 관리해서 과소비를 방지하세요.',
    bodyEn:
        'To get a credit card in Japan, you need a bank account and Residence Card. '
        'Cards known to be foreigner-friendly include Rakuten Card and Epos Card. '
        'Having a residence period of 1 year or more helps with approval, along with income and employment details. '
        'Start with an annual-fee-free card as your first one. '
        'Credit cards offer benefits like online shopping convenience and point rewards. '
        'Track your card spending in Hareru to prevent overspending.',
    tags: ['クレジットカード', '外国人', '審査'],
    foreignerRelevant: true,
    difficulty: 'beginner',
  ),

  // 26. foreign_06
  FinancialGuide(
    id: 'foreign_06',
    icon: '📑',
    category: 'foreigner',
    titleJa: '確定申告：外国人が注意すべきポイント',
    titleKo: '확정신고: 외국인이 주의해야 할 포인트',
    titleEn: 'Tax Filing: Key Points for Foreigners',
    bodyJa:
        '日本に住んでいる外国人も、一定の条件を満たせば確定申告が必要です。'
        '特に、2箇所以上から給与を受けている方や、副業収入が年間20万円を超える方は要注意。'
        '確定申告書は日本語ですが、国税庁のウェブサイトに英語の案内があります。'
        '税務署では無料の相談窓口があるので、わからないことは直接聞くのが一番です。'
        '申告期間は2月16日〜3月15日。e-Taxなら自宅からオンラインで手続きできます。'
        'Hareruの年間記録が、収支の把握に役立ちますよ。',
    bodyKo:
        '일본에 살고 있는 외국인도 일정 조건을 충족하면 확정신고가 필요해요. '
        '특히 2곳 이상에서 급여를 받고 있거나 부업 수입이 연간 20만엔을 초과하는 분은 주의하세요. '
        '확정신고서는 일본어이지만 국세청 웹사이트에 영어 안내가 있어요. '
        '세무서에는 무료 상담 창구가 있으니 모르는 것은 직접 물어보는 것이 가장 좋아요. '
        '신고 기간은 2월 16일~3월 15일이에요. e-Tax라면 집에서 온라인으로 수속할 수 있어요. '
        'Hareru의 연간 기록이 수입과 지출 파악에 도움이 돼요.',
    bodyEn:
        'Foreigners living in Japan may also need to file a tax return if certain conditions are met. '
        'Pay special attention if you receive salary from 2+ employers or have side income exceeding ¥200,000/year. '
        'While tax forms are in Japanese, the National Tax Agency website has English guidance. '
        'Tax offices offer free consultation counters -- asking in person is the best way to get help. '
        'The filing period is February 16 to March 15. e-Tax lets you file online from home. '
        'Your annual records in Hareru will be helpful for understanding your income and expenses.',
    tags: ['確定申告', '外国人', '税金'],
    foreignerRelevant: true,
    seasonalMonths: [1, 2, 3],
    difficulty: 'intermediate',
  ),

  // 27. foreign_07
  FinancialGuide(
    id: 'foreign_07',
    icon: '🪪',
    category: 'foreigner',
    titleJa: '在留資格と働き方：アルバイト・副業のルール',
    titleKo: '재류자격과 일하는 방식: 아르바이트·부업 규칙',
    titleEn: 'Residence Status & Work: Rules for Part-Time Jobs & Side Work',
    bodyJa:
        '在留資格によって、日本で働ける範囲が異なります。'
        '留学ビザの場合は「資格外活動許可」を取得すれば、週28時間まで（長期休暇中は40時間まで）アルバイトできます。'
        '就労ビザの場合、本業以外の副業には別途許可が必要なことがあるので注意。'
        '許可なく制限を超えて働くと、在留資格の更新に影響することがあります。'
        '入国管理局のルールを必ず確認してから、お仕事を始めましょう。'
        'アルバイト収入もHareruで記録して、しっかり管理しましょうね。',
    bodyKo:
        '재류자격에 따라 일본에서 일할 수 있는 범위가 달라요. '
        '유학 비자의 경우 "자격외활동 허가"를 받으면 주 28시간까지(장기 휴가 중은 40시간까지) 아르바이트가 가능해요. '
        '취업 비자의 경우 본업 외 부업에는 별도 허가가 필요할 수 있으니 주의하세요. '
        '허가 없이 제한을 초과해서 일하면 재류자격 갱신에 영향을 줄 수 있어요. '
        '입국관리국의 규칙을 반드시 확인하고 일을 시작하세요. '
        '아르바이트 수입도 Hareru에서 기록하고 꼼꼼히 관리하세요.',
    bodyEn:
        'Your work permissions in Japan depend on your residence status. '
        'Student visa holders can work up to 28 hours/week (40 during long breaks) with a "Permission to Engage in Activity Other Than That Permitted." '
        'Work visa holders may need separate permission for side jobs outside their main employment. '
        'Working beyond your permitted limits without permission can affect your visa renewal. '
        'Always confirm the Immigration Bureau\'s rules before starting any work. '
        'Track your part-time income in Hareru to keep everything well-managed.',
    tags: ['在留資格', 'アルバイト', '就労'],
    foreignerRelevant: true,
    difficulty: 'beginner',
  ),

  // ============================================================
  // Category 6: saving (家計の知恵)
  // ============================================================

  // 28. saving_01
  FinancialGuide(
    id: 'saving_01',
    icon: '⚖️',
    category: 'saving',
    titleJa: '固定費 vs 変動費：まず見直すべきはどっち？',
    titleKo: '고정비 vs 변동비: 먼저 재검토해야 할 것은?',
    titleEn: 'Fixed vs Variable Costs: Which Should You Review First?',
    bodyJa:
        '家計の見直しで効果が大きいのは、実は「固定費」の方です。'
        '家賃、保険料、スマホ代、サブスクなどは毎月自動的に出ていくため、一度見直せば効果が持続します。'
        '例えば、スマホを格安SIMに変えるだけで月3,000〜5,000円の節約に。'
        '変動費（食費・交際費など）は我慢が必要で続きにくいので、まずは固定費から手をつけましょう。'
        'Hareruでカテゴリ別の支出を確認して、どの固定費が削れそうか見てみてくださいね。',
    bodyKo:
        '가계 재검토에서 효과가 큰 것은 사실 "고정비" 쪽이에요. '
        '집세, 보험료, 스마트폰 요금, 구독 등은 매달 자동으로 나가기 때문에 한 번 재검토하면 효과가 지속돼요. '
        '예를 들어 스마트폰을 격안 SIM으로 바꾸는 것만으로 월 3,000~5,000엔을 절약할 수 있어요. '
        '변동비(식비·교제비 등)는 참아야 해서 지속하기 어려우니 먼저 고정비부터 시작해보세요. '
        'Hareru에서 카테고리별 지출을 확인하고 어떤 고정비를 줄일 수 있을지 살펴보세요.',
    bodyEn:
        'When reviewing your budget, fixed costs actually offer the biggest impact. '
        'Rent, insurance, phone bills, and subscriptions go out automatically each month, so reviewing them once creates lasting savings. '
        'For example, switching to a budget SIM can save ¥3,000-5,000 per month. '
        'Variable costs (food, socializing) require willpower and are harder to sustain, so start with fixed costs. '
        'Check your category-by-category spending in Hareru to spot which fixed costs can be trimmed.',
    tags: ['固定費', '変動費', '見直し'],
    difficulty: 'beginner',
  ),

  // 29. saving_02
  FinancialGuide(
    id: 'saving_02',
    icon: '📲',
    category: 'saving',
    titleJa: 'キャッシュレス決済のポイント活用術',
    titleKo: '캐시리스 결제 포인트 활용술',
    titleEn: 'Maximizing Cashless Payment Points',
    bodyJa:
        'PayPay、楽天Pay、Suicaなどのキャッシュレス決済を使うと、支払いのたびにポイントが貯まります。'
        '還元率は0.5〜1.5%が一般的で、月5万円の決済なら年間で3,000〜9,000円分のポイントに。'
        'ポイントを効率よく貯めるコツは、メインの決済方法を1〜2個に絞ること。'
        'あちこち分散すると、ポイントがバラバラになって使いにくくなります。'
        'キャンペーンを上手に活用すれば、さらにお得になりますよ。'
        'Hareruで支払い方法ごとの支出を把握して、ポイント戦略を立てましょう。',
    bodyKo:
        'PayPay, 라쿠텐Pay, Suica 등의 캐시리스 결제를 사용하면 결제할 때마다 포인트가 쌓여요. '
        '환원율은 0.5~1.5%가 일반적이며 월 5만엔 결제 시 연간 3,000~9,000엔분의 포인트가 돼요. '
        '포인트를 효율적으로 모으는 요령은 주요 결제 방법을 1~2개로 좁히는 것이에요. '
        '여기저기 분산하면 포인트가 흩어져서 사용하기 어려워져요. '
        '캠페인을 잘 활용하면 더욱 유리해질 수 있어요. '
        'Hareru에서 결제 방법별 지출을 파악하고 포인트 전략을 세워보세요.',
    bodyEn:
        'Cashless payments like PayPay, Rakuten Pay, and Suica earn you points with every purchase. '
        'Reward rates are typically 0.5-1.5%, meaning ¥50,000 in monthly spending earns ¥3,000-9,000 in points per year. '
        'The key to earning points efficiently is limiting your main payment methods to 1-2. '
        'Spreading across too many services scatters your points and makes them harder to use. '
        'Take advantage of campaigns for even bigger rewards. '
        'Track spending by payment method in Hareru to build your points strategy.',
    tags: ['キャッシュレス', 'ポイント', 'PayPay'],
    difficulty: 'beginner',
  ),

  // 30. saving_03
  FinancialGuide(
    id: 'saving_03',
    icon: '🎉',
    category: 'saving',
    titleJa: 'ボーナスの賢い使い方：貯金・投資・ご褒美のバランス',
    titleKo: '보너스 현명한 사용법: 저축·투자·보상의 균형',
    titleEn: 'Smart Bonus Spending: Balancing Savings, Investment & Treats',
    bodyJa:
        'ボーナスが入ると嬉しくて、つい使い過ぎてしまいがちですよね。'
        'おすすめの分け方は、50%を貯金・投資、30%を必要な出費、20%を自分へのご褒美にすること。'
        '例えばボーナスが30万円なら、15万円を貯金、9万円を必要な買い物、6万円を楽しみに使いましょう。'
        'ご褒美の部分を設定することで、満足感を得ながら計画的にお金を使えます。'
        'ボーナスの使い道を事前にHareruでメモしておくと、衝動買いを防げますよ。',
    bodyKo:
        '보너스가 들어오면 기분이 좋아서 과소비하기 쉽죠. '
        '추천 분배법은 50%를 저축·투자, 30%를 필요한 지출, 20%를 자신에 대한 보상으로 나누는 것이에요. '
        '예를 들어 보너스가 30만엔이면 15만엔은 저축, 9만엔은 필요한 쇼핑, 6만엔은 즐거움에 써보세요. '
        '보상 부분을 정해두면 만족감을 느끼면서 계획적으로 돈을 쓸 수 있어요. '
        '보너스 사용처를 미리 Hareru에 메모해두면 충동구매를 방지할 수 있어요.',
    bodyEn:
        'It\'s tempting to splurge when bonus season arrives, but a little planning goes a long way. '
        'A good split: 50% for savings/investment, 30% for necessary expenses, and 20% as a treat for yourself. '
        'For a ¥300,000 bonus, that means ¥150,000 saved, ¥90,000 for needs, and ¥60,000 for fun. '
        'Setting aside a treat portion lets you enjoy spending while staying on plan. '
        'Note your bonus spending plan in Hareru ahead of time to prevent impulse purchases.',
    tags: ['ボーナス', '貯金', '投資'],
    seasonalMonths: [6, 7, 12],
    difficulty: 'beginner',
  ),
];
