---
title: 'Author Dutch curriculum stages 13 through 16'
type: 'feature'
ticket: '4'
created: '2026-09-28'
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
baseline_revision: 'ed5e5cc'
---

<intent-contract>

## Intent

**Problem:** The Dutch curriculum stops at `nl-letter-12`; the final stages 13-16 (z, x, q, y) are not yet implemented, so the 16-stage letter curriculum required by DP-1 is incomplete.

**Approach:** Add lessons `nl-letter-13` through `nl-letter-16` to `DutchCurriculum.allLessons`, with the outline's exact new keys, cumulative `focusKeys`, and drill/word examples verbatim from the curriculum outline rows 13-16, completing all-letter coverage.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical content addition, same established pattern as prior stages, approved and already-tested outline. This completes the 16-lesson curriculum (DP-1).

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart` -- expected: pass with all 16 lessons present
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues
