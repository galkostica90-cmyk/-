#!/usr/bin/env bash
set -euo pipefail

echo "Generating icon from base64..."
mkdir -p assets
if [ -f assets/icon_base64.txt ]; then
  base64 --decode assets/icon_base64.txt > assets/icon.png
  echo "Decoded assets/icon.png"
else
  echo "assets/icon_base64.txt not found; please add your icon base64 or a PNG at assets/icon.png"
  exit 1
fi

flutter pub get
flutter pub run flutter_launcher_icons:main || true

echo "Icon generation complete."
