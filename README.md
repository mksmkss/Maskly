<div align="center">

<img src="./icon.png" width="96" alt="Maskli icon" />

# Maskli

**クリップボードの機密情報を、コピーした瞬間にローカルで自動マスクする macOS メニューバーアプリ**

[![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?logo=swift&logoColor=white)](https://swift.org)
[![Platform](https://img.shields.io/badge/macOS-13+-000000?logo=apple)](https://developer.apple.com/macos/)
[![License](https://img.shields.io/badge/license-MIT-blue)](#)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)](#ビルドと起動) 

[English](./README.en.md) | **日本語**

</div>

---

## 何ができるか

テキストをコピーすると Maskli がクリップボードを監視し、API キーやトークン・メールアドレス・電話番号などの機密値を**自動でマスクして上書き**します。外部 API は一切使わず、すべての処理はローカルで完結します。

```
コピー前: sk-proj-aBcDeFgHiJkLmNoPqRsTuVwX3456
コピー後: sk-proj-****************************3456
```

---

## 機能一覧

| 機能 | 説明 |
|------|------|
| 🔍 **自動検出 & マスク** | コピー時にクリップボードをスキャンし、機密値を即時置換 |
| 📋 **複数値の一括処理** | 1 つのクリップボード内に複数の機密値が混在しても一括マスク |
| 👁 **変換プレビュー** | 元テキスト／マスク後テキストをメニューバーから即確認 |
| ↩️ **Undo サポート** | 直前のマスクを 1 ステップ元に戻せる |
| ⚙️ **カテゴリ別 ON/OFF** | API キー・メール・電話番号などをカテゴリ単位で有効化 |
| 🔒 **完全ローカル動作** | 外部 API へのデータ送信なし |

---

## メニューバーからできること

メニューバーアイコンをクリックすると、以下の操作が可能です。

- マスク機能の ON / OFF 切り替え
- 直近の変換結果プレビュー
- `Undo Last Mask` で 1 つ前の状態に戻す
- Settings（設定画面）を開く
- アプリの終了

---

## 対応している機密情報タイプ

<details>
<summary><strong>🔑 API キー・トークン（クリックで展開）</strong></summary>

| サービス | パターン例 |
|----------|-----------|
| OpenAI | `sk-...`, `sk-proj-...` |
| AWS | `AKIA...` |
| GitHub | `ghp_...`, `gho_...`, `ghu_...`, `ghs_...`, `ghr_...` |
| Stripe | `sk_live_...`, `sk_test_...`, `pk_live_...`, `pk_test_...` |
| Supabase | `sb_...`（例: `sb_publishable_...`） |
| JWT | `eyJxxxxx.yyyyy.zzzzz` |
| 代入形式 | `token=...`, `access_token=...`, `secret=...`, `api_key=...` など |
| URL クエリ | `?token=...`, `?key=...`, `?api_key=...`, `?secret=...` など |

</details>

<details>
<summary><strong>👤 個人情報</strong></summary>

| 種別 | 例 |
|------|----|
| メールアドレス | `user@example.com` → `u***@example.com` |
| 電話番号 | `090-1234-5678` → `+** **-****-5678` |

</details>

---

## マスクスタイル

3 種類のスタイルから選べます。デフォルトは `Partial` です。

### Partial（デフォルト）

種類が判別できる程度の形を残しつつ、重要部分を隠します。

```
# プレフィックスを保持してマスク
sk-proj-****************************3456
ghp_****************************3456
AKIA************CD12

# 先頭・末尾 4 文字を保持（一般トークン）
token=supe************0000

# URL クエリ内もマスク（他のパラメータは維持）
https://example.com/callback?token=supe************0000&mode=prod

# 個人情報
a****@example.com
+** **-****-5678
```

### Full

検出した値全体をアスタリスクで置換します。

```
a****@example.com  →  ****
ghp_****3456       →  ****
```

### Category Label

値の種類を示すラベルに置換します。

```
a****@example.com        →  [EMAIL]
ghp_****3456             →  [TOKEN]
AKIA************CD12     →  [API_KEY]
+** **-****-5678         →  [PHONE]
```

---

## 設定項目

設定画面（Settings）では以下を調整できます。

### General

| 項目 | 説明 |
|------|------|
| `Enable masking` | クリップボードの自動マスクを有効化 / 停止 |
| `Launch at login` | ログイン時に Maskli を自動起動 |

### Categories

カテゴリごとに検出対象を切り替えられます。

- `API Key`
- `Token`
- `Email`
- `Phone`
- `URL Secret`

### Mask Style

`Partial` / `Full` / `Category Label` から選択。

### Last Conversion

設定画面で以下を確認できます。

- 元テキストのプレビュー
- マスク後テキストのプレビュー
- 検出件数
- `Undo Last Mask` ボタン

---

## ダウンロード

### ワンライナーでインストール

```bash
curl -L -o Maskli.zip https://github.com/mksmkss/Maskly/releases/latest/download/Maskli.zip && unzip -o Maskli.zip && open Maskli.app
```

### 手動インストール

1. [Releases](https://github.com/mksmkss/Maskly/releases/latest) から `Maskli.zip` をダウンロード
2. ZIP を展開して `Maskli.app` を `/Applications` へ移動
3. アプリを起動

---

## ビルドと起動（開発者向け）

### 開発用（swift run）

```bash
swift test
swift run ClipboardMaskerApp
```

> [!NOTE]
> `swift run` は開発時の確認に便利ですが、実際のメニューバー挙動を確認するには `.app` バンドルでの起動を推奨します。

### .app バンドルとして起動

```bash
./App/build-app.sh
open dist/Maskli.app
```

---

## プロジェクト構成

```
Maskli/
├── Sources/
│   ├── ClipboardMaskerCore/       # 検出・前処理・マスク方式・設定モデル
│   └── ClipboardMaskerApp/        # メニューバー UI・クリップボード監視・設定画面
├── Tests/
│   └── ClipboardMaskerCoreTests/  # 検出とマスク処理のテスト
└── App/
    └── build-app.sh               # .app バンドルを組み立てるスクリプト
```

---

## 補足・既知の制限

> [!NOTE]
> - 現在はルールベース検出が中心です。人名・企業名の自動検出は未実装です。
> - ログイン時起動は `SMAppService` を使用しているため、署名状態や配置場所によって macOS 側の挙動が変わる場合があります。