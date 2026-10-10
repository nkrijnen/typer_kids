---
title: 'Add optional advanced symbols and euro'
type: 'feature'
ticket: '6'
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

**Problem:** The required Dutch course omits less common mapped symbols and euro; adding them to its linear order would incorrectly make optional practice a prerequisite for completion.

**Approach:** Build `nl-symbol-01` through `nl-symbol-06` as a distinct optional advanced path with correct base key, Shift or AltGr guidance, independent access after the 16-letter foundation, and no effect on core completion.

## Boundaries & Constraints

**Always:** Follow outline rows 41-46 and their matrix mapping: ISO outer keys, brackets, backslash/pipe, shifted number symbols, slash/angle signs, then `€` via AltGr+2. Advanced `focusKeys`/exercises rely only on lowercase letters, spaces and earlier optional keys, not unfinished core introductions. Add a backward-compatible optional marker defaulting to false for existing Dutch and English lessons. Optional lesson 1 unlocks after `nl-letter-16`, later optional lessons unlock in their own order; core remains independently recommended and complete without them.

**Never:** Add accents/dead keys, move these symbols into the required course, change English keyboard/progress, or postpone optional-path access to the later 5.7 polish story.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Foundation complete, core incomplete | Open advanced path | First optional lesson available, core still recommended | No dependence on text stage 40 |
| Optional symbol prompt | Shifted or euro output | Base key, matching finger and Shift/AltGr cue | Dead keys and accents absent |
| Required course complete | Optional untouched | Core completion stays complete | Optional count kept separate |

</frozen-after-approval>

## Code Map

- `lib/data/dutch_curriculum.dart`, `lib/models/lesson.dart` -- `_Stage` accumulation, optional stage marker and separate optional cumulative key scope; English constructor compatibility.
- `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- distinct Dutch optional `advancedSymbols` category and accessible entry.
- `lib/providers/progress_provider.dart` -- optional predecessor chain anchored to letter 16, independent from global required chain; core completion excludes optional.
- `lib/data/keyboard_data.dart`, `lib/widgets/keyboard_widget.dart`, `lib/widgets/finger_guide.dart` -- existing Shift and AltGr+2 mapping, reuse unchanged.
- `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart`, `test/features_test.dart`, `test/widget_test.dart` -- matrix completeness, optional unlock, modifier cues and completion isolation.
- `full-keyboard-curriculum-outline.md` -- authoritative grouping, exact optional stage IDs and no-core-prerequisite rule.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/data/dutch_curriculum.dart`, `lib/models/lesson.dart` -- implement all six advanced stages and optional marker, with independent cumulative exercise scope.
- [ ] `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart`, `lib/providers/progress_provider.dart` -- expose optional category, separate its unlock path and ensure optional completion cannot gate the required course.
- [ ] `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart`, `test/features_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- validate every matrix symbol, euro, no accents, branch access before core completion, restart and core isolation.

**Acceptance Criteria:**
- Given only the 16-letter foundation is complete, when opening advanced lessons, then the first optional symbol lesson is available and required upper/digit/punctuation/text lessons stay in their own order.
- Given any advanced exercise character, when prompted, then its output, base key, finger and modifier match the matrix, including AltGr+2 for euro.
- Given all core lessons complete but no optional result, when checking course completion after restart, then the core remains complete and optional progress is separately visible.
- Given English lessons, when advanced Dutch content is added, then English lesson IDs, unlocks and saved progress are unchanged.

## Implementation Notes

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/keyboard_data_test.dart test/features_test.dart test/widget_test.dart test/dutch_complete_product_integration_test.dart` -- optional/matrix behavior passes.
- `flutter test` and `flutter analyze` -- full gates pass.
- Connected Flutter hot restart -- optional category and modifier cues load without errors.