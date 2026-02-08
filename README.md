<!-- Language Selector -->
<p align="center">
  <b>🇰🇷 한국어</b> | <a href="README.en.md">🇺🇸 English</a> | <a href="README.ja.md">🇯🇵 日本語</a>
</p>

<!-- Logo -->
<p align="center">
  <img src="assets/icons/app_icon.png" alt="Hareru Logo" width="120" />
</p>

<!-- Title -->
<h1 align="center">Hareru ハレル</h1>

<!-- Tagline -->
<p align="center">
  <b>진짜 지출만 보여주는 가계부 앱</b><br>
  本当の支出だけを見せる家計簿アプリ
</p>

<!-- Badges -->
<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS-blue?logo=apple" />
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/status-MVP_개발중-brightgreen" />
  <img src="https://img.shields.io/badge/license-proprietary-lightgrey" />
  <img src="https://img.shields.io/badge/lang-JP_|_KR_|_EN-white" />
</p>

---

<!-- Screenshots -->
<p align="center">
  <img src="assets/screenshots/home.png" alt="홈 화면" width="180" />
  <img src="assets/screenshots/report.png" alt="리포트" width="180" />
  <img src="assets/screenshots/ai_insight.png" alt="AI 인사이트" width="180" />
  <img src="assets/screenshots/blur.png" alt="프리미엄 블러" width="180" />
</p>

---

## 문제 — 기존 가계부 앱의 한계

일본의 모든 가계부 앱은 **은행 간 이체를 지출로 처리**합니다.

적금 계좌에서 생활비 계좌로 ¥100,000을 이체하면? 축하합니다 — 앱은 이번 달 ¥100,000을 "썼다"고 알려줍니다. 리포트는 엉망이 되고, 카테고리 분석은 오염되고, 월간 추이는 의미가 없어집니다.

> 193명의 가계부 앱 이탈자 조사에서 29.7%가 "절약을 실감할 수 없었다"를 꼽았습니다.
> 처음부터 데이터가 정확하지 않았으니까요.

---

## 해결책 — Hareru

**Hareru는 이체를 자동으로 분리하여**, 돈이 실제로 어디에 쓰이는지 가장 명확하게 보여줍니다.

오염된 데이터도, 가짜 지출도 없습니다. 비 온 뒤 하늘이 개는 것처럼, 선명한 재정 관리. ☀️

> ハレル = 晴れる (개다, 맑아지다)
> 돈에 대한 '흐릿함'을 걷어내는 가계부.

---

## 기능

### 🆓 무료 — 정확한 데이터는 모두의 권리

- **이체 자동 제외** — 핵심 기능을 무료로 제공. 다른 앱에서는 유료에서도 불가능합니다.
- **3초 지출 입력** — 바텀시트 + 빠른 카테고리 선택. 마찰 없는 입력.
- **클리어뷰 리포트** — 도넛 차트, 지출 추이, 카테고리 분석 — 모두 *실질 지출* 기반.
- **월간 인사이트** — 규칙 기반 분석: 가장 많이 쓴 날, 카테고리 변화, 패턴 감지.
- **다크 모드** — 전체 화면 다크 테마 지원.
- **다국어** — 일본어 🇯🇵 / 한국어 🇰🇷 / 영어 🇺🇸

### ✨ Clear (¥380/월) — AI 기반 인사이트

- **클리어 비교** — 차이를 한눈에: "다른 앱 ¥200,000 → Hareru ¥148,000"
- **AI 핵심 발견** — 주간 AI 분석으로 숨겨진 소비 패턴 감지 (주말 외식, 편의점 습관, 미사용 구독)
- **절약 포텐셜** — "월 ¥26,000 (연 ¥312,000) 절약 가능" 구체적 실행 방안 제시
- **지출 건강도** — 4개 항목 100점 만점 건강 게이지 (예산 준수, 절약 노력, 지출 균형, 이체 정리)

### 🚀 Clear Pro (¥700/월) — Phase 2 예정

- **AI 코칭봇** — 자연어로 AI에게 재정 상담
- **맞춤형 절약 목표** — 개인화된 목표 설정 및 추적
- **주간/월간 PDF 리포트** — 내보내기 가능한 AI 분석 문서
- **지출 예측** — 패턴 기반 예측 분석

---

## 스크린샷

| 홈 | 입력 | 리포트 | AI 인사이트 | 건강도 | 블러 (무료) | 다크모드 |
|:--:|:----:|:------:|:----------:|:------:|:----------:|:-------:|
| ![홈](assets/screenshots/home.png) | ![입력](assets/screenshots/input.png) | ![리포트](assets/screenshots/report.png) | ![AI](assets/screenshots/ai_insight.png) | ![건강도](assets/screenshots/health_score.png) | ![블러](assets/screenshots/blur.png) | ![다크](assets/screenshots/dark_mode.png) |

---

## 아키텍처

