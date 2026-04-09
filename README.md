# Maskli

Maskli is a macOS menu bar app that watches your clipboard and automatically masks sensitive strings locally before you paste them anywhere.

Maskli は、クリップボードを監視して、機密らしい文字列をローカルで自動マスクする macOS メニューバーアプリです。

## Overview / 概要

- Runs in the macOS menu bar.
- Watches copied text in the clipboard.
- Detects supported secrets, emails, phone numbers, and secret-like URL parameters.
- Rewrites the clipboard with a masked version.
- Opens a settings window from the menu bar.
- Supports undo for the most recent masking action.
- Works fully locally. No external API is used.

- macOS のメニューバーで常駐します。
- コピーされたテキストをクリップボード上で監視します。
- 対応している秘密情報、メールアドレス、電話番号、URL 内の秘密パラメータを検出します。
- マスク済みの文字列でクリップボードを上書きします。
- メニューバーから設定画面を開けます。
- 直前のマスク処理は Undo できます。
- 完全ローカル動作で、外部 API は使いません。

## Features / 機能

### 1. Menu bar workflow / メニューバー常駐

Maskli lives in the menu bar so it stays available without a full app window. From the menu bar popover you can:

- enable or pause masking
- open Settings
- review the latest masking preview
- undo the last masking
- quit the app

Maskli はメニューバー常駐型なので、通常のアプリウィンドウを出しっぱなしにせず使えます。メニューバーのポップオーバーから以下ができます。

- マスク機能のオン・オフ
- Settings の表示
- 直近のマスク結果プレビューの確認
- 直前のマスクの Undo
- アプリの終了

### 2. Automatic masking on copy / コピー時の自動マスク

When you copy text, Maskli checks the clipboard contents. If supported sensitive values are found, the clipboard is replaced with a masked version automatically.

テキストをコピーすると、Maskli がクリップボードの内容を確認します。対応している機密値が見つかった場合は、自動でマスク済みの内容に置き換えます。

### 3. Multiple matches in one clipboard entry / 1つのクリップボード内の複数検出

Maskli supports multiple sensitive values in a single clipboard entry. For example, if one copied string contains an email address, a phone number, and a token, all of them can be masked in one pass.

Maskli は、1つのクリップボード文字列の中に複数の機密値が含まれているケースにも対応しています。たとえば、メールアドレス、電話番号、トークンが同時に含まれていても、1回の処理でまとめてマスクできます。

### 4. Recent conversion preview / 直近変換のプレビュー

The app keeps the latest original and masked preview in the UI so you can quickly confirm what changed.

UI 上で直近の元テキストとマスク後テキストのプレビューを保持するので、何が変わったかをすぐ確認できます。

### 5. Undo last mask / 直前のマスクを元に戻す

If the latest masking was not what you wanted, you can restore the previous clipboard value with `Undo Last Mask`.

直近のマスク結果が意図と違った場合は、`Undo Last Mask` でひとつ前のクリップボード内容に戻せます。

## Supported Sensitive Types / 対応している機密情報タイプ

Maskli currently supports the following patterns.

現時点で Maskli が対応している主なパターンは次の通りです。

### API keys and tokens / API キー・トークン

- OpenAI API keys
  - `sk-...`
  - `sk-proj-...`
- AWS access keys
  - `AKIA...`
- GitHub personal and related tokens
  - `ghp_...`
  - `gho_...`
  - `ghu_...`
  - `ghs_...`
  - `ghr_...`
- Stripe keys
  - `sk_live_...`
  - `sk_test_...`
  - `pk_live_...`
  - `pk_test_...`
- Supabase-style keys
  - `sb_...`
  - example: `sb_publishable_...`
- JWT-like tokens
  - `eyJxxxxx.yyyyy.zzzzz`
- Assigned secret values in text
  - `token=...`
  - `access_token=...`
  - `refresh_token=...`
  - `secret=...`
  - `client_secret=...`
  - `api_key=...`
  - also supports `:` as in `token: ...`
- Secret-like URL query values
  - `?token=...`
  - `?key=...`
  - `?api_key=...`
  - `?access_token=...`
  - `?secret=...`
  - `?client_secret=...`

### Personal contact data / 個人連絡先

- Email addresses
  - example: `alice@example.com`
- Phone numbers
  - international and separator-based forms such as `+81 90-1234-5678`

## Masking Examples / マスク例

The default masking style is `Partial`.

デフォルトのマスク方式は `Partial` です。

### Partial / 部分マスク

Maskli tries to keep just enough of the original shape to stay recognizable while hiding the sensitive part.

Maskli は、何の値かが分かる程度の形は残しつつ、重要な部分を隠します。

- OpenAI key
  - `sk-proj-abcdefghijklmnopqrstuvwxyz123456`
  - `sk-proj-**************************3456`
- GitHub token
  - `ghp_abcdefghijklmnopqrstuvwxyz123456`
  - `ghp_**************************3456`
- Supabase key
  - `sb_abcdefghijklmnopqrstuvw789`
  - `sb_***********************w789`
- Assigned token
  - `token=supersecretvalue0000`
  - `token=supe************0000`
- URL query secret
  - `https://example.com/callback?token=supersecretvalue0000&mode=prod`
  - `https://example.com/callback?token=supe************0000&mode=prod`
- Email
  - `alice@example.com`
  - `a****@example.com`
- Phone
  - `+81 90-1234-5678`
  - `+** **-****-5678`

Notes:

- For known token prefixes such as `sk-`, `sk-proj-`, `ghp_`, `AKIA`, `sk_live_`, `pk_test_`, the prefix is preserved.
- For general token-like values without a known vendor prefix, Maskli keeps the first 4 characters and the last 4 characters.
- For emails, Maskli keeps the domain and only the first character of the local part.
- For phone numbers, Maskli keeps the last 4 digits.

補足:

- `sk-`, `sk-proj-`, `ghp_`, `AKIA`, `sk_live_`, `pk_test_` など、既知のプレフィックスは残します。
- ベンダー固有のプレフィックスがない一般的なトークン風文字列は、先頭 4 文字と末尾 4 文字を残します。
- メールアドレスはドメインとローカル部の先頭 1 文字を残します。
- 電話番号は末尾 4 桁を残します。

### Full / 完全マスク

`Full` replaces the detected value with only asterisks.

`Full` は、検出した値をアスタリスクのみで置き換えます。

- `alice@example.com` -> fully replaced with `*`
- `ghp_abcdefghijklmnopqrstuvwxyz123456` -> fully replaced with `*`

- `alice@example.com` は `*` のみで置き換えられます
- `ghp_abcdefghijklmnopqrstuvwxyz123456` も `*` のみで置き換えられます

### Category Label / カテゴリラベル

`Category Label` replaces the value with a type label.

`Category Label` は、値そのものではなくカテゴリ名に置き換えます。

- `alice@example.com` -> `[EMAIL]`
- `ghp_abcdefghijklmnopqrstuvwxyz123456` -> `[TOKEN]`
- `AKIA1234567890ABCD12` -> `[API_KEY]`
- `+81 90-1234-5678` -> `[PHONE]`

## Settings / 設定項目

Maskli provides the following settings window options.

Maskli の設定画面では次の項目を調整できます。

### General / 一般

- `Enable masking`
  - Turns clipboard masking on or off.
  - クリップボードの自動マスクを有効化または停止します。
- `Launch at login`
  - Attempts to start Maskli automatically when you log in to macOS.
  - macOS ログイン時に Maskli を自動起動する設定です。

### Categories / カテゴリ

You can enable or disable masking by category.

カテゴリごとにマスク対象をオン・オフできます。

- `API Key`
- `Token`
- `Email`
- `Phone`
- `URL Secret`

### Mask Style / マスク方式

You can choose how detected values are rewritten.

検出した値をどのように置き換えるかを選べます。

- `Partial`
  - Keeps part of the original structure visible.
  - 元の形を一部残します。
- `Full`
  - Replaces the entire value with `*`.
  - 全体を `*` で隠します。
- `Category Label`
  - Replaces the value with labels such as `[EMAIL]` or `[API_KEY]`.
  - `[EMAIL]` や `[API_KEY]` のようなラベルに置き換えます。

### Last Conversion / 直近の変換結果

The settings window also shows:

設定画面では以下も確認できます。

- original preview
- masked preview
- number of detections
- `Undo Last Mask`

- 元テキストのプレビュー
- マスク後テキストのプレビュー
- 検出件数
- `Undo Last Mask`

## Build and Run / ビルドと起動

### Development / 開発用

```bash
cd /Users/masataka/Coding/Swift/clipboard-masker
swift test
swift run ClipboardMaskerApp
```

`swift run` is useful for development, but the real menu bar app behavior is best tested with the `.app` bundle.

`swift run` は開発には便利ですが、実際のメニューバーアプリ挙動を確認するには `.app` バンドルでの起動が適しています。

### App bundle / `.app` バンドル

```bash
cd /Users/masataka/Coding/Swift/clipboard-masker
./App/build-app.sh
open dist/ClipboardMasker.app
```

## Project Structure / 構成

- `Sources/ClipboardMaskerCore`
  - detection, preprocessing, masking policies, and settings model
  - 検出、前処理、マスク方式、設定モデル
- `Sources/ClipboardMaskerApp`
  - menu bar UI, clipboard monitoring, and settings window
  - メニューバー UI、クリップボード監視、設定画面
- `Tests/ClipboardMaskerCoreTests`
  - detector and masking tests
  - 検出とマスク処理のテスト
- `App/build-app.sh`
  - app bundle build script
  - `.app` バンドルを組み立てるスクリプト

## Notes / 補足

- Maskli currently focuses on rule-based detection.
- Person names and company names are not actively detected yet.
- Launch at login uses `SMAppService`, so actual behavior can depend on signing state and app location.

- Maskli は現在、ルールベース検出が中心です。
- 人名・企業名の自動検出はまだ有効化していません。
- ログイン時起動は `SMAppService` を使っているため、署名状態や配置場所によって macOS 側の挙動が変わることがあります。
