---
title: 'Complete Story Sprint in Dutch'
type: 'feature'
ticket: '8'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
baseline_revision: 'aaaf377'
---

<intent-contract>

## Intent

**Problem:** Story Sprint had no Dutch sentence pools at all (unlike the word-pool games) and its setup screen, HUD, quit dialog, in-game hint, and game-over screen text are all hardcoded English.

**Approach:** Add `SentenceLists.dutchEasy/dutchMedium/dutchHard` (20 original sentences each, matching the English tiers' shapes: easy is lowercase-only with periods, medium adds capitals and commas, hard adds question marks/exclamation marks/apostrophes) and route `SentenceLists.forDifficulty`/`shuffledFor` through `LessonCurriculum.isDutch`, mirroring `WordLists`' existing pattern. Localize `story_sprint_screen.dart`/`story_sprint_views.dart` with the same `context.watch<LanguageProvider>().isDutch` pattern used in the other five games.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): sentences were authored across categories, then mechanically verified offline (Python) for exact count (20/20/20), uniqueness, no double spaces, ASCII-only, and the easy-tier character regex before being written into Dart. A dedicated content-quality review pass caught one awkward English-calqued sentence and six hard-tier sentences missing their required `?`/`!`/apostrophe punctuation; all were rewritten to natural Dutch and re-verified.

Story Sprint's current sentence is rendered via `Text.rich`/`TextSpan`, not a plain `Text`, so tests read it via `RichText.text.toPlainText()` (same technique used for Speed Chase in ticket 2.6) rather than `find.text`.

## Verification

**Commands:**
- `flutter test test/features_test.dart` -- expected: pass, including the new 20/20/20 Dutch sentence pool assertion
- `flutter test test/widget_test.dart --plain-name "Story Sprint"` -- expected: pass (2 new Dutch tests)
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 2 findings — high 0, medium 2, low 0, false 0, maybe-false 0
- findings:
  - `[medium]` `[patch]` One dutchMedium sentence used awkward English-calqued phrasing ("jaagde in cirkels achter zijn staart") — rewritten to natural Dutch ("jaagde achter zijn eigen staart aan").
  - `[medium]` `[patch]` Six dutchHard sentences lacked the tier's required `?`/`!`/apostrophe punctuation (leftover from restructuring away English contractions/possessives during translation) — rewritten to include natural question/exclamation forms; count and uniqueness re-verified at 20/20/20.

