---
title: 'Integrate cross-category course progress'
type: 'feature'
ticket: '7'
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

**Problem:** With several Dutch categories and a separate advanced path, category-first unlocks, recommendations and combined progress totals can mislead learners about required-course completion.

**Approach:** Complete the Dutch-only required/optional progress contract across every category, localize category labels and totals, and prove both paths persist independently over restart and English switching.

## Boundaries & Constraints

**Always:** Required stages 1-40 unlock one global predecessor at a time; optional stages 41-46 unlock after the foundation and then in optional order. Recommended core stage skips optional content; core total and completion exclude advanced lessons, while advanced completion is reported separately. Preserve all existing Dutch lesson IDs/saves and English category-based behavior, totals and progress. Show meaningful Dutch labels for all visible categories, not a generic `Letters` fallback.

**Never:** Re-author lesson content, change exercise difficulty or broaden this work into games, stories or an English progress migration.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Core category boundary | Previous required lesson incomplete | Next required stage locked and not recommended | No free first lesson per category |
| Optional-only progress | Foundation complete, core unfinished | Optional path can advance; core recommendation stays unchanged | No optional prerequisite for core |
| Core complete | Optional untouched | Required total/percentage and completion show complete; advanced separately incomplete | No total inflation |
| Restart and switch | Profile/language transition | Both Dutch paths restore; English state unchanged | No cross-profile or cross-language leak |

</frozen-after-approval>

## Code Map

- `lib/providers/progress_provider.dart` -- existing Dutch global `isLessonUnlocked`, `recommendedLesson`, `completedLessons`, `totalLessons`, `maxStars` and `completionPercentage`; clarify core versus optional aggregates without touching English branches.
- `lib/data/dutch_curriculum.dart`, `lib/models/lesson.dart` -- `isOptional` introduced by story 5.6; stable core and advanced order is the classification source.
- `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- category order and Dutch heading/optional presentation.
- `test/features_test.dart`, `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- provider, routed category and persistence checks.
- `full-keyboard-curriculum-outline.md` -- global core order and independent optional path contract.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/providers/progress_provider.dart` -- make required and optional aggregates/recommendations consistent across every category; keep English semantics unchanged.
- [ ] `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- present localized Dutch categories, distinct advanced progress, and accurate core totals.
- [ ] `test/features_test.dart`, `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- assert boundaries, independent recommendations, saved profile/language state and English regression.

**Acceptance Criteria:**
- Given a required category transition, when its predecessor is unfinished, then the next lesson stays locked; completion opens precisely that next stage, even after restart.
- Given optional stages in progress, when checking recommended lesson and core totals, then optional attempts neither displace the required recommendation nor inflate required completion.
- Given required course complete with optional incomplete, when viewing the Dutch home and progress screens, then core completion reads complete while advanced remains separately unfinished.
- Given English progress, when switching languages and profiles, then English unlocks, totals and saves remain unchanged.

## Implementation Notes

- 2026-10-10: Integrated global required unlocks/recommendations with independent optional progress and core-only totals, averages and stars. Restart and English isolation checks, full Flutter suite (138 tests), analyzer, and macOS hot restart pass.

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/features_test.dart test/dutch_letter_course_integration_test.dart test/widget_test.dart test/dutch_complete_product_integration_test.dart` -- required/optional category boundaries and restart isolation pass.
- `flutter test` and `flutter analyze` -- complete suite and analyzer pass.
- Connected Flutter hot restart -- totals and recommendations restore without errors.