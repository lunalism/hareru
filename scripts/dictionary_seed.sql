-- Dictionary terms seed data
-- Generated from lib/data/dictionary_data.dart
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS dictionary_terms (
  id SERIAL PRIMARY KEY,
  term_key TEXT NOT NULL UNIQUE,
  emoji TEXT,
  category TEXT NOT NULL,
  name_ja TEXT NOT NULL,
  summary_ja TEXT,
  description_ja TEXT,
  example_ja TEXT,
  name_ko TEXT,
  summary_ko TEXT,
  description_ko TEXT,
  example_ko TEXT,
  name_en TEXT,
  summary_en TEXT,
  description_en TEXT,
  example_en TEXT,
  related_term_keys TEXT[] DEFAULT '{}',
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'savings_account',
  '🏦',
  'banking',
  '普通預金',
  'いつでも出し入れできる預金',
  '銀行口座の基本となる預金で、いつでも自由に預け入れ・引き出しができます。

給与振込や公共料金の引き落としに使われる最も一般的な口座です。金利は非常に低いですが、流動性が高いのが特徴です。',
  '会社からの給料は毎月25日に普通預金口座に振り込まれ、そこから家賃や光熱費が自動で引き落とされます。',
  '보통예금',
  '언제든 입출금 가능한 예금',
  '은행 계좌의 기본이 되는 예금으로, 언제든지 자유롭게 입금·출금이 가능합니다.

급여 입금이나 공과금 자동이체에 사용되는 가장 일반적인 계좌입니다. 금리는 매우 낮지만 유동성이 높은 것이 특징입니다.',
  '회사 급여는 매달 25일에 보통예금 계좌로 입금되고, 거기서 월세나 공과금이 자동으로 빠져나갑니다.',
  'Savings Account',
  'Deposit you can access anytime',
  'The most basic bank account that allows free deposits and withdrawals at any time.

It is commonly used for salary deposits and utility bill payments. Interest rates are very low, but the account offers high liquidity.',
  'Your salary is deposited into your savings account on the 25th, and rent and utilities are automatically deducted from it.',
  ARRAY['fixed_deposit', 'installment_savings', 'bank_transfer'],
  0,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'fixed_deposit',
  '🔒',
  'banking',
  '定期預金',
  '一定期間預けると高い金利がつく',
  '一定の期間（1ヶ月〜10年）お金を預けることで、普通預金より高い金利が適用される預金です。

原則として満期前に引き出すと金利が下がります。まとまったお金を安全に増やしたい場合に適しています。',
  '100万円を年利0.2%の1年定期預金に預けると、1年後に約2,000円の利息がつきます。',
  '정기예금',
  '일정 기간 맡기면 높은 금리 적용',
  '일정 기간(1개월~10년) 돈을 맡기면 보통예금보다 높은 금리가 적용되는 예금입니다.

원칙적으로 만기 전에 인출하면 금리가 낮아집니다. 목돈을 안전하게 불리고 싶을 때 적합합니다.',
  '100만엔을 연이율 0.2%의 1년 정기예금에 맡기면, 1년 후 약 2,000엔의 이자가 붙습니다.',
  'Fixed Deposit',
  'Higher interest for fixed-term deposits',
  'A deposit where you lock your money for a set period (1 month to 10 years) in exchange for a higher interest rate.

Withdrawing before maturity typically reduces the interest rate. It is ideal for safely growing a lump sum.',
  'Depositing ¥1,000,000 in a 1-year fixed deposit at 0.2% annual interest earns about ¥2,000 after one year.',
  ARRAY['savings_account', 'installment_savings', 'opening_account'],
  1,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'installment_savings',
  '📥',
  'banking',
  '積立定期預金',
  '毎月コツコツ積み立てる定期預金',
  '毎月決まった金額を自動的に積み立てていく定期預金です。

毎月の積立ごとに個別の定期預金が作られ、それぞれに金利が適用されます。韓国の적금とは仕組みが異なり、満期一括金利ではありません。少額から始められるのが魅力です。',
  '毎月1万円を積立定期にすると、1ヶ月目の1万円、2ヶ月目の1万円...それぞれが個別の定期預金として金利がつきます。',
  '적립정기예금',
  '매달 꾸준히 적립하는 정기예금',
  '매달 정해진 금액을 자동으로 적립하는 정기예금입니다.

매달 적립할 때마다 개별 정기예금이 생성되어 각각 금리가 따로 적용됩니다. 한국의 적금과는 구조가 달라서, 만기 일괄 금리가 아닙니다. 소액부터 시작할 수 있는 것이 장점입니다.',
  '매달 1만엔을 적립정기로 하면, 1개월째의 1만엔, 2개월째의 1만엔... 각각이 개별 정기예금으로 금리가 붙습니다.',
  'Installment Savings',
  'Monthly automatic savings deposits',
  'A savings plan where a fixed amount is automatically deposited each month.

Each monthly deposit creates a separate fixed deposit with its own interest rate. Unlike Korean installment savings (적금), the interest is applied individually to each deposit, not as a lump sum at maturity.',
  'If you save ¥10,000 monthly, each ¥10,000 deposit becomes its own fixed deposit earning interest independently.',
  ARRAY['fixed_deposit', 'savings_account', 'direct_debit'],
  2,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'bank_transfer',
  '💸',
  'banking',
  '振込',
  '他の口座にお金を送ること',
  '自分の銀行口座から他の人や会社の口座にお金を送ることです。

ATM、窓口、ネットバンキングで行えます。振込手数料は銀行や方法によって異なり、同じ銀行なら無料の場合が多いです。',
  '家賃の支払いは毎月25日に不動産会社の口座に振込で行っています。ネットバンキングなら手数料が安くなります。',
  '계좌이체',
  '다른 계좌로 돈을 보내는 것',
  '자신의 은행 계좌에서 다른 사람이나 회사의 계좌로 돈을 보내는 것입니다.

ATM, 창구, 인터넷뱅킹으로 할 수 있습니다. 이체 수수료는 은행이나 방법에 따라 다르며, 같은 은행이면 무료인 경우가 많습니다.',
  '월세 지불은 매달 25일에 부동산 회사 계좌로 이체로 하고 있습니다. 인터넷뱅킹이면 수수료가 저렴합니다.',
  'Bank Transfer',
  'Sending money to another account',
  'Sending money from your bank account to another person''s or company''s account.

This can be done via ATM, bank counter, or online banking. Transfer fees vary by bank and method; transfers within the same bank are often free.',
  'I pay rent by transferring to the real estate company''s account on the 25th each month. Online banking offers lower fees.',
  ARRAY['atm_fees', 'direct_debit', 'savings_account'],
  3,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'atm_fees',
  '🏧',
  'banking',
  'ATM手数料',
  'ATM利用時にかかる手数料',
  'ATMでお金を引き出したり振り込んだりする時にかかる手数料です。

自分の銀行のATMなら平日日中は無料のことが多いですが、コンビニATMや時間外は110〜330円程度かかります。ネット銀行は月数回無料の場合があります。',
  '月4回コンビニATMで下ろすと、手数料だけで月880円、年間10,560円。ネット銀行に変えれば無料にできるかもしれません。',
  'ATM수수료',
  'ATM 이용 시 발생하는 수수료',
  'ATM에서 돈을 인출하거나 이체할 때 발생하는 수수료입니다.

자기 은행 ATM이면 평일 낮에는 무료인 경우가 많지만, 편의점 ATM이나 시간외에는 110~330엔 정도 듭니다. 인터넷은행은 월 몇 회 무료인 경우가 있습니다.',
  '한 달에 4번 편의점 ATM에서 인출하면 수수료만 월 880엔, 연간 10,560엔. 인터넷은행으로 바꾸면 무료로 할 수 있을지도 모릅니다.',
  'ATM Fees',
  'Fees for using ATMs',
  'Fees charged when withdrawing money or making transfers at ATMs.

Using your own bank''s ATM during business hours is often free, but convenience store ATMs or off-hours usage costs about ¥110-330. Online banks often offer several free withdrawals per month.',
  'Withdrawing from a convenience store ATM 4 times monthly costs ¥880/month or ¥10,560/year in fees. Switching to an online bank could eliminate these fees.',
  ARRAY['bank_transfer', 'online_bank', 'cash_card'],
  4,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'online_bank',
  '🌐',
  'banking',
  'ネット銀行',
  '店舗を持たないインターネット専業銀行',
  '実店舗を持たず、インターネット上でサービスを提供する銀行です。

店舗運営コストがかからないため、金利が高めでATM手数料の無料回数も多い傾向があります。楽天銀行、ソニー銀行、住信SBIネット銀行などが代表的です。',
  'ネット銀行に変えたら、普通預金の金利が0.1%になり、ATM手数料も月5回まで無料に。年間で数千円お得になりました。',
  '인터넷은행',
  '점포 없이 인터넷으로만 운영하는 은행',
  '실제 점포 없이 인터넷으로 서비스를 제공하는 은행입니다.

점포 운영 비용이 들지 않아 금리가 높고 ATM 수수료 무료 횟수도 많은 경향이 있습니다. 라쿠텐은행, 소니은행, SBI넷은행 등이 대표적입니다.',
  '인터넷은행으로 바꿨더니 보통예금 금리가 0.1%가 되고, ATM 수수료도 월 5회까지 무료. 연간 수천 엔을 절약했습니다.',
  'Online Bank',
  'Internet-only banks without branches',
  'Banks that operate exclusively online without physical branches.

Without branch operating costs, they tend to offer higher interest rates and more free ATM withdrawals. Popular examples include Rakuten Bank, Sony Bank, and SBI Sumishin Net Bank.',
  'After switching to an online bank, my savings rate went up to 0.1% and I get 5 free ATM withdrawals monthly, saving thousands of yen per year.',
  ARRAY['atm_fees', 'savings_account', 'cash_card'],
  5,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'bankbook',
  '📖',
  'banking',
  '通帳',
  '入出金の記録が印字される手帳',
  '銀行口座の入出金履歴が記録される小さな手帳です。

ATMに通すと最新の取引が印字されます。最近はネット通帳（Web通帳）に切り替える人も増えています。通帳がないと不安な方は窓口で発行してもらえます。',
  '月に一度ATMで通帳記入をして、入出金をチェックしています。ネット通帳にすると、スマホでいつでも確認できます。',
  '통장',
  '입출금 내역이 기록되는 수첩',
  '은행 계좌의 입출금 내역이 기록되는 작은 수첩입니다.

ATM에 넣으면 최신 거래가 인쇄됩니다. 최근에는 인터넷 통장(웹 통장)으로 전환하는 사람도 늘고 있습니다. 통장이 없으면 불안한 분은 창구에서 발급받을 수 있습니다.',
  '한 달에 한 번 ATM에서 통장 기입을 해서 입출금을 확인합니다. 인터넷 통장으로 바꾸면 스마트폰으로 언제든 확인할 수 있습니다.',
  'Bankbook',
  'Booklet recording deposits and withdrawals',
  'A small booklet that records all deposits and withdrawals for a bank account.

Inserting it into an ATM prints the latest transactions. Many people are switching to online passbooks (web bankbooks). If you prefer a physical copy, you can request one at the bank counter.',
  'I update my bankbook at the ATM once a month to check transactions. With an online bankbook, I can check anytime on my phone.',
  ARRAY['savings_account', 'cash_card', 'opening_account'],
  6,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'cash_card',
  '💳',
  'banking',
  'キャッシュカード',
  'ATMで使う銀行カード',
  '銀行口座に紐づいたカードで、ATMでお金の預け入れや引き出しに使います。

デビットカード機能がついた一体型カードも増えています。暗証番号の管理が重要で、紛失した場合はすぐに銀行に連絡しましょう。',
  '口座開設時にキャッシュカードが発行されます。最近はデビット機能付きで、お店でそのまま買い物もできます。',
  '현금카드',
  'ATM에서 사용하는 은행 카드',
  '은행 계좌와 연결된 카드로, ATM에서 입금이나 출금에 사용합니다.

데빗카드 기능이 붙은 일체형 카드도 늘고 있습니다. 비밀번호 관리가 중요하며, 분실 시 즉시 은행에 연락해야 합니다.',
  '계좌 개설 시 현금카드가 발급됩니다. 최근에는 데빗 기능이 붙어 있어 가게에서 바로 쇼핑도 할 수 있습니다.',
  'Cash Card',
  'Bank card for ATM transactions',
  'A card linked to your bank account used for ATM deposits and withdrawals.

Combination cards with debit card functionality are becoming common. PIN management is important — report lost cards to your bank immediately.',
  'A cash card is issued when you open an account. Modern cards often include debit functionality for direct shopping at stores.',
  ARRAY['atm_fees', 'opening_account', 'bankbook'],
  7,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'opening_account',
  '📋',
  'banking',
  '口座開設',
  '銀行に口座を作ること',
  '銀行で新しく口座を作ることです。

本人確認書類（運転免許証、マイナンバーカードなど）と印鑑が必要です。外国人の方は在留カードとパスポートがあれば開設できます。ネット銀行はスマホだけで完結できます。',
  '日本に来たばかりの方は、まずゆうちょ銀行で口座開設するのがおすすめ。在留カードとパスポートがあればOKです。',
  '계좌개설',
  '은행에 계좌를 만드는 것',
  '은행에서 새로 계좌를 만드는 것입니다.

본인 확인 서류(운전면허증, 마이넘버카드 등)와 도장이 필요합니다. 외국인은 재류카드와 여권이 있으면 개설할 수 있습니다. 인터넷은행은 스마트폰만으로 완료할 수 있습니다.',
  '일본에 온 지 얼마 안 된 분은 먼저 유초은행에서 계좌를 개설하는 것을 추천합니다. 재류카드와 여권만 있으면 됩니다.',
  'Opening an Account',
  'Creating a bank account',
  'The process of creating a new bank account.

You need identification (driver''s license, My Number card, etc.) and a personal seal (inkan). Foreign residents can open accounts with a Residence Card and passport. Online banks can be set up entirely via smartphone.',
  'If you just arrived in Japan, Japan Post Bank is recommended for your first account. Just bring your Residence Card and passport.',
  ARRAY['savings_account', 'bankbook', 'cash_card'],
  8,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'direct_debit',
  '🔄',
  'banking',
  '口座振替',
  '自動で口座から引き落とされる仕組み',
  '公共料金や保険料などが、毎月決まった日に自動的に口座から引き落とされる仕組みです。

払い忘れを防げる便利なサービスです。設定は銀行窓口やWebで行えます。引き落とし日に残高不足だと未払いになるので注意が必要です。',
  '電気代、ガス代、水道代、スマホ代を全て口座振替にしたら、払い忘れがなくなって安心です。',
  '자동이체',
  '자동으로 계좌에서 빠져나가는 구조',
  '공과금이나 보험료 등이 매달 정해진 날에 자동으로 계좌에서 빠져나가는 구조입니다.

납부를 잊는 것을 방지할 수 있는 편리한 서비스입니다. 설정은 은행 창구나 웹에서 할 수 있습니다. 이체일에 잔액이 부족하면 미납이 되니 주의가 필요합니다.',
  '전기세, 가스비, 수도세, 스마트폰 요금을 모두 자동이체로 설정하면 납부를 잊을 걱정이 없어서 안심입니다.',
  'Direct Debit',
  'Automatic payment from your account',
  'A system where utility bills, insurance premiums, and other payments are automatically deducted from your account on a set date.

It prevents missed payments. Set up at the bank or online. Ensure sufficient balance on the deduction date to avoid failed payments.',
  'Setting up direct debit for electricity, gas, water, and phone bills eliminates the worry of missed payments.',
  ARRAY['bank_transfer', 'savings_account', 'installment_savings'],
  9,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'disposable_income',
  '💰',
  'household',
  '可処分所得',
  '自由に使えるお金のこと',
  '給料から所得税、住民税、社会保険料などを差し引いた後に残るお金のことです。

「手取り」とほぼ同じ意味で、実際に自分の財布に入ってくる金額を指します。家計管理では、この可処分所得をベースに予算を立てることが大切です。',
  '月給25万円の場合、税金と社会保険料で約5万円が引かれるため、可処分所得は約20万円になります。',
  '가처분소득',
  '자유롭게 쓸 수 있는 돈',
  '급여에서 소득세, 주민세, 사회보험료 등을 뺀 후 남는 돈입니다.

실수령액과 거의 같은 의미로, 실제로 내 지갑에 들어오는 금액을 말합니다. 가계 관리에서는 이 가처분소득을 기준으로 예산을 세우는 것이 중요합니다.',
  '월급 25만엔의 경우, 세금과 사회보험료로 약 5만엔이 빠지므로 가처분소득은 약 20만엔이 됩니다.',
  'Disposable Income',
  'Money you can freely spend',
  'The money left after deducting income tax, resident tax, and social insurance from your salary.

It is essentially your take-home pay — the amount that actually enters your wallet. For household budgeting, it is important to plan your budget based on disposable income.',
  'If your monthly salary is ¥250,000, about ¥50,000 is deducted for taxes and insurance, leaving about ¥200,000 of disposable income.',
  ARRAY['take_home_pay', 'engel_coefficient', 'savings_rate'],
  10,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'engel_coefficient',
  '📊',
  'household',
  'エンゲル係数',
  '食費が支出に占める割合',
  '家計の消費支出に占める食費の割合のことです。

この数値が低いほど、生活にゆとりがあるとされています。日本の平均は約25〜28%ですが、一人暮らしや外食が多い場合は30%を超えることもあります。',
  '月の支出が20万円で食費が5万円なら、エンゲル係数は25%。6万円に増えると30%になり、食費の見直しが必要かもしれません。',
  '엥겔계수',
  '식비가 지출에서 차지하는 비율',
  '가계 소비지출에서 식비가 차지하는 비율입니다.

이 수치가 낮을수록 생활에 여유가 있다고 합니다. 일본 평균은 약 25~28%이지만, 1인 가구나 외식이 많으면 30%를 넘기도 합니다.',
  '월 지출이 20만엔이고 식비가 5만엔이면 엥겔계수는 25%. 6만엔으로 늘면 30%가 되어 식비 재검토가 필요할 수 있습니다.',
  'Engel''s Coefficient',
  'Ratio of food spending to total',
  'The percentage of food spending in total household expenses.

A lower ratio generally indicates more financial comfort. The Japanese average is about 25-28%, but it can exceed 30% for single households or frequent diners out.',
  'If monthly spending is ¥200,000 and food costs ¥50,000, the coefficient is 25%. If food rises to ¥60,000, it becomes 30%.',
  ARRAY['disposable_income', 'variable_expenses', 'saving_money'],
  11,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'take_home_pay',
  '💵',
  'household',
  '手取り',
  '実際に受け取る給料',
  '額面の給料から税金や社会保険料を引いた、実際に口座に振り込まれる金額のことです。

一般的に、額面の75〜85%が手取りになります。手取りを正確に把握することが家計管理の第一歩です。',
  '額面30万円の場合、所得税・住民税で約2万円、社会保険料で約4.5万円が引かれ、手取りは約23.5万円になります。',
  '실수령액',
  '실제로 받는 급여',
  '액면 급여에서 세금과 사회보험료를 뺀, 실제로 계좌에 입금되는 금액입니다.

일반적으로 액면의 75~85%가 실수령액이 됩니다. 실수령액을 정확히 파악하는 것이 가계 관리의 첫걸음입니다.',
  '액면 30만엔의 경우, 소득세·주민세로 약 2만엔, 사회보험료로 약 4.5만엔이 빠져 실수령액은 약 23.5만엔이 됩니다.',
  'Take-home Pay',
  'Actual salary you receive',
  'The amount actually deposited into your account after taxes and insurance are deducted from gross salary.

Typically 75-85% of your gross pay. Knowing your exact take-home pay is the first step in budgeting.',
  'With a gross salary of ¥300,000, about ¥20,000 goes to taxes and ¥45,000 to insurance, leaving take-home pay of about ¥235,000.',
  ARRAY['disposable_income', 'income_tax', 'social_insurance'],
  12,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'household_budget',
  '📒',
  'household',
  '家計簿',
  '収支を記録して管理する帳簿',
  '収入と支出を記録・管理するための帳簿やアプリのことです。

家計簿をつけることで、お金の流れが見える化され、無駄な支出に気づけるようになります。Hareruのような家計簿アプリを使えば、3秒で簡単に記録できます。',
  '毎月の手取り23万円のうち、家賃7万円、食費4万円、光熱費1.5万円…と家計簿に記録すれば、残りがいくら貯蓄に回せるか一目でわかります。',
  '가계부',
  '수입과 지출을 기록하는 장부',
  '수입과 지출을 기록·관리하기 위한 장부나 앱입니다.

가계부를 쓰면 돈의 흐름이 시각화되어 불필요한 지출을 파악할 수 있습니다. Hareru 같은 가계부 앱을 사용하면 3초 만에 간편하게 기록할 수 있습니다.',
  '매달 실수령액 23만엔 중 집세 7만엔, 식비 4만엔, 공과금 1.5만엔… 가계부에 기록하면 저축에 얼마를 돌릴 수 있는지 한눈에 알 수 있습니다.',
  'Household Budget',
  'A ledger to track income and expenses',
  'A book or app for recording and managing income and expenses.

Keeping a household budget makes your money flow visible, helping you spot wasteful spending. Apps like Hareru let you record expenses in just 3 seconds.',
  'Recording rent ¥70,000, food ¥40,000, utilities ¥15,000 from your ¥230,000 take-home pay shows exactly how much you can save.',
  ARRAY['fixed_expenses', 'variable_expenses', 'savings_rate'],
  13,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'fixed_expenses',
  '💳',
  'household',
  '固定費',
  '毎月同じ金額の支出',
  '毎月ほぼ一定額かかる支出のことです。家賃、通信費、保険料、サブスクリプションなどが代表的です。

固定費を見直すことで、努力せずに毎月の支出を減らせます。特にスマホ料金や保険の見直しは効果が大きいです。',
  '家賃8万円、スマホ代8千円、保険料1.5万円、Netflix 1,500円。固定費だけで月10万円以上。格安スマホに変えれば月5,000円節約できます。',
  '고정비',
  '매달 같은 금액의 지출',
  '매달 거의 일정하게 나가는 지출입니다. 집세, 통신비, 보험료, 구독 서비스 등이 대표적입니다.

고정비를 재검토하면 노력 없이 매달 지출을 줄일 수 있습니다. 특히 스마트폰 요금이나 보험 재검토가 효과적입니다.',
  '집세 8만엔, 스마트폰 8천엔, 보험료 1.5만엔, 넷플릭스 1,500엔. 고정비만 월 10만엔 이상. 알뜰폰으로 바꾸면 월 5,000엔 절약 가능합니다.',
  'Fixed Expenses',
  'Same amount every month',
  'Expenses that cost roughly the same every month, such as rent, phone bills, insurance, and subscriptions.

Reviewing fixed costs lets you reduce spending effortlessly each month. Phone plans and insurance are especially impactful to optimize.',
  'Rent ¥80,000, phone ¥8,000, insurance ¥15,000, Netflix ¥1,500 — over ¥100,000/month in fixed costs. Switching to a budget phone plan saves ¥5,000/month.',
  ARRAY['variable_expenses', 'saving_money', 'household_budget'],
  14,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'variable_expenses',
  '🛒',
  'household',
  '変動費',
  '月によって変わる支出',
  '月によって金額が変わる支出のことです。食費、交際費、衣服代、レジャー費などが含まれます。

変動費は意識すれば節約しやすい反面、我慢しすぎるとストレスになります。Hareruで変動費を記録して、バランスの良い支出を目指しましょう。',
  '今月は飲み会が多く交際費3万円。先月は1万円だった。変動費は月によって2万円以上差が出ることもあります。',
  '변동비',
  '달마다 달라지는 지출',
  '달마다 금액이 달라지는 지출입니다. 식비, 교제비, 의류비, 여가비 등이 포함됩니다.

변동비는 의식하면 절약하기 쉽지만, 너무 참으면 스트레스가 됩니다. Hareru로 변동비를 기록해서 균형 잡힌 지출을 목표로 합시다.',
  '이번 달은 회식이 많아 교제비 3만엔. 지난달은 1만엔이었습니다. 변동비는 달마다 2만엔 이상 차이가 날 수 있습니다.',
  'Variable Expenses',
  'Spending that changes monthly',
  'Spending that varies month to month, including food, socializing, clothing, and entertainment.

Variable expenses are easier to cut with awareness, but over-restricting causes stress. Use Hareru to track them and find a healthy balance.',
  'This month social expenses hit ¥30,000 due to dinners out, versus ¥10,000 last month. Variable costs can swing ¥20,000+ between months.',
  ARRAY['fixed_expenses', 'engel_coefficient', 'household_budget'],
  15,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'saving_money',
  '🏷️',
  'household',
  '節約',
  '無駄を減らしてお金を貯める',
  '無駄な支出を見つけて減らし、お金を効率よく使うことです。

節約のコツは「大きな固定費から見直す」こと。コンビニで毎日100円節約するより、スマホプランを変えて月5,000円節約する方が効果的です。',
  '格安スマホに変更（月-5,000円）、保険見直し（月-3,000円）、サブスク整理（月-2,000円）で、年間12万円の節約になります。',
  '절약',
  '낭비를 줄여 돈을 모으기',
  '불필요한 지출을 찾아 줄이고 돈을 효율적으로 사용하는 것입니다.

절약의 핵심은 "큰 고정비부터 재검토하는 것"입니다. 편의점에서 매일 100엔 절약하는 것보다 스마트폰 요금을 바꿔 월 5,000엔 절약하는 게 효과적입니다.',
  '알뜰폰 변경(월 -5,000엔), 보험 재검토(월 -3,000엔), 구독 정리(월 -2,000엔)로 연간 12만엔 절약이 됩니다.',
  'Saving Money',
  'Reducing waste to save more',
  'Finding and cutting unnecessary expenses to use money more efficiently.

The key tip is to start with big fixed costs. Changing your phone plan to save ¥5,000/month is more effective than skipping ¥100 daily at the convenience store.',
  'Budget phone (-¥5,000/mo), insurance review (-¥3,000/mo), cancel unused subscriptions (-¥2,000/mo) = ¥120,000 saved per year.',
  ARRAY['fixed_expenses', 'variable_expenses', 'savings_rate'],
  16,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'savings_rate',
  '📈',
  'household',
  '貯蓄率',
  '収入のうち貯蓄に回す割合',
  '手取り収入のうち、貯蓄や投資に回せた割合のことです。

理想は手取りの20%以上と言われています。まずは10%から始めて、徐々に増やしていくのがおすすめです。Hareruのレポート機能で毎月チェックできます。',
  '手取り25万円で毎月5万円を貯蓄すると、貯蓄率は20%。年間60万円が貯まります。',
  '저축률',
  '수입 중 저축하는 비율',
  '실수령액 중 저축이나 투자에 돌린 비율입니다.

이상적으로는 실수령액의 20% 이상이라고 합니다. 우선 10%부터 시작해서 점차 늘려가는 것이 추천됩니다.',
  '실수령액 25만엔에서 매달 5만엔을 저축하면 저축률은 20%. 연간 60만엔이 모입니다.',
  'Savings Rate',
  'Percentage of income saved',
  'The portion of take-home pay directed to savings or investments.

The ideal target is 20%+ of take-home pay. Start with 10% and gradually increase. Track it monthly with Hareru''s report feature.',
  'Saving ¥50,000 from a ¥250,000 take-home pay gives a 20% savings rate — ¥600,000 per year.',
  ARRAY['disposable_income', 'take_home_pay', 'saving_money'],
  17,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'income_tax',
  '🏛️',
  'tax',
  '所得税',
  '所得にかかる国の税金',
  '個人の所得に対してかかる国の税金です。所得が多いほど税率が高くなる「累進課税」方式を採用しています。

税率は5%〜45%の7段階。会社員の場合は給料から天引きされるため、普段はあまり意識しないかもしれません。',
  '年収400万円（課税所得約270万円）の場合、所得税は約14万円。月の給料から約1.2万円が天引きされています。',
  '소득세',
  '소득에 부과되는 국세',
  '개인의 소득에 부과되는 국세입니다. 소득이 많을수록 세율이 높아지는 "누진과세" 방식을 채택하고 있습니다.

세율은 5%~45%의 7단계. 회사원의 경우 급여에서 원천징수되므로 평소에는 잘 의식하지 못할 수 있습니다.',
  '연수입 400만엔(과세소득 약 270만엔)의 경우, 소득세는 약 14만엔. 월급에서 약 1.2만엔이 원천징수됩니다.',
  'Income Tax',
  'National tax on income',
  'A national tax on personal income using a progressive system where higher earners pay higher rates.

Rates range from 5% to 45% in 7 brackets. For employees, it is automatically deducted from salary.',
  'With annual income of ¥4M (taxable income ~¥2.7M), income tax is about ¥140,000 — roughly ¥12,000 deducted monthly.',
  ARRAY['resident_tax', 'year_end_adjustment', 'tax_return'],
  18,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'resident_tax',
  '🏘️',
  'tax',
  '住民税',
  '住んでいる地域に納める税金',
  '住んでいる都道府県と市区町村に納める地方税です。前年の所得に対して約10%かかります。

所得税と違い、税率は一律10%（都道府県4%＋市区町村6%）。1月1日時点の住所地に納税します。',
  '前年の課税所得が300万円なら、住民税は約30万円。月2.5万円が翌年6月から天引きされます。',
  '주민세',
  '거주지에 내는 지방세',
  '거주하는 도도부현과 시구정촌에 내는 지방세입니다. 전년 소득에 대해 약 10%가 부과됩니다.

소득세와 달리 세율은 일률 10%(도도부현 4% + 시구정촌 6%). 1월 1일 기준 주소지에 납세합니다.',
  '전년 과세소득이 300만엔이면 주민세는 약 30만엔. 다음 해 6월부터 월 2.5만엔이 원천징수됩니다.',
  'Resident Tax',
  'Tax paid to your local area',
  'A local tax paid to your prefecture and municipality, roughly 10% of the previous year''s income.

Unlike income tax, the rate is flat at 10% (4% prefecture + 6% city). It is based on where you live on January 1st.',
  'With ¥3M taxable income last year, resident tax is about ¥300,000 — deducted at ¥25,000/month starting June.',
  ARRAY['income_tax', 'hometown_tax', 'social_insurance'],
  19,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'tax_return',
  '📋',
  'tax',
  '確定申告',
  '1年間の税金を自分で申告',
  '1年間の所得と税額を自分で計算し、税務署に申告する手続きです。毎年2月16日〜3月15日に行います。

フリーランスや副業がある人は必須。会社員でも医療費控除やふるさと納税の還付を受けるときに必要です。',
  '副業で年間20万円以上の所得がある会社員は確定申告が必要。医療費が年10万円を超えた場合も、申告すれば還付金が戻ってきます。',
  '확정신고',
  '1년간의 세금을 직접 신고',
  '1년간의 소득과 세액을 직접 계산하여 세무서에 신고하는 절차입니다. 매년 2월 16일~3월 15일에 합니다.

프리랜서나 부업이 있는 사람은 필수. 회사원도 의료비공제나 고향납세 환급을 받을 때 필요합니다.',
  '부업으로 연간 20만엔 이상 소득이 있는 회사원은 확정신고가 필요합니다. 의료비가 연 10만엔을 초과한 경우에도 신고하면 환급금이 돌아옵니다.',
  'Tax Return',
  'Filing your annual taxes',
  'The process of calculating and reporting your annual income and taxes. Filed from February 16 to March 15 each year.

Mandatory for freelancers and side-job earners. Even employees need it for medical deductions or hometown tax refunds.',
  'Employees with side income over ¥200,000/year must file. If medical expenses exceed ¥100,000, filing gets you a tax refund.',
  ARRAY['income_tax', 'medical_deduction', 'hometown_tax'],
  20,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'year_end_adjustment',
  '💼',
  'tax',
  '年末調整',
  '会社が行う税金の精算',
  '会社が社員の代わりに1年間の所得税を精算する手続きです。毎年11〜12月に会社から書類を提出するよう求められます。

生命保険料控除や配偶者控除を申告でき、払いすぎた税金が12月の給料と一緒に還付されます。',
  '生命保険料を年8万円支払っている場合、年末調整で申告すると約4,000円の税金が戻ってきます。',
  '연말정산',
  '회사가 하는 세금 정산',
  '회사가 직원 대신 1년간의 소득세를 정산하는 절차입니다. 매년 11~12월에 회사에서 서류 제출을 요구합니다.

생명보험료 공제나 배우자 공제를 신고할 수 있으며, 과납된 세금이 12월 급여와 함께 환급됩니다.',
  '생명보험료를 연 8만엔 납부하고 있다면, 연말정산에서 신고하면 약 4,000엔의 세금이 돌아옵니다.',
  'Year-end Adjustment',
  'Employer tax settlement',
  'A process where your employer settles your income tax for the year. Documents are submitted in November-December.

You can claim life insurance and spouse deductions, and overpaid taxes are refunded with your December salary.',
  'If you pay ¥80,000/year in life insurance premiums, filing through year-end adjustment returns about ¥4,000 in taxes.',
  ARRAY['income_tax', 'insurance_deduction', 'dependent_deduction'],
  21,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'national_pension',
  '🧓',
  'tax',
  '国民年金',
  '20歳以上全員が加入する年金',
  '日本に住む20歳以上60歳未満のすべての人が加入する公的年金です。

月額保険料は約16,980円（2025年度）。40年間すべて納付すると、65歳から月約6.8万円の老齢基礎年金を受け取れます。',
  '20歳から60歳まで40年間保険料を納めると、65歳から月約6.8万円の年金が終身で受け取れます。年間約81万円です。',
  '국민연금',
  '20세 이상 전원이 가입하는 연금',
  '일본에 거주하는 20세 이상 60세 미만 모든 사람이 가입하는 공적 연금입니다.

월 보험료는 약 16,980엔(2025년도). 40년간 전액 납부하면 65세부터 월 약 6.8만엔의 노령기초연금을 받을 수 있습니다.',
  '20세부터 60세까지 40년간 보험료를 납부하면, 65세부터 월 약 6.8만엔의 연금을 평생 받을 수 있습니다. 연간 약 81만엔입니다.',
  'National Pension',
  'Pension for all residents 20+',
  'A public pension for all residents in Japan aged 20-59.

Monthly premiums are about ¥16,980 (2025). Paying for the full 40 years entitles you to about ¥68,000/month in basic pension from age 65.',
  'Paying premiums from age 20 to 60 (40 years) gives you about ¥68,000/month for life from age 65 — roughly ¥810,000/year.',
  ARRAY['employee_pension', 'social_insurance', 'ideco'],
  22,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'employee_pension',
  '🏢',
  'tax',
  '厚生年金',
  '会社員が加入する上乗せ年金',
  '会社員や公務員が国民年金に上乗せして加入する年金制度です。

保険料は給料の約18.3%で、会社と本人が半分ずつ負担します。国民年金に加えてもらえるため、将来の年金額が多くなります。',
  '月給30万円の場合、厚生年金保険料は約2.7万円（本人負担分）。65歳からは国民年金と合わせて月約15万円の年金が見込めます。',
  '후생연금',
  '회사원이 가입하는 추가 연금',
  '회사원이나 공무원이 국민연금에 추가로 가입하는 연금 제도입니다.

보험료는 급여의 약 18.3%로 회사와 본인이 반씩 부담합니다. 국민연금에 더해 받으므로 장래 연금액이 많아집니다.',
  '월급 30만엔의 경우, 후생연금 보험료는 약 2.7만엔(본인 부담분). 65세부터 국민연금과 합쳐 월 약 15만엔의 연금이 예상됩니다.',
  'Employee''s Pension',
  'Additional pension for employees',
  'An additional pension on top of National Pension for company employees and civil servants.

Premiums are about 18.3% of salary, split equally between employer and employee. This results in higher pension payments in retirement.',
  'With a ¥300,000 monthly salary, your pension premium is about ¥27,000. Combined with National Pension, expect about ¥150,000/month from age 65.',
  ARRAY['national_pension', 'social_insurance', 'take_home_pay'],
  23,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'social_insurance',
  '🛡️',
  'tax',
  '社会保険料',
  '健康保険と年金の保険料',
  '健康保険料、厚生年金保険料、雇用保険料などをまとめた保険料の総称です。

給料から天引きされる金額の中で最も大きな割合を占め、額面の約15%になります。手取りが思ったより少ない原因の多くはこの社会保険料です。',
  '月給30万円の場合、社会保険料は合計約4.5万円。所得税・住民税を合わせると、手取りは約23万円になります。',
  '사회보험료',
  '건강보험과 연금 보험료',
  '건강보험료, 후생연금보험료, 고용보험료 등을 합한 보험료의 총칭입니다.

급여에서 공제되는 금액 중 가장 큰 비율을 차지하며, 액면의 약 15%가 됩니다. 실수령액이 예상보다 적은 원인의 대부분은 이 사회보험료입니다.',
  '월급 30만엔의 경우, 사회보험료는 합계 약 4.5만엔. 소득세·주민세를 합치면 실수령액은 약 23만엔이 됩니다.',
  'Social Insurance',
  'Health and pension premiums',
  'A collective term for health insurance, pension, and employment insurance premiums.

It accounts for the largest deduction from your salary — about 15% of gross pay. This is the main reason take-home pay feels lower than expected.',
  'On a ¥300,000 salary, social insurance totals about ¥45,000. Combined with income and resident tax, take-home drops to about ¥230,000.',
  ARRAY['health_insurance', 'employee_pension', 'take_home_pay'],
  24,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'hometown_tax',
  '🎁',
  'tax',
  'ふるさと納税',
  '寄付して返礼品をもらう制度',
  '好きな自治体に寄付すると、翌年の住民税が控除され、さらに返礼品がもらえる制度です。

自己負担は2,000円だけ。年収に応じた上限額の範囲内で、実質2,000円でお肉やお米などの特産品がもらえるお得な制度です。',
  '年収500万円なら約6万円が上限。5万円をふるさと納税すると、自己負担2,000円で約1.5万円相当のお肉がもらえ、残り4.8万円は住民税から控除されます。',
  '고향납세',
  '기부하고 답례품을 받는 제도',
  '좋아하는 지자체에 기부하면 다음 해 주민세가 공제되고, 답례품도 받을 수 있는 제도입니다.

자기 부담은 2,000엔뿐. 연수입에 따른 상한액 범위 내에서 실질 2,000엔으로 고기나 쌀 등 특산품을 받을 수 있는 알찬 제도입니다.',
  '연수입 500만엔이면 약 6만엔이 상한. 5만엔을 고향납세하면, 자기 부담 2,000엔으로 약 1.5만엔 상당의 고기를 받고, 나머지 4.8만엔은 주민세에서 공제됩니다.',
  'Hometown Tax',
  'Donate to regions, get gifts',
  'A system where donations to local governments reduce next year''s resident tax, plus you receive regional gifts.

Your out-of-pocket cost is just ¥2,000. Within your income-based limit, you essentially get regional specialties like beef or rice for only ¥2,000.',
  'With ¥5M income, the limit is about ¥60,000. Donating ¥50,000 gets you ~¥15,000 worth of beef for just ¥2,000 out-of-pocket, with ¥48,000 deducted from resident tax.',
  ARRAY['resident_tax', 'tax_return', 'income_tax'],
  25,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'health_insurance',
  '🏥',
  'insurance',
  '健康保険',
  '医療費を3割負担にする保険',
  '病気やケガの治療費を3割の自己負担で済むようにする公的保険です。

会社員は会社の健康保険に加入し、保険料は会社と折半。自営業者やフリーランスは国民健康保険に加入します。',
  '風邪で病院に行き治療費が5,000円かかった場合、健康保険のおかげで自己負担は1,500円で済みます。',
  '건강보험',
  '의료비를 3할 부담으로 하는 보험',
  '질병이나 부상 치료비를 3할 자기부담으로 줄여주는 공적 보험입니다.

회사원은 회사 건강보험에 가입하며, 보험료는 회사와 반씩 부담합니다. 자영업자나 프리랜서는 국민건강보험에 가입합니다.',
  '감기로 병원에 가서 치료비가 5,000엔이 든 경우, 건강보험 덕분에 자기부담은 1,500엔으로 줄어듭니다.',
  'Health Insurance',
  'Insurance covering 70% of medical costs',
  'Public insurance that reduces medical costs to a 30% co-pay.

Employees join their company''s plan with premiums split with the employer. Self-employed join National Health Insurance.',
  'A ¥5,000 doctor visit costs you only ¥1,500 out-of-pocket thanks to health insurance covering 70%.',
  ARRAY['social_insurance', 'high_cost_medical', 'life_insurance'],
  26,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'life_insurance',
  '🩺',
  'insurance',
  '生命保険',
  '万一に備える民間の保険',
  '死亡や高度障害になったときに保険金が支払われる民間の保険です。

家族がいる人は特に重要ですが、独身なら最低限の保障で十分な場合も。保険料は年末調整で控除が受けられます。',
  '月3,000円の掛け捨て生命保険に加入すれば、万一の際に2,000万円の保険金が家族に支払われます。',
  '생명보험',
  '만일에 대비하는 민간 보험',
  '사망이나 고도장애 시 보험금이 지급되는 민간 보험입니다.

가족이 있는 사람에게 특히 중요하지만, 미혼이라면 최소한의 보장으로 충분한 경우도 있습니다. 보험료는 연말정산에서 공제받을 수 있습니다.',
  '월 3,000엔의 정기 생명보험에 가입하면, 만일의 경우 2,000만엔의 보험금이 가족에게 지급됩니다.',
  'Life Insurance',
  'Private insurance for emergencies',
  'Private insurance that pays out upon death or severe disability.

Especially important for those with families, but singles may need only minimal coverage. Premiums qualify for tax deductions.',
  'A ¥3,000/month term life policy provides ¥20M to your family in case of death.',
  ARRAY['insurance_deduction', 'health_insurance', 'property_insurance'],
  27,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'property_insurance',
  '🚗',
  'insurance',
  '損害保険',
  '事故や災害の損害を補償',
  '火災、自動車事故、自然災害などで発生した損害を補償する保険です。

自動車保険や火災保険が代表的。賃貸住宅の場合は入居時に火災保険への加入が必須です。',
  '自動車保険は年間約5万円、火災保険（賃貸）は年間約5,000円。交通事故の損害賠償は数千万円になることもあるため、加入は必須です。',
  '손해보험',
  '사고나 재해 손해를 보상',
  '화재, 자동차 사고, 자연재해 등으로 발생한 손해를 보상하는 보험입니다.

자동차보험이나 화재보험이 대표적입니다. 임대주택의 경우 입주 시 화재보험 가입이 필수입니다.',
  '자동차보험은 연간 약 5만엔, 화재보험(임대)은 연간 약 5,000엔. 교통사고 손해배상은 수천만엔이 될 수 있어 가입이 필수입니다.',
  'Property Insurance',
  'Covers accident and disaster damage',
  'Insurance that compensates for damage from fires, car accidents, and natural disasters.

Car insurance and fire insurance are the main types. Renters are usually required to have fire insurance.',
  'Car insurance costs about ¥50,000/year, renter''s fire insurance about ¥5,000/year. Accident liability can reach tens of millions of yen.',
  ARRAY['life_insurance', 'health_insurance', 'fixed_expenses'],
  28,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'insurance_deduction',
  '📄',
  'insurance',
  '保険料控除',
  '保険料で税金が安くなる',
  '生命保険や医療保険の保険料を支払っていると、その分だけ所得税と住民税が安くなる制度です。

年末調整や確定申告で申告できます。一般生命保険・介護医療保険・個人年金保険の3種類があり、それぞれ最大4万円まで控除されます。',
  '生命保険料を年8万円支払うと、最大4万円の所得控除。所得税率10%なら約4,000円、住民税と合わせて約6,800円の節税になります。',
  '보험료공제',
  '보험료로 세금이 줄어듦',
  '생명보험이나 의료보험 보험료를 납부하면, 그만큼 소득세와 주민세가 줄어드는 제도입니다.

연말정산이나 확정신고에서 신고할 수 있습니다. 일반생명보험·개호의료보험·개인연금보험 3종류가 있으며, 각각 최대 4만엔까지 공제됩니다.',
  '생명보험료를 연 8만엔 납부하면 최대 4만엔의 소득공제. 소득세율 10%라면 약 4,000엔, 주민세와 합쳐 약 6,800엔의 절세가 됩니다.',
  'Insurance Deduction',
  'Tax reduction for insurance premiums',
  'A system that reduces income and resident taxes based on insurance premiums paid.

Claimable through year-end adjustment or tax returns. Three categories (life, medical care, personal pension) each allow up to ¥40,000 deduction.',
  'Paying ¥80,000/year in life insurance premiums gives up to ¥40,000 deduction — saving about ¥6,800 in combined taxes at the 10% bracket.',
  ARRAY['life_insurance', 'year_end_adjustment', 'tax_return'],
  29,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'high_cost_medical',
  '🤕',
  'insurance',
  '高額療養費',
  '医療費の自己負担に上限',
  '1ヶ月の医療費の自己負担額が上限を超えた場合、超えた分が払い戻される制度です。

年収370万円以下の場合、月の上限は約5.7万円。手術や入院で高額になっても安心です。事前に「限度額適用認定証」を取得しておくと窓口での支払いが上限額で済みます。',
  '入院手術で医療費が100万円かかっても、3割負担の30万円のうち、高額療養費で約24.3万円が戻り、実質約5.7万円で済みます。',
  '고액요양비',
  '의료비 자기부담에 상한선',
  '1개월 의료비 자기부담액이 상한을 초과하면, 초과분이 환급되는 제도입니다.

연수입 370만엔 이하의 경우, 월 상한은 약 5.7만엔. 수술이나 입원으로 고액이 되어도 안심입니다. 미리 "한도액적용인정증"을 받아두면 창구 지불이 상한액으로 끝납니다.',
  '입원 수술로 의료비가 100만엔이 들어도, 3할 부담 30만엔 중 고액요양비로 약 24.3만엔이 환급되어 실질 약 5.7만엔으로 끝납니다.',
  'High-cost Medical',
  'Cap on medical out-of-pocket costs',
  'A system that refunds medical costs exceeding a monthly cap.

For income under ¥3.7M, the cap is about ¥57,000/month. Even expensive surgeries or hospitalization are covered. Get a "Limit Certificate" in advance to pay only the cap at the hospital.',
  'Even if surgery costs ¥1M, your 30% co-pay of ¥300,000 is refunded down to about ¥57,000 through this system.',
  ARRAY['health_insurance', 'medical_deduction', 'social_insurance'],
  30,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'childbirth_lump_sum',
  '👶',
  'insurance',
  '出産育児一時金',
  '出産時に50万円がもらえる',
  '出産したときに健康保険から支給される一時金です。2023年4月から1児につき50万円に増額されました。

直接支払制度を利用すれば、病院への支払いから自動的に差し引かれるため、大きな出費を事前に用意する必要がありません。',
  '出産費用が48万円の場合、出産育児一時金50万円で全額カバーされ、2万円が手元に残ります。',
  '출산육아일시금',
  '출산 시 50만엔을 받을 수 있음',
  '출산했을 때 건강보험에서 지급되는 일시금입니다. 2023년 4월부터 1아이당 50만엔으로 증액되었습니다.

직접지불제도를 이용하면 병원 지불에서 자동으로 차감되므로, 큰 금액을 미리 준비할 필요가 없습니다.',
  '출산비용이 48만엔인 경우, 출산육아일시금 50만엔으로 전액 커버되어 2만엔이 남습니다.',
  'Childbirth Lump Sum',
  '¥500,000 payment for childbirth',
  'A lump sum from health insurance upon childbirth — ¥500,000 per child since April 2023.

Using the direct payment system, it is automatically deducted from hospital bills, so you don''t need to prepare a large amount upfront.',
  'If delivery costs ¥480,000, the ¥500,000 lump sum covers it entirely with ¥20,000 left over.',
  ARRAY['health_insurance', 'high_cost_medical', 'dependent_deduction'],
  31,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'compound_interest',
  '🏦',
  'savings',
  '複利',
  '利息にも利息がつく仕組み',
  '元本だけでなく、それまでについた利息にも利息がつく仕組みです。

「利息が利息を生む」ため、時間が経つほど雪だるま式にお金が増えます。アインシュタインが「人類最大の発明」と呼んだとも言われています。長期投資で最も大切な概念です。',
  '100万円を年利5%で30年間複利運用すると約432万円に。単利なら250万円なので、複利の効果で182万円も多くなります。',
  '복리',
  '이자에도 이자가 붙는 구조',
  '원금뿐만 아니라 지금까지 붙은 이자에도 이자가 붙는 구조입니다.

"이자가 이자를 낳기" 때문에 시간이 지날수록 눈덩이처럼 돈이 불어납니다. 장기 투자에서 가장 중요한 개념입니다.',
  '100만엔을 연 5%로 30년간 복리 운용하면 약 432만엔으로. 단리면 250만엔이므로, 복리 효과로 182만엔이나 더 많아집니다.',
  'Compound Interest',
  'Interest earned on interest',
  'A system where interest is earned not just on the principal, but also on accumulated interest.

Money grows like a snowball over time as "interest earns interest." This is the most important concept in long-term investing.',
  '¥1M at 5% for 30 years grows to ¥4.32M with compound interest, versus ¥2.5M with simple interest — ¥1.82M more.',
  ARRAY['simple_interest', 'new_nisa', 'dollar_cost_averaging'],
  32,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'simple_interest',
  '📉',
  'savings',
  '単利',
  '元本にだけ利息がつく',
  '最初の元本に対してのみ利息がつく計算方法です。

複利と違い、利息が利息を生まないため、長期で見ると資産の増え方が大きく異なります。銀行の定期預金は複利型が多いですが、債券の利子は単利的です。',
  '100万円を年利5%の単利で10年運用すると150万円。同じ条件の複利なら約163万円になり、13万円の差がつきます。',
  '단리',
  '원금에만 이자가 붙음',
  '최초 원금에 대해서만 이자가 붙는 계산 방법입니다.

복리와 달리 이자가 이자를 낳지 않으므로, 장기적으로 보면 자산 증가 방식이 크게 다릅니다.',
  '100만엔을 연 5% 단리로 10년 운용하면 150만엔. 같은 조건의 복리라면 약 163만엔이 되어 13만엔 차이가 납니다.',
  'Simple Interest',
  'Interest only on principal',
  'A method where interest is calculated only on the original principal.

Unlike compound interest, interest doesn''t earn interest, so long-term growth is significantly lower.',
  '¥1M at 5% simple interest for 10 years = ¥1.5M. Compound interest = ¥1.63M — a ¥130,000 difference.',
  ARRAY['compound_interest', 'interest_rate', 'savings_rate'],
  33,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'new_nisa',
  '🪙',
  'savings',
  '新NISA',
  '非課税で投資できる制度',
  '2024年から始まった新しい少額投資非課税制度です。

「つみたて投資枠」（年120万円）と「成長投資枠」（年240万円）の2つがあり、合計で年間360万円まで非課税で投資できます。非課税保有限度額は1,800万円で、期間は無期限です。',
  '毎月3万円をつみたて投資枠で積み立てると、年間36万円。20年続けると720万円の投資利益がすべて非課税になります。',
  '신NISA',
  '비과세로 투자할 수 있는 제도',
  '2024년부터 시작된 새로운 소액투자 비과세 제도입니다.

"적립투자 한도"(연 120만엔)와 "성장투자 한도"(연 240만엔) 2가지가 있어, 합계 연 360만엔까지 비과세로 투자할 수 있습니다. 비과세 보유 한도는 1,800만엔이며, 기간은 무기한입니다.',
  '매달 3만엔을 적립투자 한도로 적립하면 연간 36만엔. 20년 계속하면 720만엔의 투자 수익이 모두 비과세가 됩니다.',
  'New NISA',
  'Tax-free investment program',
  'A tax-free investment program started in 2024 in Japan.

It has two tracks: "Regular Investment" (¥1.2M/year) and "Growth Investment" (¥2.4M/year), totaling ¥3.6M annually tax-free. The lifetime limit is ¥18M with no time restriction.',
  'Investing ¥30,000 monthly = ¥360,000/year. After 20 years, all gains on your ¥7.2M investment are completely tax-free.',
  ARRAY['ideco', 'mutual_fund', 'dollar_cost_averaging'],
  34,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'ideco',
  '🧮',
  'savings',
  'iDeCo',
  '自分で作る私的年金',
  '個人型確定拠出年金の愛称で、自分で掛金を積み立てて運用する私的年金制度です。

掛金が全額所得控除になるため節税効果が大きく、運用益も非課税。ただし原則60歳まで引き出せません。',
  '会社員が月2.3万円をiDeCoに積み立てると、年27.6万円が所得控除に。税率20%なら年5.5万円の節税、30年で165万円のお得です。',
  'iDeCo',
  '스스로 만드는 사적 연금',
  '개인형 확정기여연금의 애칭으로, 직접 납입금을 적립하여 운용하는 사적 연금 제도입니다.

납입금 전액이 소득공제되어 절세 효과가 크고, 운용 수익도 비과세입니다. 단, 원칙적으로 60세까지 인출할 수 없습니다.',
  '회사원이 월 2.3만엔을 iDeCo에 적립하면, 연 27.6만엔이 소득공제 됩니다. 세율 20%라면 연 5.5만엔 절세, 30년이면 165만엔 이득입니다.',
  'iDeCo',
  'Self-directed private pension',
  'A self-directed private pension where you invest your own contributions.

Contributions are fully tax-deductible with tax-free investment gains. However, funds are locked until age 60.',
  'An employee contributing ¥23,000/month gets ¥276,000 in annual tax deductions. At 20% tax rate, that''s ¥55,000/year saved — ¥1.65M over 30 years.',
  ARRAY['new_nisa', 'compound_interest', 'national_pension'],
  35,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'mutual_fund',
  '📊',
  'savings',
  '投資信託',
  'プロが運用する投資商品',
  '多くの投資家から集めたお金をプロのファンドマネージャーが株式や債券などに分散投資する金融商品です。

100円から購入でき、少額から分散投資が可能。新NISAのつみたて投資枠で購入できる商品の多くが投資信託です。',
  '全世界株式の投資信託に毎月1万円を積み立てると、年利5%で20年後には約411万円に。元本240万円に対して約171万円の利益です。',
  '투자신탁',
  '전문가가 운용하는 투자 상품',
  '많은 투자자로부터 모은 돈을 전문 펀드매니저가 주식이나 채권 등에 분산투자하는 금융상품입니다.

100엔부터 구매할 수 있어 소액부터 분산투자가 가능합니다. 신NISA 적립투자 한도로 구매할 수 있는 상품의 대부분이 투자신탁입니다.',
  '전세계 주식 투자신탁에 매달 1만엔을 적립하면, 연 5%로 20년 후 약 411만엔으로. 원금 240만엔에 대해 약 171만엔의 수익입니다.',
  'Mutual Fund',
  'Professionally managed investment',
  'A financial product where professional managers invest pooled money across stocks and bonds.

Available from just ¥100, enabling diversification with small amounts. Most products in New NISA''s regular track are mutual funds.',
  'Investing ¥10,000/month in a global stock fund at 5% annual return grows to about ¥4.11M in 20 years — ¥1.71M in gains on ¥2.4M invested.',
  ARRAY['new_nisa', 'diversification', 'dollar_cost_averaging'],
  36,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'stock_investment',
  '💹',
  'savings',
  '株式投資',
  '会社の株を買って利益を得る',
  '企業の株式を購入し、値上がり益（キャピタルゲイン）や配当金（インカムゲイン）を得る投資方法です。

個別株はリスクが高い反面、大きなリターンの可能性も。初心者は投資信託から始め、慣れてから個別株に挑戦するのがおすすめです。',
  '1株1,000円の株を100株（10万円）購入し、1,500円に値上がりしたら15万円に。5万円の利益ですが、20.315%の税金がかかり手取りは約4万円です。',
  '주식투자',
  '회사 주식을 사서 이익을 얻음',
  '기업의 주식을 구매하여 시세 차익(캐피털게인)이나 배당금(인컴게인)을 얻는 투자 방법입니다.

개별주는 리스크가 높은 반면 큰 수익 가능성도 있습니다. 초보자는 투자신탁부터 시작하고 익숙해지면 개별주에 도전하는 것을 추천합니다.',
  '1주 1,000엔인 주식을 100주(10만엔) 구매하고 1,500엔으로 오르면 15만엔으로. 5만엔 이익이지만 20.315% 세금이 붙어 실수익은 약 4만엔입니다.',
  'Stock Investment',
  'Buying company shares for profit',
  'Buying company shares to profit from price increases (capital gains) or dividends (income gains).

Individual stocks carry higher risk but offer higher potential returns. Beginners should start with mutual funds before trying individual stocks.',
  'Buy 100 shares at ¥1,000 (¥100,000 total). If price rises to ¥1,500, your ¥50,000 profit is taxed at 20.315%, netting about ¥40,000.',
  ARRAY['mutual_fund', 'diversification', 'risk_tolerance'],
  37,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'diversification',
  '🎯',
  'savings',
  '分散投資',
  'リスクを分けて投資する',
  '資産を複数の投資先に分けてリスクを軽減する方法です。

「卵を1つのカゴに盛るな」という格言の通り、株式・債券・不動産・国内・海外など、異なる種類の資産に分散させることが大切です。',
  'A社の株に100万円集中投資→倒産で0円に。全世界株式の投資信託なら、数千社に分散されるため1社の影響は限定的です。',
  '분산투자',
  '리스크를 나눠서 투자함',
  '자산을 여러 투자처에 나눠 리스크를 줄이는 방법입니다.

"달걀을 한 바구니에 담지 마라"는 격언처럼, 주식·채권·부동산·국내·해외 등 다양한 종류의 자산에 분산시키는 것이 중요합니다.',
  'A사 주식에 100만엔 집중투자→파산으로 0엔. 전세계 주식 투자신탁이라면 수천 개 회사에 분산되어 1개 회사 영향은 제한적입니다.',
  'Diversification',
  'Spreading risk across investments',
  'A method of reducing risk by spreading investments across multiple asset types.

As the saying goes, "don''t put all your eggs in one basket." Diversify across stocks, bonds, real estate, domestic and international markets.',
  '¥1M in one company stock → bankruptcy means ¥0. A global stock fund spreads across thousands of companies, limiting any single company''s impact.',
  ARRAY['mutual_fund', 'risk_tolerance', 'dollar_cost_averaging'],
  38,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'dollar_cost_averaging',
  '💎',
  'savings',
  '積立投資',
  '毎月一定額をコツコツ投資',
  '毎月決まった金額を定期的に投資する方法です。

価格が高い時は少なく、安い時は多く買えるため、平均購入単価が平準化されます。タイミングを気にせず始められるので、投資初心者に最適な方法です。',
  '毎月3万円を積立投資。株価が高い月は30口、安い月は50口と自動調整されるため、長期的に有利な平均取得単価になります。',
  '적립투자',
  '매달 일정 금액을 꾸준히 투자',
  '매달 정해진 금액을 정기적으로 투자하는 방법입니다.

가격이 높을 때는 적게, 낮을 때는 많이 살 수 있어 평균 매입 단가가 평준화됩니다. 타이밍을 신경 쓰지 않아도 되므로 투자 초보자에게 최적의 방법입니다.',
  '매달 3만엔을 적립투자. 주가가 높은 달은 30구좌, 낮은 달은 50구좌로 자동 조정되어, 장기적으로 유리한 평균 취득 단가가 됩니다.',
  'Dollar-cost Averaging',
  'Investing a fixed amount regularly',
  'Investing a fixed amount at regular intervals, typically monthly.

You buy more shares when prices are low and fewer when high, averaging out the cost. Perfect for beginners since you don''t need to time the market.',
  'Investing ¥30,000/month: you buy 30 units when prices are high, 50 when low — automatically averaging your cost over time.',
  ARRAY['new_nisa', 'compound_interest', 'mutual_fund'],
  39,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'risk_tolerance',
  '⚖️',
  'savings',
  'リスク許容度',
  'どれだけ損失に耐えられるか',
  '投資でどの程度の値下がり（損失）を精神的・経済的に受け入れられるかの度合いです。

年齢が若い、収入が安定している、貯蓄が多い人はリスク許容度が高い傾向があります。自分のリスク許容度に合った投資を選ぶことが長続きのコツです。',
  '100万円投資して20万円の含み損（-20%）になったとき、平気な人はリスク許容度が高め。不安で眠れない人は、もっと安定的な運用がおすすめです。',
  '위험허용도',
  '얼마나 손실을 감내할 수 있는가',
  '투자에서 어느 정도의 가격 하락(손실)을 정신적·경제적으로 감내할 수 있는지의 정도입니다.

나이가 젊고, 수입이 안정적이며, 저축이 많은 사람은 위험허용도가 높은 경향이 있습니다. 자신의 위험허용도에 맞는 투자를 선택하는 것이 오래 지속하는 비결입니다.',
  '100만엔 투자해서 20만엔 평가손(-20%)이 났을 때, 괜찮은 사람은 위험허용도가 높은 편. 불안해서 잠이 안 오는 사람은 더 안정적인 운용을 추천합니다.',
  'Risk Tolerance',
  'How much loss you can handle',
  'The degree of investment loss you can psychologically and financially accept.

Younger people with stable income and more savings tend to have higher risk tolerance. Choosing investments matching your tolerance is key to staying the course.',
  'If a ¥1M investment drops ¥200,000 (-20%) and you''re fine, your risk tolerance is high. If you lose sleep over it, consider more stable investments.',
  ARRAY['diversification', 'stock_investment', 'mutual_fund'],
  40,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'mortgage',
  '🏠',
  'loan',
  '住宅ローン',
  '家を買うための長期借入',
  '住宅を購入するために金融機関から借りるお金のことです。最長35年で返済するのが一般的です。

変動金利と固定金利があり、現在は変動金利が約0.3〜0.5%と歴史的低金利。住宅ローン控除で税金の還付も受けられます。',
  '3,500万円の住宅ローンを変動金利0.4%で35年返済すると、月々の返済額は約8.9万円。総返済額は約3,750万円になります。',
  '주택론',
  '집을 사기 위한 장기 대출',
  '주택을 구매하기 위해 금융기관에서 빌리는 돈입니다. 최장 35년에 걸쳐 상환하는 것이 일반적입니다.

변동금리와 고정금리가 있으며, 현재 변동금리는 약 0.3~0.5%로 역사적 저금리입니다. 주택론공제로 세금 환급도 받을 수 있습니다.',
  '3,500만엔의 주택론을 변동금리 0.4%로 35년 상환하면, 월 상환액은 약 8.9만엔. 총 상환액은 약 3,750만엔이 됩니다.',
  'Mortgage',
  'Long-term loan for buying a home',
  'Money borrowed from a bank to buy a home, typically repaid over up to 35 years.

Choose between variable (currently ~0.3-0.5%) and fixed rates. Mortgage tax deductions provide additional tax refunds.',
  'A ¥35M mortgage at 0.4% variable rate over 35 years costs about ¥89,000/month, totaling approximately ¥37.5M.',
  ARRAY['interest_rate', 'mortgage_deduction', 'prepayment'],
  41,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'revolving_payment',
  '💳',
  'loan',
  'リボ払い',
  '毎月定額返済だが高金利',
  'クレジットカードの支払い方法の一つで、利用額に関わらず毎月一定額を返済する方式です。

一見便利ですが、金利が年15%前後と非常に高く、支払い残高が膨らみやすい危険な仕組みです。気づかないうちに多額の借金になるケースが多発しています。',
  '30万円をリボ払い（月1万円返済、金利15%）にすると、完済まで約3年かかり、利息だけで約7万円。絶対に避けるべき支払い方法です。',
  '리볼빙',
  '매달 정액 상환하지만 고금리',
  '신용카드 결제 방식의 하나로, 이용 금액에 관계없이 매달 일정 금액을 상환하는 방식입니다.

편리해 보이지만 금리가 연 15% 전후로 매우 높고, 잔액이 불어나기 쉬운 위험한 구조입니다. 모르는 사이에 큰 빚이 되는 경우가 많습니다.',
  '30만엔을 리볼빙(월 1만엔 상환, 금리 15%)으로 하면 완제까지 약 3년 걸리고, 이자만 약 7만엔. 절대 피해야 할 결제 방식입니다.',
  'Revolving Payment',
  'Fixed monthly payment, high interest',
  'A credit card payment method where you pay a fixed amount monthly regardless of total spending.

Seemingly convenient but extremely dangerous — interest rates are around 15% annually, and balances can snowball. Many people unknowingly accumulate massive debt.',
  '¥300,000 on revolving payment (¥10,000/month, 15% interest) takes ~3 years to pay off with ~¥70,000 in interest alone. Avoid this payment method.',
  ARRAY['interest_rate', 'multiple_debts', 'credit_score'],
  42,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'interest_rate',
  '📊',
  'loan',
  '金利',
  'お金を借りる・預ける利率',
  'お金の貸し借りに伴う利息の割合のことです。

預金金利は低い（普通預金0.02%程度）ですが、カードローンの金利は高い（14〜18%）。住宅ローンの金利は0.3〜1.5%程度。金利の差が将来の資産に大きな影響を与えます。',
  '100万円を金利0.02%の普通預金に1年預けると利息は200円。同じ金額をカードローン金利15%で借りると利息は15万円。750倍の差です。',
  '금리',
  '돈을 빌리거나 맡기는 이율',
  '돈의 대차에 따른 이자의 비율입니다.

예금 금리는 낮지만(보통예금 0.02% 정도) 카드론 금리는 높습니다(14~18%). 주택론 금리는 0.3~1.5% 정도. 금리 차이가 장래 자산에 큰 영향을 줍니다.',
  '100만엔을 금리 0.02% 보통예금에 1년 맡기면 이자는 200엔. 같은 금액을 카드론 금리 15%로 빌리면 이자는 15만엔. 750배 차이입니다.',
  'Interest Rate',
  'Rate for borrowing or saving',
  'The percentage charged on borrowed money or earned on deposits.

Savings rates are very low (~0.02%) while credit card loans charge 14-18%. Mortgage rates are 0.3-1.5%. Interest rate differences greatly impact your future wealth.',
  '¥1M in a 0.02% savings account earns ¥200/year. Borrowing ¥1M at 15% costs ¥150,000/year — a 750x difference.',
  ARRAY['mortgage', 'compound_interest', 'revolving_payment'],
  43,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'prepayment',
  '🔄',
  'loan',
  '繰上返済',
  'ローンを早めに返して利息節約',
  'ローンの毎月の返済とは別に、まとまった金額を返済する方法です。

繰上返済した分は元本に充てられるため、将来の利息を大幅に減らせます。住宅ローンの場合、返済期間を短縮する「期間短縮型」と月々の返済額を減らす「返済額軽減型」があります。',
  '住宅ローン3,000万円（金利1%、35年）で、5年目に100万円繰上返済すると、約40万円の利息が節約でき、返済期間も約1年短縮されます。',
  '조기상환',
  '대출을 빨리 갚아 이자 절약',
  '대출의 매달 상환과 별도로 목돈을 한꺼번에 상환하는 방법입니다.

조기상환한 금액은 원금에 충당되므로 장래 이자를 대폭 줄일 수 있습니다. 주택론의 경우 상환 기간을 단축하는 "기간단축형"과 월 상환액을 줄이는 "상환액경감형"이 있습니다.',
  '주택론 3,000만엔(금리 1%, 35년)에서 5년째에 100만엔을 조기상환하면, 약 40만엔의 이자가 절약되고 상환 기간도 약 1년 단축됩니다.',
  'Prepayment',
  'Paying off loans early to save interest',
  'Making extra lump-sum payments on a loan beyond regular monthly installments.

Prepayments go directly to principal, significantly reducing future interest. For mortgages, choose between shortening the term or reducing monthly payments.',
  'On a ¥30M mortgage (1%, 35 years), a ¥1M prepayment in year 5 saves about ¥400,000 in interest and shortens the term by ~1 year.',
  ARRAY['mortgage', 'interest_rate', 'saving_money'],
  44,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'multiple_debts',
  '⚠️',
  'loan',
  '多重債務',
  '複数の借金を抱えた状態',
  '複数の金融機関やカード会社から借金をしている状態です。

1社の返済のために別の会社から借りるという悪循環に陥りやすく、気づいた時には返済不能になることも。困ったら早めに弁護士や相談窓口に相談することが大切です。',
  'A社に50万円、B社に30万円、C社に20万円の借金。3社合計100万円で金利15%なら、年間15万円の利息が発生し、返済がどんどん困難になります。',
  '다중채무',
  '여러 곳에서 빚을 진 상태',
  '여러 금융기관이나 카드사에서 빚을 지고 있는 상태입니다.

한 곳의 상환을 위해 다른 곳에서 빌리는 악순환에 빠지기 쉽고, 깨달았을 때는 상환 불능이 되기도 합니다. 어려울 때는 일찍 변호사나 상담 창구에 상담하는 것이 중요합니다.',
  'A사에 50만엔, B사에 30만엔, C사에 20만엔의 빚. 3사 합계 100만엔에 금리 15%면, 연간 15만엔의 이자가 발생하여 상환이 점점 어려워집니다.',
  'Multiple Debts',
  'Owing debts to multiple lenders',
  'Being in debt to multiple financial institutions or credit card companies.

It''s easy to fall into a vicious cycle of borrowing from one to pay another. If you''re struggling, consult a lawyer or debt counseling service early.',
  '¥500K to Company A, ¥300K to B, ¥200K to C — ¥1M total at 15% interest means ¥150,000/year in interest alone, making repayment increasingly difficult.',
  ARRAY['revolving_payment', 'credit_score', 'interest_rate'],
  45,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'credit_score',
  '🏦',
  'loan',
  '信用スコア',
  '借入やカードの信用度',
  '個人の信用情報に基づく信用度の指標です。ローン返済やクレジットカードの利用履歴が記録されます。

延滞や債務整理があると信用情報に傷がつき、5〜10年間は新たなローンやカード発行が困難になります。普段から支払い期日を守ることが大切です。',
  'スマホの分割払いを3ヶ月滞納すると信用情報に「延滞」が記録され、5年間は住宅ローンの審査に通りにくくなります。',
  '신용점수',
  '대출이나 카드의 신용도',
  '개인의 신용정보에 기반한 신용도 지표입니다. 대출 상환이나 신용카드 이용 이력이 기록됩니다.

연체나 채무정리가 있으면 신용정보에 흠이 생겨 5~10년간 새로운 대출이나 카드 발급이 어려워집니다. 평소 결제 기일을 지키는 것이 중요합니다.',
  '스마트폰 할부를 3개월 연체하면 신용정보에 "연체"가 기록되어, 5년간 주택론 심사에 통과하기 어려워집니다.',
  'Credit Score',
  'Your borrowing trustworthiness',
  'A measure of creditworthiness based on your financial history, including loan repayments and credit card usage.

Late payments or debt restructuring damage your record for 5-10 years, making new loans and cards difficult. Always pay on time.',
  'Missing 3 months of phone installments marks "delinquent" on your credit record, making mortgage approval difficult for 5 years.',
  ARRAY['revolving_payment', 'multiple_debts', 'mortgage'],
  46,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'my_number',
  '🆔',
  'system',
  'マイナンバー',
  '国民全員の12桁の個人番号',
  '日本に住むすべての人に割り当てられた12桁の個人番号です。

税金、社会保険、行政手続きで使用されます。マイナンバーカードを作ると、コンビニで住民票を取得したり、確定申告をオンラインで行えるようになります。',
  'マイナンバーカードがあれば、コンビニで住民票が200〜300円で取得可能。役所に行くと300〜400円かかります。',
  '마이넘버',
  '국민 전원의 12자리 개인번호',
  '일본에 거주하는 모든 사람에게 부여된 12자리 개인번호입니다.

세금, 사회보험, 행정 절차에 사용됩니다. 마이넘버 카드를 만들면 편의점에서 주민표를 발급받거나 확정신고를 온라인으로 할 수 있습니다.',
  '마이넘버 카드가 있으면 편의점에서 주민표를 200~300엔에 발급 가능. 관청에 가면 300~400엔이 듭니다.',
  'My Number',
  '12-digit ID for all residents',
  'A 12-digit identification number assigned to all residents of Japan.

Used for taxes, social insurance, and government procedures. A My Number card lets you get resident certificates at convenience stores and file taxes online.',
  'With a My Number card, get resident certificates at convenience stores for ¥200-300 instead of ¥300-400 at city hall.',
  ARRAY['my_number_points', 'tax_return', 'hometown_tax'],
  47,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'dependent_deduction',
  '👪',
  'system',
  '扶養控除',
  '家族を養っていると税金が安く',
  '16歳以上の親族を養っている場合に受けられる所得控除です。

一般の扶養親族は38万円、19〜22歳の特定扶養親族は63万円の控除が受けられます。配偶者の場合は別途「配偶者控除」があります。',
  '大学生（20歳）の子どもを扶養していると、63万円の特定扶養控除。税率20%なら約12.6万円の節税になります。',
  '부양공제',
  '가족을 부양하면 세금이 줄어듦',
  '16세 이상의 친족을 부양하고 있는 경우 받을 수 있는 소득공제입니다.

일반 부양친족은 38만엔, 19~22세 특정부양친족은 63만엔의 공제를 받을 수 있습니다. 배우자의 경우 별도로 "배우자공제"가 있습니다.',
  '대학생(20세) 자녀를 부양하고 있으면 63만엔의 특정부양공제. 세율 20%면 약 12.6만엔의 절세가 됩니다.',
  'Dependent Deduction',
  'Tax break for supporting family',
  'An income deduction for supporting dependents aged 16 or older.

General dependents qualify for ¥380,000 deduction; dependents aged 19-22 get ¥630,000. Spouses have a separate deduction.',
  'Supporting a college-age child (20) gives a ¥630,000 deduction. At 20% tax rate, that''s about ¥126,000 in tax savings.',
  ARRAY['income_tax', '103man_wall', 'year_end_adjustment'],
  48,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'medical_deduction',
  '🧾',
  'system',
  '医療費控除',
  '医療費が多いと税金が還付',
  '年間の医療費が10万円を超えた場合、超えた分が所得から控除される制度です。

家族全員の医療費を合算できます。確定申告が必要ですが、歯科治療や処方薬代、通院の交通費も含められます。',
  '家族の医療費が年間30万円の場合、10万円を超えた20万円が控除対象。税率10%なら2万円、20%なら4万円の還付が受けられます。',
  '의료비공제',
  '의료비가 많으면 세금 환급',
  '연간 의료비가 10만엔을 초과한 경우, 초과분이 소득에서 공제되는 제도입니다.

가족 전원의 의료비를 합산할 수 있습니다. 확정신고가 필요하지만, 치과 치료나 처방약 비용, 통원 교통비도 포함됩니다.',
  '가족 의료비가 연간 30만엔인 경우, 10만엔을 초과한 20만엔이 공제 대상. 세율 10%면 2만엔, 20%면 4만엔의 환급을 받을 수 있습니다.',
  'Medical Deduction',
  'Tax refund for high medical expenses',
  'A deduction for annual medical expenses exceeding ¥100,000.

You can combine expenses for all family members. Filing a tax return is required, but dental care, prescriptions, and hospital transport costs qualify.',
  'If family medical expenses total ¥300,000, the ¥200,000 above ¥100,000 is deductible — a ¥20,000-40,000 refund depending on your tax bracket.',
  ARRAY['tax_return', 'high_cost_medical', 'income_tax'],
  49,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'employment_income_deduction',
  '💰',
  'system',
  '給与所得控除',
  '会社員の経費にあたる控除',
  '会社員の給与収入から自動的に差し引かれる控除で、仕事の必要経費にあたるものです。

自営業者が経費を差し引けるように、会社員にもこの控除があります。年収に応じて金額が決まり、確定申告は不要です。',
  '年収400万円の場合、給与所得控除は124万円。つまり課税対象は276万円となり、この金額をベースに税金が計算されます。',
  '급여소득공제',
  '회사원의 경비에 해당하는 공제',
  '회사원의 급여 수입에서 자동으로 차감되는 공제로, 업무 필요경비에 해당합니다.

자영업자가 경비를 빌 수 있는 것처럼 회사원에게도 이 공제가 있습니다. 연수입에 따라 금액이 정해지며 확정신고는 불필요합니다.',
  '연수입 400만엔의 경우, 급여소득공제는 124만엔. 즉 과세 대상은 276만엔이 되며, 이 금액을 기준으로 세금이 계산됩니다.',
  'Employment Income Deduction',
  'Automatic deduction for employees',
  'An automatic deduction from salary income, serving as the employee equivalent of business expenses.

Just as self-employed people deduct expenses, employees get this deduction automatically based on income level.',
  'With ¥4M annual income, the deduction is ¥1.24M, reducing taxable income to ¥2.76M for tax calculation purposes.',
  ARRAY['income_tax', 'tax_return', 'resident_tax'],
  50,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'mortgage_deduction',
  '🏠',
  'system',
  '住宅ローン控除',
  'ローン残高の0.7%が税金から還付',
  '住宅ローンの年末残高の0.7%が、所得税と住民税から控除される制度です。新築の場合は最長13年間適用されます。

初年度は確定申告が必要ですが、2年目からは年末調整で適用されます。住宅購入を検討する際の大きなメリットです。',
  '住宅ローン残高3,000万円の場合、年間21万円の税金が還付されます。13年間で最大約270万円の節税効果があります。',
  '주택론공제',
  '대출 잔액의 0.7%가 세금에서 환급',
  '주택론 연말 잔액의 0.7%가 소득세와 주민세에서 공제되는 제도입니다. 신축의 경우 최장 13년간 적용됩니다.

첫 해는 확정신고가 필요하지만, 2년째부터는 연말정산으로 적용됩니다. 주택 구매를 검토할 때 큰 메리트입니다.',
  '주택론 잔액 3,000만엔의 경우, 연간 21만엔의 세금이 환급됩니다. 13년간 최대 약 270만엔의 절세 효과가 있습니다.',
  'Mortgage Deduction',
  '0.7% of mortgage balance refunded',
  'A tax credit equal to 0.7% of your mortgage balance at year-end, lasting up to 13 years for new homes.

Requires a tax return the first year, then applies through year-end adjustment. A major benefit when considering home purchase.',
  'With a ¥30M mortgage balance, you get ¥210,000 back annually in taxes. Over 13 years, total savings can reach about ¥2.7M.',
  ARRAY['mortgage', 'income_tax', 'tax_return'],
  51,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'my_number_points',
  '📱',
  'system',
  'マイナポイント',
  'マイナカードで最大2万ポイント',
  'マイナンバーカードを取得し、キャッシュレス決済と紐付けることでポイントがもらえるキャンペーンです。

最大2万円分のポイントが付与されました。今後もマイナンバーカードの活用場面は増える見込みで、早めに取得しておくのがおすすめです。',
  'マイナンバーカード取得で5,000ポイント、健康保険証利用申込で7,500ポイント、口座紐付けで7,500ポイント。合計最大2万ポイントです。',
  '마이나포인트',
  '마이나카드로 최대 2만 포인트',
  '마이넘버 카드를 취득하고 캐시리스 결제와 연동하면 포인트를 받을 수 있는 캠페인입니다.

최대 2만엔 상당의 포인트가 부여되었습니다. 앞으로도 마이넘버 카드 활용 장면이 늘어날 전망이므로 빨리 취득해두는 것을 추천합니다.',
  '마이넘버 카드 취득으로 5,000포인트, 건강보험증 이용 신청으로 7,500포인트, 계좌 연동으로 7,500포인트. 합계 최대 2만 포인트입니다.',
  'My Number Points',
  'Up to 20,000 points with My Number card',
  'A campaign where linking your My Number card to cashless payments earns reward points.

Up to ¥20,000 worth of points were awarded. My Number card usage continues to expand, so getting one early is recommended.',
  '5,000 points for getting the card, 7,500 for health insurance registration, 7,500 for bank account linking — up to 20,000 points total.',
  ARRAY['my_number', 'qr_payment', 'point_rewards'],
  52,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  '103man_wall',
  '💴',
  'system',
  '103万円の壁',
  'パートの年収と税金の境目',
  'パートやアルバイトの年収が103万円を超えると所得税がかかり始める境目のことです。

103万円以下なら所得税はゼロですが、超えると税金が発生し、さらに配偶者の扶養から外れる可能性があります。

ただし、実際には「106万円の壁」「130万円の壁」など複数の壁があり、社会保険料の負担も考慮する必要があります。',
  '月8.5万円のパート収入なら年間102万円で所得税ゼロ。でも月9万円に増えると年間108万円になり、103万円の壁を超えてしまいます。',
  '103만엔의 벽',
  '파트타임 연수입과 세금의 경계',
  '파트타임이나 아르바이트 연수입이 103만엔을 넘으면 소득세가 부과되기 시작하는 경계선입니다.

103만엔 이하면 소득세는 0이지만, 넘으면 세금이 발생하고 배우자의 부양에서 제외될 수 있습니다.

실제로는 "106만엔의 벽", "130만엔의 벽" 등 여러 벽이 있어 사회보험료 부담도 고려해야 합니다.',
  '월 8.5만엔의 파트 수입이면 연간 102만엔으로 소득세 제로. 하지만 월 9만엔으로 늘리면 연간 108만엔이 되어 103만엔의 벽을 넘게 됩니다.',
  '1.03M Yen Wall',
  'Part-time income tax threshold',
  'The income threshold where part-time workers start paying income tax in Japan.

Below ¥1.03M annually, no income tax applies. Above it, taxes kick in and you may lose dependent status.

In reality, there are multiple thresholds (¥1.06M, ¥1.3M) involving social insurance costs.',
  'Earning ¥85,000/month = ¥1.02M/year — no income tax. But ¥90,000/month = ¥1.08M, pushing past the ¥1.03M wall.',
  ARRAY['income_tax', 'dependent_deduction', 'social_insurance'],
  53,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'qr_payment',
  '📱',
  'payment',
  'QRコード決済',
  'スマホで支払う電子決済',
  'スマートフォンのアプリでQRコードを表示または読み取って支払う決済方法です。PayPay、楽天ペイ、d払いなどがあります。

ポイント還元キャンペーンが頻繁に行われており、現金よりもお得に買い物できることが多いです。',
  'PayPayで月5万円使うと、還元率0.5%で250円分のポイントが貯まります。キャンペーン時は最大20%還元（1万円相当）になることも。',
  'QR결제',
  '스마트폰으로 결제하는 전자결제',
  '스마트폰 앱으로 QR코드를 표시하거나 읽어서 결제하는 방법입니다. PayPay, 라쿠텐페이, d하라이 등이 있습니다.

포인트 환원 캠페인이 빈번하게 열려, 현금보다 이득이 되는 경우가 많습니다.',
  'PayPay로 월 5만엔을 사용하면, 환원율 0.5%로 250엔분의 포인트가 적립됩니다. 캠페인 시 최대 20% 환원(1만엔 상당)이 되기도 합니다.',
  'QR Payment',
  'Mobile payment via QR code',
  'A payment method using smartphone apps to display or scan QR codes. PayPay, Rakuten Pay, and d-barai are popular options.

Frequent point-back campaigns make it often cheaper than paying with cash.',
  'Spending ¥50,000/month via PayPay earns 250 points at 0.5%. During campaigns, up to 20% back (¥10,000 equivalent) is possible.',
  ARRAY['point_rewards', 'e_money', 'debit_card'],
  54,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'debit_card',
  '💳',
  'payment',
  'デビットカード',
  '使った分だけ即座に口座引落',
  '使うと同時に銀行口座から即座に引き落とされるカードです。

クレジットカードと違い、口座残高以上は使えないため使いすぎを防げます。家計管理の味方です。審査も不要で、銀行口座があれば誰でも持てます。',
  '口座に10万円あれば、デビットカードで10万円まで使用可能。残高不足なら決済が自動的に拒否されるので、借金の心配がありません。',
  '직불카드',
  '사용한 만큼 즉시 계좌에서 인출',
  '사용과 동시에 은행 계좌에서 즉시 인출되는 카드입니다.

신용카드와 달리 계좌 잔액 이상은 사용할 수 없어 과소비를 방지합니다. 심사도 불필요하며 은행 계좌가 있으면 누구나 만들 수 있습니다.',
  '계좌에 10만엔이 있으면 직불카드로 10만엔까지 사용 가능. 잔액 부족이면 결제가 자동 거부되므로 빚걱정이 없습니다.',
  'Debit Card',
  'Instant deduction from bank account',
  'A card that instantly deducts from your bank account when used.

Unlike credit cards, you can''t spend more than your balance, preventing overspending. No credit check required — anyone with a bank account can get one.',
  'With ¥100,000 in your account, you can spend up to ¥100,000. Insufficient funds? The transaction is simply declined — no debt risk.',
  ARRAY['qr_payment', 'e_money', 'revolving_payment'],
  55,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'e_money',
  '🔋',
  'payment',
  '電子マネー',
  '事前チャージ式の電子決済',
  '事前にお金をチャージして使う電子的な支払い手段です。Suica、PASMO、nanaco、WAONなどがあります。

交通系ICカードは電車・バスと買い物の両方に使えて便利。チャージ上限があるため使いすぎも防げます。',
  'Suicaに月2万円チャージして、電車代1万円とコンビニ代1万円に使用。チャージ式なので予算管理がしやすいです。',
  '전자화폐',
  '사전 충전식 전자결제',
  '사전에 돈을 충전해서 사용하는 전자적 결제 수단입니다. Suica, PASMO, nanaco, WAON 등이 있습니다.

교통계 IC카드는 전철·버스와 쇼핑 양쪽에 사용할 수 있어 편리합니다. 충전 상한이 있어 과소비도 방지됩니다.',
  'Suica에 월 2만엔 충전해서 전철비 1만엔과 편의점비 1만엔에 사용. 충전식이라 예산 관리가 쉽습니다.',
  'E-money',
  'Prepaid electronic payment',
  'A prepaid electronic payment system. Suica, PASMO, nanaco, and WAON are popular options.

Transit IC cards work for both transportation and shopping. Charge limits help prevent overspending.',
  'Charge ¥20,000/month to Suica for ¥10,000 transit and ¥10,000 convenience store spending. Prepaid format makes budgeting easy.',
  ARRAY['qr_payment', 'debit_card', 'point_rewards'],
  56,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'cryptocurrency',
  '🪙',
  'payment',
  '暗号資産',
  'デジタルな仮想通貨',
  'ブロックチェーン技術を使ったデジタル通貨です。ビットコインやイーサリアムが有名です。

値動きが非常に激しくハイリスク・ハイリターン。日本では利益に最大55%の税金がかかるため、税制面でも不利です。余裕資金で投資することが重要です。',
  '10万円分のビットコインが1年で20万円に値上がりすると、利益10万円に対して最大5.5万円の税金がかかります。NISAのような非課税制度は使えません。',
  '암호화폐',
  '디지털 가상화폐',
  '블록체인 기술을 사용한 디지털 통화입니다. 비트코인이나 이더리움이 유명합니다.

가격 변동이 매우 심해 하이리스크·하이리턴입니다. 일본에서는 이익에 최대 55%의 세금이 붙어 세제 면에서도 불리합니다. 여유자금으로 투자하는 것이 중요합니다.',
  '10만엔어치의 비트코인이 1년 만에 20만엔으로 오르면, 이익 10만엔에 대해 최대 5.5만엔의 세금이 부과됩니다. NISA 같은 비과세 제도는 사용할 수 없습니다.',
  'Cryptocurrency',
  'Digital virtual currency',
  'Digital currency using blockchain technology. Bitcoin and Ethereum are the best known.

Extremely volatile with high risk and high potential returns. In Japan, profits are taxed up to 55%, making it tax-disadvantaged. Only invest with money you can afford to lose.',
  'If ¥100,000 in Bitcoin doubles to ¥200,000, your ¥100,000 profit may be taxed up to ¥55,000. Unlike stocks, NISA tax benefits don''t apply.',
  ARRAY['fintech', 'stock_investment', 'risk_tolerance'],
  57,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'point_rewards',
  '🏪',
  'payment',
  'ポイント還元',
  '買い物でポイントが貯まる仕組み',
  'クレジットカードやキャッシュレス決済で買い物をすると、利用金額に応じてポイントが付与される仕組みです。

還元率は0.5〜2%が一般的。年間100万円の支出なら5,000〜20,000ポイント。ポイントの二重取り、三重取りのテクニックも人気です。',
  '還元率1.5%のクレジットカードで年間120万円使うと、18,000ポイント（1.8万円分）獲得。10年で18万円分のポイントになります。',
  '포인트환원',
  '쇼핑으로 포인트가 쌓이는 구조',
  '신용카드나 캐시리스 결제로 쇼핑하면 이용 금액에 따라 포인트가 부여되는 구조입니다.

환원율은 0.5~2%가 일반적. 연간 100만엔 지출이면 5,000~20,000포인트. 포인트 이중·삼중 적립 테크닉도 인기입니다.',
  '환원율 1.5%의 신용카드로 연간 120만엔을 사용하면 18,000포인트(1.8만엔분) 획득. 10년이면 18만엔분의 포인트가 됩니다.',
  'Point Rewards',
  'Earning points from purchases',
  'A system where credit card or cashless payments earn points based on spending amount.

Typical rates are 0.5-2%. Spending ¥1M/year earns 5,000-20,000 points. Stacking multiple point programs is a popular technique.',
  'A 1.5% rewards card earns 18,000 points (¥18,000) on ¥1.2M annual spending. Over 10 years, that''s ¥180,000 in free points.',
  ARRAY['qr_payment', 'my_number_points', 'debit_card'],
  58,
  TRUE
);

