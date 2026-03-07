# 🎣 AreaGo — エリアトラウト釣果管理アプリ

エリアトラウト（管理釣り場）専用のスマホ向けPWAアプリ。
施設の検索・登録、ルアーのコレクション管理、釣果の記録を一元化します。

---

## 📱 スクリーンショット

| ダッシュボード | ルアー一覧 | 釣果一覧 |
|:-:|:-:|:-:|
| 釣果サマリー・最近の記録 | カラー＆タイプ別管理 | 魚種・サイズ・ルアー |

---

## ✨ 主な機能

### 🏞️ 施設管理
- Google Maps Places API で管理釣り場を検索・登録
- 都道府県フィルタリング
- 施設詳細ページ（住所・電話・URL・説明）

### 🪝 ルアー管理
- タイプ別登録（スプーン / クランクベイト / ミノー / その他）
- 表カラー・裏カラーをカラーピッカーで設定（hex値保存）
- 浮力 5段階スライダー（フローティング 〜 シンキング）
- ウェイト（g）記録

### 📊 釣果記録
- 魚種・サイズ・使用ルアーを記録
- 釣れた日時（datetime）+ 放流時間（time）を個別管理
- 地図ピンで釣れた地点を記録（Google Maps）
- 水深（m）記録
- Canvas で水断面図＋ルアー軌跡を手書き保存
- メモ欄

---

## 🛠️ 技術スタック

| カテゴリ | 技術 |
|---|---|
| バックエンド | Ruby on Rails 8.0.4 |
| フロントエンド | Hotwire (Turbo + Stimulus) |
| CSS | Tailwind CSS v4（水・自然テーマ） |
| DB | PostgreSQL 16 |
| 認証 | Devise |
| 地図 | Google Maps JavaScript API |
| 配布形態 | PWA（manifest + Service Worker） |
| アセット | Propshaft + importmap |
| 開発環境 | Docker Compose |

---

## 🚀 セットアップ

### 必要なもの
- Docker Desktop
- Google Maps API キー（[取得方法](https://developers.google.com/maps/documentation/javascript/get-api-key)）

### 手順

```bash
# 1. リポジトリをクローン
git clone <repo-url>
cd area_go

# 2. 環境変数を設定
cp .env.example .env
# .env を開いて GOOGLE_MAPS_API_KEY を設定

# 3. 起動
docker compose up

# 4. ブラウザで開く
open http://localhost:3000
```

初回起動時に自動で以下が実行されます：
- `db:prepare`（DB作成 + マイグレーション）
- `tailwindcss:build`（CSS ビルド）
- Rails サーバー起動

---

## 🌱 シードデータ

動作確認用のサンプルデータを投入できます。

```bash
docker compose exec web rails db:seed
```

投入されるデータ：
- **施設** 5件（埼玉・神奈川・栃木・千葉）
- **ルアー** 8本（スプーン・クランク・ミノー・その他）
- **釣果** 5件（レインボー・ブラウン・ヤマメ）

テストログイン：
```
メール:     test@example.com
パスワード: password123
```

---

## 🐳 Docker コマンド早見表

```bash
# 起動（バックグラウンド）
docker compose up -d

# ログ確認
docker compose logs -f web

# Rails コンソール
docker compose exec web rails console

# マイグレーション実行
docker compose exec web rails db:migrate

# Tailwind CSS 手動ビルド
docker compose exec web rails tailwindcss:build

# 停止
docker compose down
```

---

## 🗂️ ディレクトリ構成（主要ファイル）

```
area_go/
├── app/
│   ├── assets/
│   │   └── tailwind/
│   │       └── application.css      # Tailwind v4 入力ファイル（カラー定義）
│   ├── controllers/
│   │   ├── dashboard_controller.rb
│   │   ├── lures_controller.rb
│   │   ├── facilities_controller.rb
│   │   ├── catch_records_controller.rb
│   │   └── users/
│   │       ├── registrations_controller.rb
│   │       └── sessions_controller.rb
│   ├── javascript/
│   │   └── controllers/
│   │       ├── map_controller.js           # Google Maps 統合
│   │       ├── fishing_chart_controller.js # Canvas 水断面図
│   │       ├── color_picker_controller.js  # ルアーカラー選択
│   │       └── buoyancy_slider_controller.js
│   ├── models/
│   │   ├── user.rb
│   │   ├── facility.rb
│   │   ├── lure.rb
│   │   └── catch_record.rb
│   └── views/
│       ├── layouts/
│       │   ├── application.html.erb
│       │   └── _bottom_nav.html.erb
│       └── pwa/
│           ├── manifest.json.erb
│           └── service-worker.js
├── public/
│   ├── icon.svg                     # PWA アイコン（釣りルアーデザイン）
│   └── icons/
│       ├── icon-192.png
│       ├── icon-512.png
│       └── apple-touch-icon.png
├── docker-compose.yml
├── Dockerfile.dev
└── tailwind.config.js
```

---

## 🎨 デザインテーマ

水・自然をモチーフにしたカラーパレット。

| 名前 | 用途 | 代表色 |
|---|---|---|
| `water` | メインカラー（ティール） | `#0e7490` |
| `forest` | サブカラー（グリーン） | `#16a34a` |
| `sand` | アクセント（砂・土） | `#92400e` |
| `pebble` | UI要素（グレー系） | `#64748b` |

---

## 📌 注意事項

- Google Maps API キーは `.env` に設定し、**絶対にコミットしない**
- `.env` は `.gitignore` に追加済み（`.env.example` のみコミット）
- Tailwind v4 を使用。設定は `tailwind.config.js` ではなく `app/assets/tailwind/application.css` の `@theme` で行う
- Canvas の描画データは `fishing_method_data` カラムに JSONB で保存

---

## 📄 ライセンス

MIT
