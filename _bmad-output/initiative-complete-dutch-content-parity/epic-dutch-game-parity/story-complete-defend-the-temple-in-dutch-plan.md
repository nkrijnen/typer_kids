---
title: 'Complete Defend the Temple in Dutch'
type: 'feature'
ticket: '4'
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
baseline_revision: 'e74afbd'
---

<intent-contract>

## Intent

**Problem:** Defend the Temple already selects words via the language-aware `WordLists.randomWord`/`forDifficulty`, but its setup screen, HUD, quit dialog, live-play feedback, and game-over screen text are all hardcoded English, unlike the already-Dutch-complete Falling Words game.

**Approach:** Apply the exact localization pattern already proven in `falling_words_screen.dart`/`falling_words_views.dart` (`context.watch<LanguageProvider>().isDutch` ternaries at each string site) to `defend_temple_screen.dart` and `defend_temple_views.dart`: setup title/description/difficulty header/start button, top-bar difficulty badge, quit dialog, empty-state hint, input feedback/placeholder/space hint, and every game-over string (header, high-score banner, points label, best-score label, stat tile labels, replay/back buttons). Add Dutch widget tests mirroring the existing Falling Words Dutch tests (score recorded separately per language, medium/hard selections use the Dutch pool).

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical localization following an established, already-tested pattern in the same codebase; no new abstractions, no scoring/timing/spawn changes. Word selection was already language-aware — only UI strings needed conditional Dutch text.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name "Defend the Temple"` -- expected: pass (2 new Dutch tests)
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 0 findings — high 0, medium 0, low 0, false 0, maybe-false 0
- findings: none. Reviewer confirmed all setup/HUD/dialog/feedback/game-over strings are correctly localized with no leftover hardcoded English and no ternary logic bugs.