INSERT INTO dictionary_terms (
  term_key, emoji, category,
  name_ja, summary_ja, description_ja, example_ja,
  name_ko, summary_ko, description_ko, example_ko,
  name_en, summary_en, description_en, example_en,
  related_term_keys, display_order, is_active
) VALUES (
  'fintech',
  '🔗',
  'payment',
  'フィンテック',
  '金融×テクノロジーの新サービス',
  'Finance（金融）とTechnology（技術）を組み合わせた造語で、ITを活用した新しい金融サービスのことです。

スマホ決済、家計簿アプリ、ロボアドバイザー、クラウドファンディングなどが含まれます。Hareruもフィンテックの一つです。',
  'スマホで3秒で支出を記録できるHareru、AIが最適な投資先を提案するロボアドバイザー、QRコード一つで送金できるアプリ。これらはすべてフィンテックです。',
  '핀테크',
  '금융×기술의 새로운 서비스',
  'Finance(금융)와 Technology(기술)를 합친 조어로, IT를 활용한 새로운 금융 서비스입니다.

스마트폰 결제, 가계부 앱, 로보어드바이저, 크라우드펀딩 등이 포함됩니다. Hareru도 핀테크의 하나입니다.',
  '스마트폰으로 3초 만에 지출을 기록하는 Hareru, AI가 최적의 투자처를 제안하는 로보어드바이저, QR코드 하나로 송금하는 앱. 이 모든 것이 핀테크입니다.',
  'FinTech',
  'Finance meets technology',
  'A combination of "Finance" and "Technology" — new financial services powered by IT.

Includes mobile payments, budgeting apps, robo-advisors, and crowdfunding. Hareru is also a fintech product.',
  'Recording expenses in 3 seconds with Hareru, AI-powered investment advice from robo-advisors, instant QR transfers — all examples of FinTech.',
  ARRAY['qr_payment', 'cryptocurrency', 'household_budget'],
  59,
  TRUE
);

-- Total: 60 terms inserted
