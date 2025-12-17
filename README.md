# -
שעון נוכחות ודיווח נוכחות עובדי החברה

---

## קבצי תצורה שנוספו
בקובץ זה נוסף מבנה תצורה בסיסי הכולל:

- `.github/workflows/ci.yml` — GitHub Actions CI שיריץ בדיקות עבור Python/Node לפי קבצי פרויקט.
- `.gitignore`, `.editorconfig`, `.gitattributes` — הגדרות נוחות ל־git ועורך.
- `Dockerfile` — דוגמה להרצת פרויקט Python (ניתן להתאים ל־Node).
- `Makefile` — פקודות שימושיות: `make test`, `make lint`, `make docker-build`.
- `.env.example` — דוגמת משתני סביבה.
- `LICENSE` — רישיון MIT.

להבדלים ולקריאת קוד מלא, עיין ב־PR שנפתח בסניף `setup/config`.

## בדיקות (tests) 🧪

הוספתי תשתית בדיקות מינימלית עבור שתי שפות שימושיות: Python ו־Node.

- Python: `requirements.txt` + `pytest` + `tests/test_sample_py.py` (בדיקה שמוודאת שחישוב פשוט עובר).
- Node: `package.json` + `jest` + `tests/sample.test.js` (בדיקה דומה ל‑Node).

הרצתי את הבדיקות מקומית — שתיהן עוברות. אם תרצה, אוכל להרחיב את הבדיקות או להוסיף CI coverage.
