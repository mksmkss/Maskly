#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
DIST_DIR="$APP_ROOT/dist"
APP_BUNDLE="$DIST_DIR/Maskli.app"
ICON_SOURCE="$APP_ROOT/icon.png"
FALLBACK_ICON_SOURCE="$DIST_DIR/maskli.icon/Assets/icon.png"
ICONSET_DIR="$DIST_DIR/AppIcon.iconset"
ICNS_PATH="$DIST_DIR/AppIcon.icns"

cd "$APP_ROOT"

swift build -c release --product MaskliApp
BIN_PATH=$(swift build -c release --show-bin-path)

rm -rf "$APP_BUNDLE"
rm -rf "$ICONSET_DIR"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

if [[ -f "$ICON_SOURCE" ]]; then
  RESOLVED_ICON_SOURCE="$ICON_SOURCE"
elif [[ -f "$FALLBACK_ICON_SOURCE" ]]; then
  RESOLVED_ICON_SOURCE="$FALLBACK_ICON_SOURCE"
else
  RESOLVED_ICON_SOURCE=""
fi

if [[ -n "$RESOLVED_ICON_SOURCE" ]]; then
  mkdir -p "$ICONSET_DIR"
  sips -z 16 16 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_16x16.png" >/dev/null
  sips -z 32 32 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_16x16@2x.png" >/dev/null
  sips -z 32 32 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_32x32.png" >/dev/null
  sips -z 64 64 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_32x32@2x.png" >/dev/null
  sips -z 128 128 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_128x128.png" >/dev/null
  sips -z 256 256 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_128x128@2x.png" >/dev/null
  sips -z 256 256 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_256x256.png" >/dev/null
  sips -z 512 512 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_256x256@2x.png" >/dev/null
  sips -z 512 512 "$RESOLVED_ICON_SOURCE" --out "$ICONSET_DIR/icon_512x512.png" >/dev/null
  cp "$RESOLVED_ICON_SOURCE" "$ICONSET_DIR/icon_512x512@2x.png"
  iconutil -c icns "$ICONSET_DIR" -o "$ICNS_PATH"
  cp "$ICNS_PATH" "$APP_BUNDLE/Contents/Resources/AppIcon.icns"
fi

cp "$BIN_PATH/MaskliApp" "$APP_BUNDLE/Contents/MacOS/MaskliApp"
cp "$SCRIPT_DIR/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

echo "Built $APP_BUNDLE"
