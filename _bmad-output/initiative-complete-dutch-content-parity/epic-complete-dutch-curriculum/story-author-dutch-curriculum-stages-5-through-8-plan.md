---
title: 'Author Dutch curriculum stages 5 through 8'
type: 'feature'
ticket: '2'
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
baseline_revision: '170c0afad46655e17e9a44025c6ee0a503b089c6'
---

<intent-contract>

## Intent

**Problem:** The Dutch curriculum stops at `nl-letter-04`; stages 5-8 (g/h, e/i, r/u, t/n) from the approved outline are not yet implemented as lessons.

**Approach:** Add lessons `nl-letter-05` through `nl-letter-08` to `DutchCurriculum.allLessons`, each with the outline's exact new keys, cumulative `focusKeys`, and drill/word examples taken verbatim from `_bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md` rows 5-8, following the existing lesson pattern in `lib/data/dutch_curriculum.dart`.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): mechanical content addition following an established pattern (4 existing lessons in the same file), driven by an already-approved, already-tested outline. No design ambiguity.

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart` -- expected: pass with lessons 5-8 added and test expectations updated
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues
