---
title: 'Teach the digit row'
type: 'feature'
ticket: '3'
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

**Problem:** Dutch learners finish Shift practice without learning the digit row, so they cannot type dates or numbers in later text lessons.

**Approach:** Add `nl-digit-01` through `nl-digit-04` with grouped reaches 1-3, 4-6 and 7-0, then a no-new-key review, using the canonical ISO QWERTY physical finger assignments.

## Boundaries & Constraints

**Always:** Follow outline orders 26-29, IDs, `numbers` category, cumulative available characters and checkpoint per row. Digits 0-9 appear exactly once as new keys; short drills and original Dutch number contexts mix taught letters, capitals and digits without premature punctuation. Base digit keys need no Shift; global Dutch unlock continues from `nl-shift-09`.

**Never:** Change number-row mapping, use shifted symbols or euro, introduce punctuation early, alter letter/uppercase stages or English behavior.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| First number lesson | Uppercase review unfinished | `nl-digit-01` remains locked | Category boundary grants no shortcut |
| Finger reach | New digit in current stage | Number-row key and correct mapped finger, no Shift | No invented finger cues |
| Number review | All digits available | Mixed retrieval with zero new keys | No punctuation introduced |

</frozen-after-approval>

## Code Map

- `lib/data/dutch_curriculum.dart` -- append stages after uppercase review using cumulative `_Stage.newKeys`.
- `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- include Dutch `numbers` category and its Dutch heading; English list unchanged.
- `lib/data/keyboard_data.dart` -- existing 0-9 Dutch base-key/finger mapping is the contract.
- `lib/providers/progress_provider.dart` -- Dutch global predecessor unlock and recommendation, including new category boundary.
- `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart`, `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- contract and route regression homes.
- `full-keyboard-curriculum-outline.md` -- fixed new-key groups, stage IDs and cumulative scope.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/data/dutch_curriculum.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- teach and display three digit introductions and mixed review in Dutch stage order.
- [ ] `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart` -- assert all 10 digits are introduced once, with only cumulative mapped exercises and unshifted finger guidance.
- [ ] `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- check cross-category lock, sequential completion, recommendation and persisted totals.

**Acceptance Criteria:**
- Given the uppercase review is unfinished, when the learner opens the Dutch number category, then `nl-digit-01` is locked; once it finishes, 1-3 become available.
- Given a digit exercise, when a digit is prompted, then its Dutch physical number key and finger are highlighted without a Shift cue.
- Given a completed stage, when the learner returns after restart, then the next number stage or review is recommended and earlier completion persists.
- Given the new lessons, when the data contract runs, then every exercise stays within the outline's cumulative scope and English content is unchanged.

## Implementation Notes

- 2026-10-10: Added four digit stages with unshifted number-row practice and globally ordered unlock. Focused and full Flutter suite (138 tests), analyzer, and macOS hot restart pass.

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/keyboard_data_test.dart test/dutch_letter_course_integration_test.dart test/widget_test.dart test/dutch_complete_product_integration_test.dart` -- mapping, scope, unlocking and restart pass.
- `flutter test` and `flutter analyze` -- full regression gates pass.
- Connected Flutter hot restart -- digit lessons load without errors.