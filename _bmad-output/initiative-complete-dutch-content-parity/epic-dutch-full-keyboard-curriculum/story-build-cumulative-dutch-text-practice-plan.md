---
title: 'Build cumulative Dutch text practice'
type: 'feature'
ticket: '5'
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

**Problem:** The skill drills teach the keys individually, but children need cumulative practice typing useful Dutch words and sentences with capitals, digits and everyday punctuation together.

**Approach:** Deliver `nl-text-01` through `nl-text-05` in outline order: names/words, number contexts, short sentences, longer punctuation-rich sentences and a final applied-text review.

## Boundaries & Constraints

**Always:** Follow stage orders 36-40, stable IDs, category mapping (`commonWords` then `sentences`) and no-new-character contract in `full-keyboard-curriculum-outline.md`. Author original natural Netherlands Dutch suitable for ages 10-12. Vary short introduction, mixing and review; each exercise uses only foundation and previously taught core characters. Core progress remains globally ordered through the category boundary; restarting resumes the recommended text lesson.

**Never:** Translate English copyrighted excerpts, add accented/dead-key characters or optional advanced symbols, gate core on optional completion or alter game/story-library data.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| First applied text | Punctuation checkpoint incomplete | Dutch word lesson locked | No category-first unlock |
| Integrated sentence | Previously taught core keys available | Child types complete, original Dutch text with appropriate punctuation | Reject unmapped/new symbols |
| Required review | Core stages through 39 complete | Final text lesson demonstrates capitals, numbers and punctuation | No optional prerequisite |

</frozen-after-approval>

## Code Map

- `lib/data/dutch_curriculum.dart` -- add five `_Stage` entries after punctuation review; cumulative `focusKeys` already generated.
- `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- expose two Dutch categories with localized headings and order; English categories unchanged.
- `lib/providers/progress_provider.dart` -- global Dutch predecessor unlock and recommendation across categories.
- `test/dutch_curriculum_plan_test.dart` -- cumulative key, stage and original content checks; `test/dutch_letter_course_integration_test.dart` and `test/widget_test.dart` -- routed unlock, typing and restart.
- `full-keyboard-curriculum-outline.md` -- authoritative text stages; optional symbols outside their allowed key scope.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/data/dutch_curriculum.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- implement five increasingly practical Dutch text lessons and localized category presentation.
- [ ] `test/dutch_curriculum_plan_test.dart` -- assert no stage adds new keys, exercises use only previously taught matrix characters and mix the required skills with original Dutch content.
- [ ] `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- verify cross-category locks, routed sentence completion, persistence and exact lesson count without English changes.

**Acceptance Criteria:**
- Given punctuation review complete, when continuing core, then Dutch word and sentence lessons unlock in the outline order across category boundaries.
- Given each integrated exercise, when its characters are validated, then all are already taught, mapped and appropriate for ages 10-12.
- Given the last required lesson, when completed and the app restarts, then the course reports core completion; optional stages added later will not revoke it.
- Given an English profile or route, when Dutch text is added, then English content and saved results are unaffected.

## Implementation Notes

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/dutch_letter_course_integration_test.dart test/widget_test.dart test/dutch_complete_product_integration_test.dart` -- text progression and persistence pass.
- `flutter test` and `flutter analyze` -- repository-wide checks pass.
- Connected Flutter hot restart -- updated course loads without errors.