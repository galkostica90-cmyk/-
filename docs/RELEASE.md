# Release & Publishing Guide

This document explains how to publish the Flutter app to Google Play and App Store using Fastlane and GitHub Actions.

## Prepare credentials

Android (Google Play):
- Create a Google Play Console service account with `Release Manager` permissions and download the JSON key.
- Add JSON content as `PLAY_SERVICE_ACCOUNT_JSON` secret in GitHub.
- Create a keystore for signing and add it as `ANDROID_KEYSTORE_BASE64` (base64-encoded), and store alias/password as secrets.

iOS (App Store):
- Create an App Store Connect API key and add the JSON content to `APP_STORE_CONNECT_API_KEY` in GitHub secrets.
- Add `FASTLANE_USER` and `FASTLANE_PASSWORD` if needed for some flows.

## CI / Fastlane
- Use `fastlane android beta` or `fastlane android release` to upload to Play.
- Use `fastlane ios beta` and `fastlane ios release` for TestFlight/App Store.

## GitHub Actions
- A workflow `flutter-ci.yml` will run `flutter test` and build Android artifacts on Linux and iOS archives on macOS.
- Publishing steps are not automatic; the workflow can be extended to call Fastlane with proper secrets.

---

If you want, I can wire the GitHub Actions to call Fastlane when you provide the required secrets.
