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
- A workflow `flutter-ci.yml` runs `flutter test` and builds Android AAB on Linux and iOS IPA on macOS.
- A new `publish.yml` workflow supports manual dispatch (workflow_dispatch) and tag-based releases (tags v*.*.*) and can run publishing lanes for Android and/or iOS.

## Required repository secrets for automatic publish
Add these secrets to your GitHub repository settings → Secrets & variables → Actions before you dispatch the publish workflow:

Android (Play Store):
- `ANDROID_KEYSTORE_BASE64` — base64-encoded bytes of your Android keystore (.jks)
- `ANDROID_KEYSTORE_PASSWORD` — keystore password
- `ANDROID_KEYSTORE_KEY_ALIAS` — key alias inside keystore
- `ANDROID_KEYSTORE_KEY_PASSWORD` — key password (often same as keystore password)
- `PLAY_SERVICE_ACCOUNT_JSON` — the JSON service account key for Google Play (upload in raw JSON)

iOS (App Store):
- `APP_STORE_CONNECT_API_KEY` — App Store Connect API key JSON content (raw JSON)
- (Optional) `FASTLANE_USER` / `FASTLANE_PASSWORD` — if needed for some flows

## How to trigger a publish
- Manual: Go to the Actions → Publish Mobile App → Run workflow → choose `platform` (android|ios|all) and `track` (for Play Store: internal|production).
- Tag-based: push a tag like `v1.0.0` to create a release and trigger publish jobs.

---

If you'd like, I can also:
- Add automated generation of app icons and screenshots (requires assets),
- Add a backend service and integration tests, or
- Create PRs that include production-ready metadata templates for the Play/App Store.