```
┌─────────────────────────────────────────────┐
│                   UI 레이어                   │
│  Flutter + Riverpod + go_router             │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌───────────┐  │
│  │  홈  │ │ 입력 │ │리포트│ │   설정     │  │
│  └──────┘ └──────┘ └──────┘ └───────────┘  │
├─────────────────────────────────────────────┤
│               비즈니스 로직                   │
│  ┌───────────────┐ ┌──────────────────────┐ │
│  │  거래 관리     │ │  AI 인사이트 엔진    │ │
│  │  (CRUD + 필터  │ │  ┌────────────────┐  │ │
│  │   + 이체 감지) │ │  │ 건강도 계산기   │  │ │
│  │               │ │  ├────────────────┤  │ │
│  └───────────────┘ │  │ 인사이트       │  │ │
│                     │  │ 생성기         │  │ │
│                     │  │ (규칙 기반 →   │  │ │
│                     │  │  AI API 전환)  │  │ │
│                     │  └────────────────┘  │ │
│                     └──────────────────────┘ │
├─────────────────────────────────────────────┤
│                데이터 레이어                  │
│  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Hive (로컬)   │  │  Firebase (Phase 2)  │ │
│  │ 거래 내역     │  │  인증 + 클라우드 동기 │ │
│  │ AI 캐시       │  │  프리미엄 관리       │ │
│  │ 설정          │  │                      │ │
│  └──────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────┘
```

### 기술 스택

| 레이어 | 기술 |
|-------|------|
| 프레임워크 | Flutter 3.x (Dart) |
| 상태 관리 | Riverpod |
| 네비게이션 | go_router |
| 로컬 저장소 | Hive |
| 차트 | fl_chart |
| 다국어 | Flutter L10n (ARB) |
| 백엔드 (Phase 2) | Firebase Auth + Firestore |
| AI (Phase 2) | Claude API (Anthropic) |

---

## 프로젝트 구조

```
lib/
├── main.dart
├── app.dart
├── shared/
│   ├── models/          # Transaction, AiInsight, Category
│   ├── services/        # AI 인사이트 생성기, 건강도 계산기
│   └── theme/           # 라이트/다크 테마 정의
├── features/
│   ├── home/            # 홈 화면 + 주간 트렌드
│   ├── input/           # 지출 입력 바텀시트
│   ├── report/          # 클리어뷰 리포트 카드 (1)~(8)
│   │   ├── providers/   # 리포트 데이터 + AI 인사이트 Provider
│   │   └── widgets/     # 개별 카드 위젯
│   ├── dictionary/      # 금융 사전 (Phase 2)
│   └── settings/        # 앱 설정 + 프리미엄 토글
├── l10n/                # ARB 파일 (ko, ja, en)
└── router/              # go_router 설정
```

---

## 개발 로드맵

- [x] 시장 조사 및 경쟁사 분석
- [x] MVP PRD (14개 섹션)
- [x] 홈 화면 (월간 요약 + 주간 트렌드)
- [x] 지출 입력 (3초 바텀시트 + Hive 연동)
- [x] 설정 (다크모드 + 다국어)
- [x] 로고 및 스플래시 스크린
- [x] 클리어뷰 리포트 (카드 1~5)
- [x] AI 클리어 인사이트 프리미엄 카드 (6~8)
- [x] 프리미엄 블러 + CTA 전환 플로우
- [x] 요금제 전략 (Free / Clear / Clear Pro)
- [ ] Firebase 인증
- [ ] 금융 사전 탭
- [ ] 전체 L10n + App Store 준비
- [ ] TestFlight 베타
- [ ] **App Store 출시** 🚀

---

## 시장 포지셔닝

```
¥980 ── MoneyForward 어드밴스
¥700 ── 🔵 Hareru Clear Pro (AI 코칭봇, MF보다 저렴)
¥540 ── MoneyForward 스탠다드
¥500 ── 楽天家計簿
¥480 ── OneBank Plus
¥430 ── Moneytree Grow
¥380 ── 🔵 Hareru Clear (AI 인사이트 포함, 시장 최저가대)
¥365 ── Zaim 프리미엄
  ¥0 ── 🔵 Hareru Free (이체 자동 제외 — 경쟁사 무료 불가능)
```

---

## 왜 "Hareru"인가?

**晴れる (하레루)** 는 일본어로 "개다, 맑아지다"라는 뜻입니다 — 구름이 걷히고 푸른 하늘이 드러나는 것처럼.

가짜 지출, 틀린 합계, 오염된 데이터로 흐려진 재정을 Hareru가 걷어내고 진짜만 보여줍니다.

이 이름은 타겟 시장 전체에서 통합니다:

- 🇯🇵 일본 유저 — 의미를 바로 이해
- 🇰🇷 한국 유저 — 부드럽고 친근한 발음
- 🇺🇸 영어 유저 — 기억하기 쉽고 독특한 이름

---

## 타겟 유저

- **주 타겟:** 가계부 앱을 써봤지만 포기한 20~30대 일본 거주자
- **서브 타겟:** 일본에 거주하는 외국인 (일본 금융 시스템 적응 필요)
- **플랫폼:** iOS 우선 (일본 iOS 점유율 ~65%), Android는 Phase 2

---

## 라이선스

이 프로젝트는 독점 소프트웨어입니다. All rights reserved.

---

<!-- Footer -->
<p align="center">
  <b>Hareru ハレル</b><br>
  <em>재정을 맑게. 진짜만 보이게.</em><br><br>
  お金のもやもやを、晴らそう。
</p>
