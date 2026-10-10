---
title: 'Refactor sweep for the expanded Dutch course'
type: 'refactor'
ticket: '8'
created: '2026-10-06'
status: ready-for-dev
route: 'full'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** After stories 5.1-5.7, expanded curriculum and progress code may have recorded duplication or design debt that makes future maintenance risky.

**Approach:** Review only documented course cleanup findings, resolve worthwhile nonfunctional ones and retain any rejected suggestions with a reason; leave missing product behavior in its owning story.

## Boundaries & Constraints

**Always:** Begin by reading the prior story plans' review triage/change logs, plus the resulting code and tests. Link each cleanup action to an actual recorded finding, preserve stable IDs, order, modifier cues, progress semantics, saves and English behavior. If no actionable findings remain, record that explicitly rather than inventing a refactor.

**Never:** Move unfinished curriculum content, optional access, progress features or tests into this sweep; avoid broad architecture changes or a new abstraction without demonstrated duplication.

</frozen-after-approval>

## Code Map

- `story-*-plan.md` in this epic -- read actual findings from completed 5.1-5.7 builds at execution time; this draft cannot predict them.
- `lib/data/dutch_curriculum.dart`, `lib/providers/progress_provider.dart`, `lib/screens/lesson_list_screen.dart` -- likely ownership if a recorded finding points to generated stages, cross-category state or presentation.
- `test/dutch_curriculum_plan_test.dart`, `test/features_test.dart`, `test/widget_test.dart` -- relevant invariant and English-preservation tests, only as affected by a confirmed cleanup.

## Tasks & Acceptance

**Execution:**
- [ ] `story-*-plan.md` -- enumerate actual cleanup findings from 5.1-5.7 with decision and reason for each.
- [ ] `lib/data/dutch_curriculum.dart`, `lib/providers/progress_provider.dart`, `lib/screens/lesson_list_screen.dart` -- touch only files with a recorded, verified nonfunctional finding; preserve behavior.
- [ ] `test/dutch_curriculum_plan_test.dart`, `test/features_test.dart`, `test/widget_test.dart` -- run and, only if a confirmed cleanup needs it, add tests guarding invariants.

**Acceptance Criteria:**
- Given the completed story reviews, when this sweep ends, then every recorded maintainability finding is resolved or retained with a documented reason.
- Given unchanged Dutch and English behavior, when curriculum and progress checks run, then all lesson IDs, saved data, recommendations and modifier cues remain identical.
- Given no actionable finding, when this story is verified, then the absence of unnecessary edits is the result and all focused checks still pass.

## Implementation Notes

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/dutch_letter_course_integration_test.dart test/features_test.dart test/widget_test.dart test/keyboard_data_test.dart` -- curriculum, progress and English checks pass.
- `flutter test` and `flutter analyze` -- full suite and analyzer pass.
- Connected Flutter hot reload or restart if Dart/Flutter code changes -- runtime has no errors.