#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
DIST_DIR="$APP_ROOT/dist"
APP_BUNDLE="$DIST_DIR/ClipboardMasker.app"

cd "$APP_ROOT"

swift build -c release --product ClipboardMaskerApp
BIN_PATH=$(swift build -c release --show-bin-path)

rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"

cp "$BIN_PATH/ClipboardMaskerApp" "$APP_BUNDLE/Contents/MacOS/ClipboardMaskerApp"
cp "$SCRIPT_DIR/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

echo "Built $APP_BUNDLE"
