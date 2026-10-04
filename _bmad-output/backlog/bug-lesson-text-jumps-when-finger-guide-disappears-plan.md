---
title: "Lesson text jumps when finger guidance disappears"
type: bugfix
ticket: 7
created: "2026-10-04"
status: blocked
baseline_revision: 125a2432a9791197192bdf6723a59b0b3cbf5a27
route: oneshot
route_source: auto
review: quick
review_source: auto
lenses_ran: [quick]
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
blocked_at: "2026-10-04"
blocked_reason: "finalization left repository dirty because unrelated concurrent initiative and passage-space files remain modified or untracked"
---

<intent-contract>

## Intent

**Problem:** On tall lesson screens, the typing prompt shifts when finger guidance disappears for an unmapped character or after an exercise ends, while the completed prompt is still visible.

**Approach:** Keep a stable finger-guide slot whenever guidance is enabled, and verify the rendered prompt position through guide transitions and exercise completion.

</intent-contract>

## Tasks & Acceptance

**Execution:**
- [x] `lib/screens/typing_screen.dart` -- reserve the guide's vertical space on tall screens even when `FingerGuide` has no content -- keep the typing prompt centered consistently.
- [x] `test/widget_test.dart` -- compare the rendered prompt position across mapped/unmapped guidance, non-final and final exercise completion, and a short viewport -- prevent regressions at the screen surface.

**Acceptance Criteria:**
- Given a tall lesson screen with mapped guidance, when guidance becomes unavailable or an exercise completes, then the visible typing prompt stays at the same vertical position until the screen transitions.
- Given the final exercise, when its last character is typed, then the completed prompt remains steady until results navigation.
- Given a short viewport where guidance is omitted, when an exercise completes, then the prompt remains steady.

## Implementation Notes

Oneshot is appropriate because the layout correction and focused regression test are under 100 lines. A previous run halted before source investigation because the ticket entry was untracked; the entry was committed in `125a243`, and this plan is now resumed.

- `lib/screens/typing_screen.dart`: reserve a 114 px top-aligned guide slot on tall screens. This matches the rendered guide height; short screens still omit the slot.
- `test/widget_test.dart`: exercise mapped-to-unmapped guidance using `é`, both completion waits, guidance returning, and short-viewport completion while comparing the screen-level prompt center.
- The first focused run measured a 2 px guide overflow at 112 px and a keyboard width overflow at 320 px; the slot and short test viewport were adjusted. The focused regression now passes.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name "lesson prompt stays positioned through finger guide transitions"` -- regression passes for tall and short layouts.
- `flutter analyze lib/screens/typing_screen.dart test/widget_test.dart` -- no issues in changed Dart files.
- `flutter analyze` -- no analyzer issues in the current tree.

## Review Triage Log

### 2026-10-04 — Review pass
- verdicts: 1 findings — high 0, medium 1, low 0, false 0, maybe-false 0
- findings:
	- `[medium]` `[patch]` Short-viewport completion boundary was untested — the test stopped at 499 ms although exercise advance occurs at 500 ms; added a boundary pump and prompt-position assertion, and the focused test passes for mapped and unmapped guidance.

## Auto Run Result

Status: blocked at finalization; implementation is built.

Summary: Reserved the finger-guide area on tall lesson screens so guidance disappearing for unmapped or completed characters no longer shifts the typing prompt.

Files changed:
- `lib/screens/typing_screen.dart` — fixed-height, top-aligned guide slot on tall layouts.
- `test/widget_test.dart` — screen-level position regression for mapped/unmapped guidance, non-final and final transitions, and short viewports.
- This plan — implementation, review, and verification record.

Review findings: one medium finding patched; no items deferred or rejected. Patched counts: high 0, medium 1, low 0. Follow-up review recommendation: false.

Verification: focused Flutter widget test passed; `flutter analyze` passed; macOS app built and hot reload succeeded. The app window could not be foregrounded in this environment, so no separate manual visual check was performed.

Residual risks: none known beyond the lack of a manual macOS visual check.

Finalization blocker: unrelated concurrent initiative and passage-space files remain modified or untracked, so the required clean-worktree gate cannot pass without changing work outside ticket 7.
