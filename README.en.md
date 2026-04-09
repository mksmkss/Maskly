<div align="center">

<img src="./icon.png" width="96" alt="Maskli icon" />

# Maskli

**A macOS menu bar app that automatically masks sensitive clipboard content — locally, the moment you copy.**

[![Swift](https://img.shields.io/badge/Swift-5.9-FA7343?logo=swift&logoColor=white)](https://swift.org)
[![Platform](https://img.shields.io/badge/macOS-13+-000000?logo=apple)](https://developer.apple.com/macos/)
[![License](https://img.shields.io/badge/license-MIT-blue)](#)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)](#build-and-run)

**English** | [日本語](./README.md)

</div>

---

## What it does

When you copy text, Maskli scans the clipboard and **automatically replaces** any detected secrets — API keys, tokens, email addresses, phone numbers — with a masked version. Everything runs locally; no external API is ever called.

```
Before: sk-proj-aBcDeFgHiJkLmNoPqRsTuVwX3456
After:  sk-proj-****************************3456
```

---

## Download

### One-liner install

```bash
curl -L -o /tmp/Maskli.zip https://github.com/mksmkss/Maskly/releases/latest/download/Maskli.zip && unzip -o /tmp/Maskli.zip -d /tmp && mv /tmp/Maskli.app /Applications/Maskli.app && open /Applications/Maskli.app
```

### Manual install

1. Download `Maskli.zip` from [Releases](https://github.com/mksmkss/Maskly/releases/latest)
2. Unzip and move `Maskli.app` to `/Applications`
3. Launch the app

---

## Features

| Feature | Description |
|---------|-------------|
| 🔍 **Auto-detect & mask** | Scans the clipboard on copy and replaces secrets instantly |
| 📋 **Multiple matches** | Handles several secrets in a single clipboard entry in one pass |
| 👁 **Conversion preview** | View the original and masked text directly from the menu bar |
| ↩️ **Undo support** | Restore the previous clipboard value with one click |
| ⚙️ **Per-category toggle** | Enable or disable masking by category |
| 🔒 **Fully local** | No data ever leaves your machine |

---

## Menu bar actions

Click the menu bar icon to:

- Toggle masking ON / OFF
- Review the latest conversion preview
- Undo the last mask with `Undo Last Mask`
- Open the Settings window
- Quit the app

---

## Supported sensitive types

<details>
<summary><strong>🔑 API keys & tokens (click to expand)</strong></summary>

| Service | Pattern |
|---------|---------|
| OpenAI | `sk-...`, `sk-proj-...` |
| AWS | `AKIA...` |
| GitHub | `ghp_...`, `gho_...`, `ghu_...`, `ghs_...`, `ghr_...` |
| Stripe | `sk_live_...`, `sk_test_...`, `pk_live_...`, `pk_test_...` |
| Supabase | `sb_...` (e.g. `sb_publishable_...`) |
| JWT | `eyJxxxxx.yyyyy.zzzzz` |
| Assignment form | `token=...`, `access_token=...`, `secret=...`, `api_key=...`, etc. |
| URL query | `?token=...`, `?key=...`, `?api_key=...`, `?secret=...`, etc. |

</details>

<details>
<summary><strong>👤 Personal contact data</strong></summary>

| Type | Example |
|------|---------|
| Email address | `user@example.com` → `u***@example.com` |
| Phone number | `090-1234-5678` → `+** **-****-5678` |

</details>

---

## Masking styles

Three styles are available. The default is `Partial`.

### Partial (default)

Keeps enough structure to stay recognizable while hiding the sensitive part.

```
# Known prefixes are preserved
sk-proj-****************************3456
ghp_****************************3456
AKIA************CD12

# Generic tokens: first 4 and last 4 characters kept
token=supe************0000

# URL query masked while other parameters are untouched
https://example.com/callback?token=supe************0000&mode=prod

# Personal data
a****@example.com
+** **-****-5678
```

### Full

Replaces the entire detected value with asterisks.

```
a****@example.com  →  ****
ghp_****3456       →  ****
```

### Category Label

Replaces the value with a type label.

```
a****@example.com        →  [EMAIL]
ghp_****3456             →  [TOKEN]
AKIA************CD12     →  [API_KEY]
+** **-****-5678         →  [PHONE]
```

---

## Settings

### General

| Option | Description |
|--------|-------------|
| `Enable masking` | Turn clipboard masking on or off |
| `Launch at login` | Start Maskli automatically when you log in |

### Categories

Toggle masking per category:

- `API Key`
- `Token`
- `Email`
- `Phone`
- `URL Secret`

### Mask Style

Choose from `Partial` / `Full` / `Category Label`.

### Last Conversion

The settings window also shows:

- Original text preview
- Masked text preview
- Number of detections
- `Undo Last Mask` button

---



## Build and run (for developers)

### Development (swift run)

```bash
swift test
swift run MaskliApp
```

> [!NOTE]
> `swift run` is convenient for development, but the real menu bar behavior is best verified with the `.app` bundle.

### App bundle

```bash
./App/build-app.sh
open dist/Maskli.app
```

### Build a zip for GitHub Releases

```bash
./App/package-release.sh
```

This creates `dist/Maskli.zip`, ready to upload to GitHub Releases.

---

## Project structure

```
Maskli/
├── Sources/
│   ├── MaskliCore/                # Detection, preprocessing, masking policies, settings model
│   └── MaskliApp/                 # Menu bar UI, clipboard monitoring, settings window
├── Tests/
│   └── MaskliCoreTests/           # Detector and masking tests
└── App/
    ├── build-app.sh               # App bundle build script
    └── package-release.sh         # Release zip build script
```

---

## Notes

> [!NOTE]
> - Maskli currently focuses on rule-based detection. Person names and company names are not actively detected yet.
> - Launch at login uses `SMAppService`, so actual behavior can depend on the app's signing state and location.
