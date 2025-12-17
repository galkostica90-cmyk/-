Publish checklist (paid app):

1. Add repo secrets (GitHub Actions) as listed in `docs/RELEASE.md`.
2. Create Play Console Payments merchant profile and enable paid apps.
3. Provide App Store Connect banking & tax agreements.
4. Provide final app icons and screenshots and place them in `fastlane/metadata/*` (or run `python app/flutter/tools/generate_store_assets.py` for placeholders).
5. Review metadata files in `fastlane/metadata/*` and edit text files as needed.
6. Merge PR #3 (setup/flutter) into `main` (already done when you confirm).  
7. When ready, I can create a release tag (e.g., `v1.0.0`) that will trigger the `publish` workflow (if secrets exist).  

If you want me to prepare final assets and make the PR ready+merged, say "אפשר למזג" and provide the assets or say "עשה הכל" and I'll merge and prepare a release (but I won't trigger publishing until secrets are added).