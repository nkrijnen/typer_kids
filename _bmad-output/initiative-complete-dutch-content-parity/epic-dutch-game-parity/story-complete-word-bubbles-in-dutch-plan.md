---
title: 'Complete Word Bubbles in Dutch'
type: 'feature'
ticket: '5'
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
baseline_revision: 'a2cc8bf'
---

<intent-contract>

## Intent

**Problem:** Word Bubbles already selects words via the language-aware `WordLists.randomWord`/`forDifficulty`, but its setup screen, HUD difficulty badge, quit dialog, empty-state hint, live-play feedback, and game-over screen text are all hardcoded English, unlike the already-Dutch-complete Falling Words and Defend the Temple games.

**Approach:** Apply the same proven localization pattern (`context.watch<LanguageProvider>().isDutch` ternaries at each string site) to `word_bubbles_screen.dart` and `word_bubbles_views.dart`: setup title/description/difficulty header/start button, top-bar difficulty badge, quit dialog, empty-state hint, input feedback/placeholder/space hint, and every game-over string. Add Dutch widget tests mirroring the existing Falling Words/Defend the Temple Dutch tests.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical localization following the established pattern from tickets 2.4/prior Falling Words work; no scoring/timing/spawn changes. Word Bubbles' score includes a bubble-life bonus (not just word length), so the score-recorded test asserts `greaterThan(0)` rather than an exact value, unlike Defend the Temple's simpler `length * 10` scoring.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name "Word Bubbles"` -- expected: pass (2 new Dutch tests)
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 0 findings — high 0, medium 0, low 0, false 0, maybe-false 0
- findings: none. Reviewer confirmed all setup/HUD/dialog/feedback/game-over strings are correctly localized with no leftover hardcoded English and no ternary logic bugs.

