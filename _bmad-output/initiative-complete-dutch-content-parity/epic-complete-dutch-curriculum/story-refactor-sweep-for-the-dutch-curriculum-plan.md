---
title: 'Refactor sweep for the Dutch curriculum'
type: 'refactor'
ticket: '6'
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
baseline_revision: 'b2ce26a'
---

<intent-contract>

## Intent

**Problem:** Entries 1.1-1.5 authored `DutchCurriculum.allLessons` by hand-typing a fully cumulative `focusKeys` list on every one of 16 lessons, duplicating the growing key set 16 times and risking silent drift from the outline as new stages are added. No formal review findings were deferred by 1.1-1.5 (the one real bug found during 1.1's review was patched immediately, not deferred), so there is nothing recorded to resolve beyond this maintainability risk.

**Approach:** Refactor `lib/data/dutch_curriculum.dart` to author each stage as compact per-stage data (id, title, description, difficulty, its own new keys, exercises, fun tip) and derive every lesson's cumulative `focusKeys` by folding `newKeys` in stage order, eliminating hand-duplicated key arrays while producing byte-identical `Lesson` objects.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): internal-only refactor of one data file; public shape of `DutchCurriculum.allLessons` (a `List<Lesson>` with the same ids/titles/descriptions/focusKeys/exercises/funTips/order) is unchanged, so no test expectations should need to change. `allLessons` is now `static final` (computed once) instead of `static const`; nothing consumes it as a compile-time constant.

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/dutch_lesson_migration_test.dart` -- expected: pass unchanged (same lesson data)
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues
