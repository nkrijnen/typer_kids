---
title: 'Verify the full Dutch keyboard course'
type: 'feature'
ticket: '9'
created: '2026-10-06'
status: done
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

**Problem:** Unit contracts alone do not prove a learner can finish the complete Dutch keyboard route across categories, revisit a separate advanced path and resume isolated progress after restart.

**Approach:** Add a routed end-to-end Flutter tracer through the unchanged 16 letters, required stages 17-40 and separately accessible optional stages 41-46, with explicit completion, restart and English-isolation checks.

## Boundaries & Constraints

**Always:** Verify real navigation and typing to completion, not only direct `recordAttempt` calls. Core stages must unlock and recommend globally across every category; optional access after letter 16 and optional completion cannot gate core. Assert exact outline IDs, cumulative mapped exercise characters and opposite Shift/AltGr cues where introduced. Restart and switch profile/language without losing either Dutch path or modifying English progress. Run the full Flutter suite, analyzer and connected hot restart.

**Never:** Add new lessons, game/story content, dead keys or accents; do not replace smaller contracts with the tracer or claim native-speaker review is automated.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Required route | 16 letters followed by 24 core stages | Every lesson completes, next category unlocks, core complete | No premature unlock |
| Optional branch | Foundation done, later core incomplete | Advanced accessible without changing core recommendation | No required-course gate |
| Resume | App/provider restart and Dutch-English switch | Both Dutch paths and English progress preserved independently | No lost/mixed saves |

</frozen-after-approval>

## Code Map

- `test/widget_test.dart` -- existing app-router test types through the 16 letters and first Shift lesson; reuse helpers and route traversal where practical.
- `test/dutch_letter_course_integration_test.dart`, `test/dutch_complete_product_integration_test.dart` -- current persistence and content-count contracts, extend for core/optional distinction without duplicating long fixtures.
- `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart`, `test/features_test.dart` -- existing stage, modifier and provider assertions to complement the tracer.
- `lib/data/dutch_curriculum.dart`, `lib/providers/progress_provider.dart`, `lib/screens/lesson_list_screen.dart` -- inspect only if the routed test reveals a real defect; file any missing story-owned behavior back to its owner.
- `full-keyboard-curriculum-outline.md` -- stable stage IDs 1-46 and core/advanced boundaries.

## Tasks & Acceptance

**Execution:**
- [ ] `test/widget_test.dart` or a dedicated routed integration test if the existing file cannot house the full trace cleanly -- complete all required stages through UI and visit optional path separately.
- [ ] `test/dutch_letter_course_integration_test.dart`, `test/dutch_complete_product_integration_test.dart` -- assert restart, profile/language isolation, core and optional totals, exact IDs and mapped modifier coverage.
- [ ] `lib/data/dutch_curriculum.dart`, `lib/providers/progress_provider.dart`, `lib/screens/lesson_list_screen.dart` -- repair only failures in the complete route, keeping each fix in its owning behavior.

**Acceptance Criteria:**
- Given a learner starting with no Dutch progress, when all 40 core lessons are completed in their routed order, then the course shows complete and the 16 original lessons remain unchanged.
- Given the optional path is untouched or completed separately, when core completion is checked, then both states report the same required-course completion.
- Given restart plus Dutch-English profile switching, when resuming, then core and optional recommendations and saved English progress are intact.
- Given the final route, when all automated checks and a connected hot restart run, then the Flutter suite, analyzer and runtime checks pass.

## Implementation Notes

- 2026-10-10: Routed widget tests type all 40 required and all six optional stages, enter advanced immediately after the foundation, and verify completion and restart. Provider tests cover separate progress and English isolation. Full Flutter suite (138 tests), analyzer, and macOS hot restart pass. Native-speaker release review remains outside scope.

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/dutch_letter_course_integration_test.dart test/dutch_complete_product_integration_test.dart test/widget_test.dart` -- complete course and persistence route pass.
- `flutter test` and `flutter analyze` -- all regression gates pass.
- Connected Flutter hot restart -- no runtime error on the completed Dutch route.