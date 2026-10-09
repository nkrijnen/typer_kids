---
title: 'Set the full-keyboard curriculum and ship the first Shift lesson'
type: 'feature'
ticket: '1'
created: '2026-10-05'
status: done
route: 'full'
route_source: 'auto'
baseline_revision: 'cf0c6e7c1c34d4f024f8cc498637113df98927a2'
review: 'thorough'
review_source: 'auto'
lenses_ran: ['blind-hunter', 'edge-case-hunter', 'verification-gap', 'intent-alignment']
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch course ends after 16 lowercase lessons, with no agreed full-keyboard stage contract or usable transition into Shift typing.

**Approach:** Record stable, cumulative core and optional stages against the Dutch ISO QWERTY matrix, then ship the first uppercase F/J lesson with physical Shift guidance, sequential unlock, and persisted progress.

## Boundaries & Constraints

**Always:** Preserve all 16 letter IDs and content; start new required IDs after them; specify every later core and optional stage's ID, category, characters, modifier, practice format, and checkpoint in the outline. Core uses uppercase, digits, everyday punctuation, and Dutch text; optional covers remaining mapped symbols and AltGr+2 euro. First Shift lesson teaches only F/J capitals plus previously taught lowercase letters and spaces. Dutch keyboard and finger cues follow the matrix.

**Never:** Change English progression or existing Dutch keyboard mapping; introduce dead keys, accents, or optional lessons as core prerequisites. Leave later lesson content and full optional completion behavior to stories 5.2-5.9.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| New Dutch learner | Letter 16 incomplete | First uppercase lesson visible but locked | No early start |
| Foundation complete | Letter 16 completed | First uppercase lesson unlocked and recommended, with F/J mapped to f/j and opposite-hand Shift | No unmapped cue |
| Return visit | Uppercase attempt completed, app restarted | Saved result and next recommendation restored without changing English saves | No duplicate migration or reset |

</frozen-after-approval>

## Code Map

- `lib/data/dutch_curriculum.dart` -- `_Stage` and `_toLesson` append cumulative stages; existing 16 must stay identical.
- `lib/models/lesson.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- Dutch category mapping/order and headings; English category order remains unchanged.
- `lib/providers/progress_provider.dart` -- `isLessonUnlocked` currently resets at each category, while `recommendedLesson` already follows global order; Dutch boundary must not unlock early.
- `lib/data/keyboard_data.dart`, `lib/widgets/finger_guide.dart`, `lib/widgets/keyboard_widget.dart` -- already resolve uppercase to lowercase physical keys, opposite Shift and finger; reuse without remapping.
- `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart` -- existing 16-stage and full matrix contracts; keep the first 16 checks while testing the new outline/lesson.
- `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- provider restart, routed lesson exercise and Shift semantics, exact product counts to extend without weakening the letter-foundation check.
- `_bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md` and `_bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md` -- fixed matrix and first 16 stages; the new outline belongs beside this epic, not in the first-version spec.

## Tasks & Acceptance

**Execution:**
- [x] `_bmad-output/initiative-complete-dutch-content-parity/epic-dutch-full-keyboard-curriculum/full-keyboard-curriculum-outline.md` -- define all future stages with exact IDs, required/optional status, cumulative character scope, category, base key/modifier, practice and reviews.
- [x] `lib/data/dutch_curriculum.dart`, `lib/models/lesson.dart`, `lib/data/lesson_curriculum_selector.dart` -- append first F/J Shift lesson in its Dutch category and expose it in global order without changing the 16 originals or English lists.
- [x] `lib/providers/progress_provider.dart`, `lib/screens/lesson_list_screen.dart` -- make this Dutch category boundary respect lesson 16 and show a distinct Dutch heading; leave English unlocks alone.
- [x] `test/dutch_curriculum_plan_test.dart`, `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- assert outline contract, cumulative characters, F/J Shift cues, locked/unlocked routed completion, restart, exact count and English isolation.

**Acceptance Criteria:**
- Given all original letter lessons, when the course is expanded, then their IDs, exercises, order and migrated completion stay identical, with the first uppercase lesson next.
- Given lesson 16 is unfinished, when the learner opens lessons, then the uppercase lesson is locked; when lesson 16 is completed, then it unlocks and is recommended.
- Given the first uppercase exercise, when F or J is prompted and typed, then the mapped f or j key, correct finger and opposite Shift are shown and the lesson can be completed.
- Given a completed uppercase lesson, when the app restarts or switches Dutch-English-Dutch, then Dutch completion and the next recommendation persist and English progress remains unchanged.
- Given the full outline, when its stages are audited against the matrix, then every taught character is mapped, core/optional completion is distinct, and modifiers and checkpoints are explicit.

## Implementation Notes

Added one `nl-shift-01` stage and a Dutch-only global unlock rule. The first 16 stages and all English category rules remain unchanged. Full outline enumerates 24 required and six optional follow-on stages; optional content and its completion model belong to stories 5.6-5.7. The routed exercise and separate semantics widget tests check the first F prompt and both Shift hands; the user also manually tested the new lesson successfully.

## Plan Change Log

## Review Triage Log

- 2026-10-06 thorough review: 1 medium (patched), 1 low (rejected), 12 false/maybe-false (rejected); verification-gap lens initially returned empty and was rerun.
- `false` blind: uppercase and topRow share emoji, but `categoryOrder` never displays both together in the same language.
- `false` blind: uppercase and topRow share a color, but they are exclusive across Dutch and English lesson lists.
- `false` blind: the Dutch unlock branch is clear from `_language == 'nl'` and the adjacent category branch; a comment adds no behavior or missing invariant.
- `false` blind: optional `isOptional` and its progress rules are specified for 5.6-5.7, not promised as implemented by the first Shift lesson.
- `false` blind: the outline test checks duplicate introductions, full mapped output coverage and stage order; later exercise content is owned by 5.2-5.6.
- `false` blind: only F/J are introduced in this change; later capitals are tested when implemented in 5.2.
- `low` blind, rejected: an explicit Dutch two-category list assertion would duplicate the routed lesson-list category-order check; no user-visible failure is shown.
- `false` blind: the routed lesson test uses 1000x900; the separate list test scrolls to the uppercase category in its default viewport.
- `maybe-false` edge, rejected: the test helper's ASCII key lookup would fail for future non-ASCII exercises, but this lesson contains only mapped ASCII letters; future symbol tests will use an appropriate key mapping.
- `medium` verification gap, `patch`: provider unlock tests did not prove a locked Shift lesson card rejects taps. Added the lesson-list widget assertion for disabled `onTap` and unchanged route; focused test passed.
- `false` intent: later-stage content, optional unlocks, optional marker, text patterns, and additional modifiers are outline-only and explicitly owned by stories 5.2-5.9, while the implemented F/J lesson meets this story's approved intent.

## Design Notes

Use the F/J home anchors for the first uppercase exercise; subsequent uppercase introductions follow the existing Dutch reach sequence, not English alphabetical order. Model the first category boundary now so later categories can use the same Dutch global prerequisite. Existing matrix guidance already handles uppercase; only strengthen its routed coverage.

## Verification

**Commands:**
- Focused curriculum, keyboard, persistence, widget, and product integration tests -- passed.
- `flutter test` -- passed: 132 tests.
- `flutter analyze` -- passed: no issues.
- Connected Flutter hot restart -- passed on macOS; runtime diagnostics reported no errors before the temporary session closed.