<!-- Language Selector -->
<p align="center">
  <a href="README.md">🇰🇷 한국어</a> | <a href="README.en.md">🇺🇸 English</a> | <b>🇯🇵 日本語</b>
</p>

<!-- Logo -->
<p align="center">
  <img src="assets/icons/app_icon.png" alt="Hareru ロゴ" width="120" />
</p>

<!-- Title -->
<h1 align="center">Hareru ハレル</h1>

<!-- Tagline -->
<p align="center">
  <b>本当の支出だけを見せる家計簿アプリ</b><br>
  振替ノイズのない、クリアな家計管理を。
</p>

<!-- Badges -->
<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS-blue?logo=apple" />
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/status-MVP_開発中-brightgreen" />
  <img src="https://img.shields.io/badge/license-proprietary-lightgrey" />
  <img src="https://img.shields.io/badge/lang-JP_|_KR_|_EN-white" />
</p>

---

<!-- Screenshots -->
<p align="center">
  <img src="assets/screenshots/home.png" alt="ホーム" width="180" />
  <img src="assets/screenshots/report.png" alt="レポート" width="180" />
  <img src="assets/screenshots/ai_insight.png" alt="AIインサイト" width="180" />
  <img src="assets/screenshots/blur.png" alt="プレミアムブラー" width="180" />
</p>

---

## 課題 — 既存の家計簿アプリの限界

日本のすべての家計簿アプリは、**銀行間振替を支出として計上**しています。

貯蓄口座から生活費口座に¥100,000を移動すると？おめでとうございます——アプリは今月¥100,000を「使った」と表示します。レポートは不正確になり、カテゴリ分析は汚染され、月間トレンドは意味をなしません。

> 193名の家計簿アプリ離脱者調査で、29.7%が「節約を実感できなかった」と回答。
> そもそもデータが正確でなかったのですから、当然の結果です。

---

## 解決策 — Hareru

**Hareruは振替を自動的に分離し**、お金が実際にどこに使われているかを最もクリアに表示します。

汚染されたデータも、架空の支出もありません。雨上がりの晴れ間のように、すっきりとした家計管理。☀️

> ハレル = 晴れる。
> お金の「もやもや」を晴らす家計簿。

---

## 機能

### 🆓 無料 — 正確なデータはみんなの権利

- **振替自動除外** — コア機能を無料で提供。他のアプリでは有料版でもできません。
- **3秒で支出入力** — ボトムシート＋クイックカテゴリ選択。ストレスフリー。
- **クリアビューレポート** — ドーナツチャート、支出トレンド、カテゴリ分析——すべて*実質支出*ベース。
- **月間インサイト** — ルールベース分析：最も使った日、カテゴリ変化、パターン検出。
- **ダークモード** — 全画面ダークテーマ対応。
- **多言語対応** — 日本語 🇯🇵 / 韓国語 🇰🇷 / 英語 🇺🇸

### ✨ Clear（¥380/月）— AI搭載インサイト

- **クリア比較** — 一目で違いがわかる：「他のアプリ ¥200,000 → Hareru ¥148,000」
- **AI発見** — 週次AI分析で隠れた支出パターンを検出（週末の外食、コンビニ習慣、未使用サブスク）
- **節約ポテンシャル** — 「月¥26,000（年¥312,000）節約可能」具体的なアクション提案付き
- **支出ヘルススコア** — 4項目100点満点の健康ゲージ（予算遵守、節約努力、支出バランス、振替整理）

### 🚀 Clear Pro（¥700/月）— Phase 2で提供予定

- **AIコーチングボット** — 自然言語でAIに家計相談
- **カスタム節約目標** — パーソナライズされた目標設定・追跡
- **週次/月次PDFレポート** — エクスポート可能なAI分析レポート
- **支出予測** — パターンベースの予測分析

---

## スクリーンショット

| ホーム | 入力 | レポート | AIインサイト | ヘルススコア | ブラー（無料） | ダークモード |
|:------:|:----:|:--------:|:-----------:|:-----------:|:------------:|:----------:|
| ![ホーム](assets/screenshots/home.png) | ![入力](assets/screenshots/input.png) | ![レポート](assets/screenshots/report.png) | ![AI](assets/screenshots/ai_insight.png) | ![ヘルス](assets/screenshots/health_score.png) | ![ブラー](assets/screenshots/blur.png) | ![ダーク](assets/screenshots/dark_mode.png) |

---

## アーキテクチャ

