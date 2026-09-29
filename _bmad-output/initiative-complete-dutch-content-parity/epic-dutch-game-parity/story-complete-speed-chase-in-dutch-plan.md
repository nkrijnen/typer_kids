---
title: 'Complete Speed Chase in Dutch'
type: 'feature'
ticket: '6'
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
baseline_revision: 'f9263b0'
---

<intent-contract>

## Intent

**Problem:** Speed Chase already selects words via language-aware `WordLists`, but its setup screen, HUD (difficulty badge, submit hint, race-track "You"/"Ghost" labels, error counter, all-words-completed message), quit dialog, input placeholder, and game-over screen text are all hardcoded English.

**Approach:** Apply the same proven localization pattern to `speed_chase_screen.dart` and `speed_chase_views.dart`. Add Dutch widget tests: one completes a full easy race by reading the current word from the underlying `RichText` (the current word is rendered via `Text.rich`/`_buildPartialMatch`, not a plain `Text`, so `find.text` can't see it) and asserts a separately-tracked score; the other confirms medium/hard difficulties pull from the Dutch pools via the plain-`Text` upcoming-word list.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical localization following the established pattern; no scoring/timing/spawn changes. Speed Chase's score includes a remaining-time bonus (not just word length), so the score-recorded test asserts `greaterThan(0)` rather than an exact value.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name "Speed Chase"` -- expected: pass (2 new Dutch tests)
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 0 findings — high 0, medium 0, low 0, false 0, maybe-false 0
- findings: none. Reviewer confirmed all strings localized correctly; `'WPM'` intentionally left untranslated matching the codebase-wide convention (also unlocalized in story_sprint/sandbox/typing_test/etc.).

