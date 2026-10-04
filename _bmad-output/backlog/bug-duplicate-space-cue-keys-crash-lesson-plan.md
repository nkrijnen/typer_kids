---
title: 'Keep multiple lesson space cues keyed uniquely'
type: 'bugfix'
ticket: '6'
created: '2026-10-04'
status: done
route: 'oneshot'
route_source: 'auto'
baseline_revision: '9ee74cab56fa60d1ca27a9c6650c89248222e7e8'
review: 'quick'
review_source: 'auto'
lenses_ran: ['quick']
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
---

<intent-contract>

## Intent

**Problem:** Two word chunks with incorrect spaces create sibling cue widgets with the same state-only key, causing a Flutter duplicate-key assertion and interrupting a lesson.

**Approach:** Identify each cue by its position in the lesson rather than state alone, preserving cue painting and text layout. Cover simultaneous cues in separate chunks and other cue states with widget tests.

</intent-contract>

## Implementation Notes

The display's `Wrap` directly receives chunks from `TypingDisplay._chunk` in `lib/widgets/typing_display.dart`. Cue-bearing chunks use `ValueKey('space-cue-${cues.first.$2.name}')`, which repeats when two chunks share a cue state. Existing `test/typing_display_test.dart` tests only a single cue. Add a regression test with multiple incorrect spaces before changing the key; retain discoverable cue state in the key if practical. The change is under 100 lines across two files, so the oneshot route applies.

Added a widget regression in `test/typing_display_test.dart` with two incorrect cues in different chunks; it reproduced the reported duplicate-key assertion. `lib/widgets/typing_display.dart` now includes the chunk's text offset in each cue key. The test also checks two current cues and mixed cue states; existing space geometry checks remain unchanged. Five widget tests and focused analysis pass. A macOS debug app hot reload succeeded, though the sandboxed app could not be foregrounded for manual inspection.

## Plan Change Log

## Review Triage Log

### 2026-10-04 - Review pass
- verdicts: 0 findings -- high 0, medium 0, low 0, false 0, maybe-false 0
- findings: none

## Verification

**Commands:**
- `flutter test test/typing_display_test.dart` -- expected: multiple incorrect and current cues render without exceptions and existing visual geometry checks pass.
- `flutter analyze lib/widgets/typing_display.dart test/typing_display_test.dart` -- expected: no new diagnostics.

## Auto Run Result

- Fixed duplicate sibling space-cue keys by adding the chunk offset to each key.
- `lib/widgets/typing_display.dart`: use position-specific keys without changing painting or layout.
- `test/typing_display_test.dart`: reproduce two incorrect cues and cover multiple current cues while retaining geometry checks.
- Review: zero findings; zero patches (high 0, medium 0, low 0), zero deferred and zero rejected. Follow-up review not recommended.
- Verification: regression failed before the fix with the reported duplicate-key assertion; all 5 focused widget tests pass afterward; focused `flutter analyze` found no issues; macOS debug hot reload succeeded.
- Residual risk: the sandboxed macOS app could not be foregrounded for manual inspection; widget tests cover rendering and key behavior.