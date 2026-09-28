---
title: 'Author Dutch curriculum stages 9 through 12'
type: 'feature'
ticket: '3'
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
baseline_revision: 'b58a335d6871e5bae8c421dd77eb98584c88d022'
---

<intent-contract>

## Intent

**Problem:** The Dutch curriculum stops at `nl-letter-08`; stages 9-12 (o/w, m/c, v/b, p) from the approved outline are not yet implemented.

**Approach:** Add lessons `nl-letter-09` through `nl-letter-12` to `DutchCurriculum.allLessons`, with the outline's exact new keys, cumulative `focusKeys`, and drill/word examples verbatim from the curriculum outline rows 9-12, following the established lesson pattern.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical content addition, same established pattern as stages 5-8, approved and already-tested outline.

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart` -- expected: pass with lessons 9-12 added and count expectations updated
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues
