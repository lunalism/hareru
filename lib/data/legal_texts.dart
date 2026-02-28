class LegalTexts {
  LegalTexts._();

  static String getTermsOfService(String locale) {
    switch (locale) {
      case 'ko':
        return _termsKo;
      case 'en':
        return _termsEn;
      default:
        return _termsJa;
    }
  }

  static String getPrivacyPolicy(String locale) {
    switch (locale) {
      case 'ko':
        return _privacyKo;
      case 'en':
        return _privacyEn;
      default:
        return _privacyJa;
    }
  }

  static const _termsJa = '''利用規約

第1条（適用）
この利用規約（以下「本規約」）は、Hareru（ハレル）（以下「本アプリ」）の利用に関する条件を定めるものです。ユーザーは本アプリを利用することにより、本規約に同意したものとみなされます。

第2条（サービス内容）
本アプリは、ユーザーの家計管理を支援するためのツールです。主な機能は以下の通りです。
・支出、収入、振替の記録と管理
・予算管理
・カテゴリ別のレポート表示
・金融用語辞書
・AIによる支出分析（有料プラン）

第3条（利用料金）
本アプリの基本機能は無料でご利用いただけます。一部の機能はApp内課金（サブスクリプション）で提供されます。
・Freeプラン: ¥0
・Clearプラン: ¥380/月
・ClearProプラン: ¥700/月
サブスクリプションはApple IDを通じて管理されます。

第4条（データの取り扱い）
本アプリで記録されたすべてのデータは、ユーザーの端末内にのみ保存されます。開発者はユーザーのデータにアクセスすることはできません。詳細はプライバシーポリシーをご確認ください。

第5条（禁止事項）
ユーザーは以下の行為を行ってはなりません。
・本アプリの不正利用またはリバースエンジニアリング
・法令または公序良俗に違反する行為
・本アプリの運営を妨害する行為
・その他、開発者が不適切と判断する行為

第6条（免責事項）
本アプリは「現状のまま」提供されます。開発者は以下について責任を負いません。
・本アプリの利用により生じた損害
・データの消失または破損
・本アプリの中断、遅延、エラー
・AIによる分析結果の正確性
本アプリは家計管理を支援するツールであり、財務アドバイスを提供するものではありません。

第7条（サービスの変更・中止）
開発者は、事前の通知なしに本アプリの内容を変更し、または提供を中止することができるものとします。

第8条（規約の変更）
開発者は、必要に応じて本規約を変更できるものとします。変更後の利用規約は、アプリ内で公開された時点から効力を生じるものとします。

第9条（準拠法・裁判管轄）
本規約は日本法に準拠するものとします。

第10条（お問い合わせ）
本規約に関するお問い合わせ: hareru.info11@gmail.com''';

  static const _termsKo = '''이용약관

제1조 (적용)
본 이용약관(이하 "본 약관")은 Hareru(하레루)(이하 "본 앱")의 이용에 관한 조건을 정합니다. 사용자는 본 앱을 이용함으로써 본 약관에 동의한 것으로 간주됩니다.

제2조 (서비스 내용)
본 앱은 사용자의 가계 관리를 지원하기 위한 도구입니다. 주요 기능은 다음과 같습니다.
・지출, 수입, 이체의 기록 및 관리
・예산 관리
・카테고리별 리포트 표시
・금융 용어 사전
・AI 지출 분석(유료 플랜)

제3조 (이용 요금)
본 앱의 기본 기능은 무료로 이용하실 수 있습니다. 일부 기능은 앱 내 구매(구독)로 제공됩니다.
・Free 플랜: ¥0
・Clear 플랜: ¥380/월
・ClearPro 플랜: ¥700/월
구독은 Apple ID를 통해 관리됩니다.

제4조 (데이터 취급)
본 앱에서 기록된 모든 데이터는 사용자의 기기 내에만 저장됩니다. 개발자는 사용자의 데이터에 접근할 수 없습니다. 자세한 내용은 개인정보처리방침을 확인해 주세요.

제5조 (금지 사항)
사용자는 다음 행위를 해서는 안 됩니다.
・본 앱의 부정 이용 또는 리버스 엔지니어링
・법령 또는 공서양속에 위반하는 행위
・본 앱의 운영을 방해하는 행위
・기타 개발자가 부적절하다고 판단하는 행위

제6조 (면책 사항)
본 앱은 "있는 그대로" 제공됩니다. 개발자는 다음에 대해 책임을 지지 않습니다.
・본 앱의 이용으로 인해 발생한 손해
・데이터의 소실 또는 손상
・본 앱의 중단, 지연, 오류
・AI 분석 결과의 정확성
본 앱은 가계 관리를 지원하는 도구이며, 재무 조언을 제공하는 것이 아닙니다.

제7조 (서비스 변경·중지)
개발자는 사전 통지 없이 본 앱의 내용을 변경하거나 제공을 중지할 수 있습니다.

제8조 (약관 변경)
개발자는 필요에 따라 본 약관을 변경할 수 있습니다. 변경 후의 이용약관은 앱 내에서 공개된 시점부터 효력이 발생합니다.

제9조 (준거법·재판 관할)
본 약관은 일본법에 준거합니다.

제10조 (문의)
본 약관에 관한 문의: hareru.info11@gmail.com''';

  static const _termsEn = '''Terms of Service

Article 1 (Application)
These Terms of Service ("Terms") govern the use of Hareru ("the App"). By using the App, you agree to these Terms.

Article 2 (Service Description)
The App is a tool to assist users with household budget management. Key features include:
- Recording and managing expenses, income, and transfers
- Budget management
- Category-based reports
- Financial terminology dictionary
- AI-powered spending analysis (paid plans)

Article 3 (Fees)
Basic features of the App are available free of charge. Some features are offered through in-app purchases (subscriptions).
- Free Plan: ¥0
- Clear Plan: ¥380/month
- ClearPro Plan: ¥700/month
Subscriptions are managed through your Apple ID.

Article 4 (Data Handling)
All data recorded in the App is stored only on the user's device. The developer cannot access user data. Please refer to the Privacy Policy for details.

Article 5 (Prohibited Activities)
Users must not:
- Misuse or reverse-engineer the App
- Violate any laws or public morals
- Interfere with the operation of the App
- Engage in any other activity deemed inappropriate by the developer

Article 6 (Disclaimer)
The App is provided "as is." The developer is not responsible for:
- Any damages arising from the use of the App
- Loss or corruption of data
- Interruptions, delays, or errors in the App
- Accuracy of AI analysis results
The App is a budget management tool and does not provide financial advice.

Article 7 (Service Changes)
The developer may change or discontinue the App without prior notice.

Article 8 (Changes to Terms)
The developer may modify these Terms as needed. Updated Terms take effect upon publication within the App.

Article 9 (Governing Law)
These Terms are governed by the laws of Japan.

Article 10 (Contact)
For inquiries regarding these Terms: hareru.info11@gmail.com''';

  static const _privacyJa = '''プライバシーポリシー

1. 収集する情報
本アプリは、以下の情報を端末内にのみ保存します。
・支出・収入・振替の記録データ（金額、カテゴリ、日時、メモ）
・予算設定（月の予算、給料日）
・カテゴリ設定
・アプリの設定（ダークモード、言語、通知設定など）
本アプリは、ユーザーの個人情報（氏名、メールアドレス、電話番号、位置情報など）を収集しません。

2. データの保存場所
すべてのデータはユーザーの端末内にのみ保存されます。外部サーバーへのデータ送信は行いません。銀行口座やクレジットカードとの連携機能はありません。

3. 第三者へのデータ提供
本アプリは、ユーザーのデータを第三者に提供、販売、共有することはありません。

4. AI機能について
本アプリの有料プラン（Clear / ClearPro）では、AI機能を提供しています。AI機能の利用時には、支出データの要約情報がAI処理のために外部APIに送信される場合があります。この際、個人を特定できる情報は送信されません。

5. 広告について
本アプリには広告は表示されません。広告ネットワークによるトラッキングは行われません。

6. アナリティクスについて
本アプリでは、アプリの改善のために匿名の利用統計情報を収集する場合があります。この情報には個人を特定できるデータは含まれません。

7. お子様のプライバシー
本アプリは13歳未満のお子様を対象としたものではありません。13歳未満のお子様から意図的に個人情報を収集することはありません。

8. データの削除
ユーザーはアプリの設定画面からすべてのデータを削除できます。また、アプリをアンインストールすることで、端末内のすべてのデータが削除されます。

9. プライバシーポリシーの変更
本プライバシーポリシーは、必要に応じて更新される場合があります。重要な変更がある場合は、アプリ内でお知らせします。

10. お問い合わせ
本プライバシーポリシーに関するお問い合わせ: hareru.info11@gmail.com''';

  static const _privacyKo = '''개인정보처리방침

1. 수집하는 정보
본 앱은 다음 정보를 기기 내에만 저장합니다.
・지출·수입·이체 기록 데이터(금액, 카테고리, 일시, 메모)
・예산 설정(월 예산, 급여일)
・카테고리 설정
・앱 설정(다크 모드, 언어, 알림 설정 등)
본 앱은 사용자의 개인정보(성명, 이메일 주소, 전화번호, 위치 정보 등)를 수집하지 않습니다.

2. 데이터 저장 위치
모든 데이터는 사용자의 기기 내에만 저장됩니다. 외부 서버로의 데이터 전송은 이루어지지 않습니다. 은행 계좌나 신용카드 연동 기능은 없습니다.

3. 제3자 데이터 제공
본 앱은 사용자의 데이터를 제3자에게 제공, 판매, 공유하지 않습니다.

4. AI 기능에 대하여
본 앱의 유료 플랜(Clear / ClearPro)에서는 AI 기능을 제공합니다. AI 기능 이용 시, 지출 데이터의 요약 정보가 AI 처리를 위해 외부 API로 전송될 수 있습니다. 이때 개인을 식별할 수 있는 정보는 전송되지 않습니다.

5. 광고에 대하여
본 앱에는 광고가 표시되지 않습니다. 광고 네트워크에 의한 트래킹은 이루어지지 않습니다.

6. 분석에 대하여
본 앱에서는 앱 개선을 위해 익명의 이용 통계 정보를 수집할 수 있습니다. 이 정보에는 개인을 식별할 수 있는 데이터가 포함되지 않습니다.

7. 아동의 프라이버시
본 앱은 13세 미만 아동을 대상으로 하지 않습니다. 13세 미만 아동으로부터 의도적으로 개인정보를 수집하지 않습니다.

8. 데이터 삭제
사용자는 앱의 설정 화면에서 모든 데이터를 삭제할 수 있습니다. 또한 앱을 삭제하면 기기 내의 모든 데이터가 삭제됩니다.

9. 개인정보처리방침 변경
본 개인정보처리방침은 필요에 따라 업데이트될 수 있습니다. 중요한 변경이 있는 경우 앱 내에서 알려드립니다.

10. 문의
본 개인정보처리방침에 관한 문의: hareru.info11@gmail.com''';

  static const _privacyEn = '''Privacy Policy

1. Information We Collect
The App stores the following information only on your device:
- Expense, income, and transfer records (amounts, categories, dates, notes)
- Budget settings (monthly budget, payday)
- Category settings
- App settings (dark mode, language, notification preferences, etc.)
The App does not collect personal information such as names, email addresses, phone numbers, or location data.

2. Data Storage
All data is stored only on the user's device. No data is transmitted to external servers. There are no bank account or credit card linking features.

3. Third-Party Data Sharing
The App does not provide, sell, or share user data with third parties.

4. AI Features
The paid plans (Clear / ClearPro) include AI features. When using AI features, summarized spending data may be sent to an external API for processing. No personally identifiable information is transmitted.

5. Advertising
The App does not display advertisements. No tracking by advertising networks is performed.

6. Analytics
The App may collect anonymous usage statistics to improve the service. This information does not include personally identifiable data.

7. Children's Privacy
The App is not intended for children under 13. We do not knowingly collect personal information from children under 13.

8. Data Deletion
Users can delete all data from the App's settings screen. Uninstalling the App will also delete all data from the device.

9. Changes to This Policy
This Privacy Policy may be updated as needed. Users will be notified of significant changes within the App.

10. Contact
For inquiries regarding this Privacy Policy: hareru.info11@gmail.com''';
}
