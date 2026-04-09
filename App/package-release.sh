#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
APP_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
DIST_DIR="$APP_ROOT/dist"
APP_BUNDLE="$DIST_DIR/Maskli.app"
ZIP_PATH="$DIST_DIR/Maskli.zip"

cd "$APP_ROOT"

"$SCRIPT_DIR/build-app.sh"

rm -f "$ZIP_PATH"
ditto -c -k --sequesterRsrc --keepParent "$APP_BUNDLE" "$ZIP_PATH"

echo "Packaged $ZIP_PATH"
