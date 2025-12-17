# Pricing & Paid Apps (Google Play & App Store)

If you want to sell your app (paid) or offer in‑app purchases, follow these steps and prepare the required information.

## Google Play (Paid app)
1. Sign up for a Play Console developer account ($25 one‑time).
2. Set up a Payments Merchant Account (Google Play Console → Setup → Payments profile).
3. When creating a release or in the Store Listing, set the app to be a **Paid** app (Pricing & Distribution). You will select a base currency and price.
4. For subscriptions or in‑app purchases, add them under 'Monetize → Products' in the Play Console and configure prices, billing periods, and tax settings.

Notes:
- Use `PLAY_SERVICE_ACCOUNT_JSON` service account key for programmatic uploads (Fastlane supply). Programmatic pricing changes are limited and often better done via the Play Console UI.

## App Store (Paid app)
1. Enroll in the Apple Developer Program ($99/year).
2. Configure your Bank & Tax information in App Store Connect (Agreements, Tax & Banking) to accept paid apps.
3. Create In‑App Purchase items in App Store Connect if you plan to sell digital goods or subscriptions.
4. When you create the app in App Store Connect, set the app price tier in 'Pricing and Availability'.

Notes:
- App Store Connect requires complete banking & tax agreements before you can publish a paid app or IAPs.
- Fastlane `deliver` can upload metadata and screenshots, but you must set prices in App Store Connect UI or via App Store Connect API with appropriate credentials.

---

If you want, I can prepare in‑app purchase (IAP) placeholder entries in the Fastlane metadata and help you register the seller/bank details in App Store Connect and Play Console step by step.