```
┌─────────────────────────────────────────────┐
│                  UIレイヤー                   │
│  Flutter + Riverpod + go_router             │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌───────────┐  │
│  │ホーム│ │ 入力 │ │レポート│ │  設定     │  │
│  └──────┘ └──────┘ └──────┘ └───────────┘  │
├─────────────────────────────────────────────┤
│              ビジネスロジック                  │
│  ┌───────────────┐ ┌──────────────────────┐ │
│  │ トランザクション│ │  AIインサイトエンジン │ │
│  │  管理          │ │  ┌────────────────┐  │ │
│  │  (CRUD+フィルタ│ │  │ ヘルススコア    │  │ │
│  │   +振替検出)   │ │  │ 計算機          │  │ │
│  │               │ │  ├────────────────┤  │ │
│  └───────────────┘ │  │ インサイト      │  │ │
│                     │  │ ジェネレーター  │  │ │
│                     │  │ (ルール→AI)     │  │ │
│                     │  └────────────────┘  │ │
│                     └──────────────────────┘ │
├─────────────────────────────────────────────┤
│                データレイヤー                 │
│  ┌──────────────┐  ┌──────────────────────┐ │
│  │ Hive（ローカル）│  │  Firebase (Phase 2) │ │
│  │ トランザクション│  │  認証+クラウド同期   │ │
│  │ AIキャッシュ   │  │  プレミアム管理      │ │
│  │ 設定          │  │                      │ │
│  └──────────────┘  └──────────────────────┘ │
└─────────────────────────────────────────────┘
```

### 技術スタック

| レイヤー | 技術 |
|---------|------|
| フレームワーク | Flutter 3.x (Dart) |
| 状態管理 | Riverpod |
| ナビゲーション | go_router |
| ローカルストレージ | Hive |
| チャート | fl_chart |
| 多言語対応 | Flutter L10n (ARB) |
| バックエンド (Phase 2) | Firebase Auth + Firestore |
| AI (Phase 2) | Claude API (Anthropic) |

---

## プロジェクト構造

```
lib/
├── main.dart
├── app.dart
├── shared/
│   ├── models/          # Transaction, AiInsight, Category
│   ├── services/        # AIインサイト生成、ヘルススコア計算
│   └── theme/           # ライト/ダークテーマ定義
├── features/
│   ├── home/            # ホーム画面 + 週間トレンド
│   ├── input/           # 支出入力ボトムシート
│   ├── report/          # クリアビューレポートカード (1)〜(8)
│   │   ├── providers/   # レポートデータ + AIインサイトProvider
│   │   └── widgets/     # 個別カードウィジェット
│   ├── dictionary/      # 金融辞書 (Phase 2)
│   └── settings/        # アプリ設定 + プレミアムトグル
├── l10n/                # ARBファイル (ko, ja, en)
└── router/              # go_router設定
```

---

## 開発ロードマップ

- [x] 市場調査・競合分析
- [x] MVP PRD（14セクション）
- [x] ホーム画面（月間サマリー + 週間トレンド）
- [x] 支出入力（3秒ボトムシート + Hive連携）
- [x] 設定（ダークモード + 多言語）
- [x] ロゴ・スプラッシュスクリーン
- [x] クリアビューレポート（カード1〜5）
- [x] AIクリアインサイトプレミアムカード（6〜8）
- [x] プレミアムブラー + CTA変換フロー
- [x] 料金プラン戦略（Free / Clear / Clear Pro）
- [ ] Firebase認証
- [ ] 金融辞書タブ
- [ ] L10n完了 + App Store準備
- [ ] TestFlightベータ
- [ ] **App Storeリリース** 🚀

---

## 市場ポジショニング

```
¥980 ── MoneyForward アドバンス
¥700 ── 🔵 Hareru Clear Pro（AIコーチング、MFより安い）
¥540 ── MoneyForward スタンダード
¥500 ── 楽天家計簿
¥480 ── OneBank Plus
¥430 ── Moneytree Grow
¥380 ── 🔵 Hareru Clear（AIインサイト込み、市場最安帯）
¥365 ── Zaim プレミアム
  ¥0 ── 🔵 Hareru Free（振替自動除外——競合は無料で提供不可）
```

---

## なぜ「ハレル」？

**晴れる（hareru）** ——雲が晴れて青空が広がるように。

架空の支出、間違った合計、汚染されたデータで曇った家計を、Hareruが晴らして本当のことだけを見せます。

この名前は、ターゲット市場全体で響きます：

- 🇯🇵 日本のユーザー — 意味をすぐに理解
- 🇰🇷 韓国のユーザー — やわらかく親しみやすい響き
- 🇺🇸 英語のユーザー — 覚えやすくユニークな名前

---

## ターゲットユーザー

- **メイン:** 家計簿アプリを試したが挫折した20〜30代の日本在住者
- **サブ:** 日本在住の外国人（日本の金融システムに適応が必要な方）
- **プラットフォーム:** iOS優先（日本のiOSシェア約65%）、AndroidはPhase 2で対応

---

## ライセンス

本プロジェクトはプロプライエタリソフトウェアです。All rights reserved.

---

<!-- Footer -->
<p align="center">
  <b>Hareru ハレル</b><br>
  <em>お金のもやもやを、晴らそう。</em><br><br>
  Clear your finances. See what's real.
</p>
