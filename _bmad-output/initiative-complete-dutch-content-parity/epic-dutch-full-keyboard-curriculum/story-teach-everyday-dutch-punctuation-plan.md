---
title: 'Teach everyday Dutch punctuation'
type: 'feature'
ticket: '4'
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

**Problem:** Even after uppercase and digits, the Dutch course has no everyday punctuation for questions, quotations or complete sentences.

**Approach:** Teach `. ,`, `? !`, `: ; ' "`, and `- ( )` in that order, then add two mixed review/checkpoint lessons, matching outline rows 30-35 and physical Shift/base-key mappings.

## Boundaries & Constraints

**Always:** Use IDs `nl-punct-01` through `nl-punct-06` in the distinct Dutch `punctuation` category. Unshifted comma, period, semicolon, apostrophe and hyphen use the base key; `? ! : " ( )` use their matrix base key and opposite-hand Shift. Exercise characters are limited to keys introduced by this stage, earlier core stages and space; review lessons introduce nothing. Use natural Dutch text for ages 10-12.

**Never:** Add unmapped accents/dead keys, euro, advanced symbols, or English curriculum changes. Do not move integrated text stages 36-40 into punctuation lessons.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| First punctuation lesson | Digit review unfinished | Punctuation category visible but locked | No category-first shortcut |
| Shift punctuation | Question/exclamation/colon/quote/parenthesis | Physical base key and opposite Shift shown | No character-as-physical-key cue |
| Mixed checkpoint | Stages 30-33 completed | Reviews previously taught punctuation only | Reject premature advanced symbols |

</frozen-after-approval>

## Code Map

- `lib/data/dutch_curriculum.dart` -- add four introduction and two review `_Stage` rows.
- `lib/models/lesson.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- category enum/group/order and localized Dutch heading; keep English order identical.
- `lib/data/keyboard_data.dart`, `lib/widgets/keyboard_widget.dart`, `lib/widgets/finger_guide.dart` -- existing shifted-output mapping, physical finger and opposite Shift cue.
- `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart`, `test/widget_test.dart`, `test/dutch_letter_course_integration_test.dart` -- introduction/scope, mapped modifier and boundary tests.
- `full-keyboard-curriculum-outline.md` -- exact punctuation selection and core-versus-advanced boundary.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/data/dutch_curriculum.dart`, `lib/models/lesson.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- implement six ordered punctuation lessons and visible Dutch category.
- [ ] `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart` -- assert stage new keys, cumulative exercise scope and every punctuation/base/modifier pair.
- [ ] `test/widget_test.dart`, `test/dutch_letter_course_integration_test.dart`, `test/dutch_complete_product_integration_test.dart` -- exercise shifted and unshifted prompts, category lock, review and restart without English regressions.

**Acceptance Criteria:**
- Given digit review is incomplete, when opening punctuation, then its first lesson stays locked; after completion it unlocks in global order.
- Given any core punctuation prompt, when typing it, then the physical key and required modifier shown match the matrix and the input is accepted.
- Given a review lesson, when auditing its exercises, then it contains no character introduced after its prerequisite and no optional symbol.
- Given the expanded lessons, when switching to English or restarting, then Dutch punctuation progress remains isolated and English behavior unchanged.

## Implementation Notes

- 2026-10-10: Added six punctuation stages and Dutch category. Scope, mapping, routed typing and full Flutter suite (138 tests), analyzer, and macOS hot restart pass.

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/keyboard_data_test.dart test/widget_test.dart test/dutch_letter_course_integration_test.dart test/dutch_complete_product_integration_test.dart` -- curriculum and modifier guidance pass.
- `flutter test` and `flutter analyze` -- full gates pass.
- Connected Flutter hot restart -- mapped punctuation is usable without runtime errors.