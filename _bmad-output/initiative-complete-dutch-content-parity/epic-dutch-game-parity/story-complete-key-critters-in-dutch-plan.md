---
title: 'Complete Key Critters in Dutch'
type: 'feature'
ticket: '7'
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
baseline_revision: '2441525'
---

<intent-contract>

## Intent

**Problem:** Key Critters uses a per-difficulty letter/digit key pool (`'asdfghjkl'`/full alphabet/alphanumeric) and a tricky-key bias that are keyboard-position-based, not vocabulary-based, so they must stay unchanged regardless of language. Its setup screen, tricky-key hint, difficulty badge, quit dialog, in-game instruction, and game-over screen text are all hardcoded English.

**Approach:** Apply the same proven localization pattern to `key_critters_screen.dart` and `key_critters_views.dart` without touching `_easyKeys`/`_mediumKeys`/`_hardKeys`, tricky-key selection, or scoring/timing logic. Add a Dutch widget test that bonks one critter (matching any currently displayed key) and verifies a separately-tracked high score plus Dutch game-over text.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical localization; the letter/digit pools and tricky-key bias are explicitly out of scope per the ticket and were not touched.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name "Key Critters"` -- expected: pass (1 new Dutch test)
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 0 findings — high 0, medium 0, low 0, false 0, maybe-false 0
- findings: none. Reviewer confirmed all strings localized correctly and, critically, verified the letter/digit pools, tricky-key bias, and spawn logic are byte-identical to before the diff.

