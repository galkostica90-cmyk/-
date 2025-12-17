#!/usr/bin/env bash
set -euo pipefail

# Usage: set_identifiers.sh <package_name> <bundle_id>
PKG=${1:-com.example.attendance}
BUNDLE=${2:-com.example.attendance}

echo "Setting Android applicationId to $PKG"
if [ -f app/flutter/android/app/build.gradle ]; then
  # replace applicationId if present
  sed -i "s|applicationId ".*"|applicationId \"$PKG\"|g" app/flutter/android/app/build.gradle || true
fi

echo "Setting iOS bundle identifier to $BUNDLE"
if [ -d app/flutter/ios ]; then
  # update Runner.xcodeproj project.pbxproj occurrences
  find app/flutter/ios -type f -name "project.pbxproj" -exec sed -i "s|PRODUCT_BUNDLE_IDENTIFIER = [^;]*;|PRODUCT_BUNDLE_IDENTIFIER = $BUNDLE;|g" {} + || true
fi

echo "Done"
