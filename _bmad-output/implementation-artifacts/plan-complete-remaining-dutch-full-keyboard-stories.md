---
title: 'Complete remaining Dutch full-keyboard stories'
type: 'feature'
ticket: ''
created: '2026-10-10'
status: 'built'
baseline_revision: 'c7b23bb55422dbcaa6592ccf3c97c65b8bdff114'
route: 'full'
route_source: 'auto'
review: 'thorough'
review_source: 'auto'
lenses_ran: ['blind-hunter', 'edge-case-hunter', 'verification-gap', 'intent-alignment']
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch course currently ends at its first Shift lesson. Learners cannot finish uppercase, digits, everyday punctuation, practical text, or optional symbols, and the final progress and route have not been verified.

**Approach:** Build the eight remaining approved stories of the Dutch full-keyboard epic in dependency order (5.2 through 5.9), using their existing plans and the full-keyboard outline as the detailed contracts. Use parallel agents for independent checks or reviews where possible.

## Boundaries & Constraints

**Always:** Preserve the original 16 letter lessons and first Shift lesson, their stable IDs and saved progress. Follow outline rows 18-46 and the Dutch ISO QWERTY matrix. Keep optional lessons independently unlockable and outside required-course completion. Reconcile each finished story's plan and ticket state.

**Never:** Change English lesson behavior, copy English key order, add dead keys or accents, or claim native-speaker release approval. Do not implement a dependent story before its predecessor passes focused verification.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Core progression | Dutch learner completes each stage from `nl-shift-01` | Next required stage unlocks through `nl-text-05`; completion survives restart | Later stages remain locked until prerequisites complete |
| Optional progression | Foundation complete, required core incomplete | Optional symbols unlock in their own order; required recommendation and completion remain independent | Do not require later core stages |
| Keyboard guidance | Any taught uppercase, punctuation, or euro character | Correct physical key, finger, and Shift/AltGr cue | Reject unmapped or untaught exercise output |

</frozen-after-approval>

## Code Map

- `_bmad-output/initiative-complete-dutch-content-parity/epic-dutch-full-keyboard-curriculum/` -- existing approved 5.2-5.9 plans and `full-keyboard-curriculum-outline.md` own exact lesson groups and per-story acceptance; preserve their frozen blocks.
- `lib/data/dutch_curriculum.dart` -- `_Stage` and `_toLesson` create stable lessons and cumulative exercise scope; append stage groups in outline order.
- `lib/data/keyboard_data.dart`, `lib/widgets/finger_guide.dart` -- reuse mapped base keys and modifier guidance, including AltGr+2; do not remap the keyboard.
- `lib/models/lesson.dart`, `lib/providers/progress_provider.dart` -- distinguish optional from required lessons and keep separate unlock, recommendation, and progress aggregates.
- `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- expose Dutch categories and ordered navigation without altering English routes.
- `test/dutch_curriculum_plan_test.dart`, `test/keyboard_data_test.dart`, `test/features_test.dart`, `test/dutch_letter_course_integration_test.dart`, `test/widget_test.dart`, `test/dutch_complete_product_integration_test.dart` -- extend data, cue, unlock, persistence, and routed end-to-end checks in existing test homes.

## Tasks & Acceptance

**Execution:**
- [x] `lib/data/dutch_curriculum.dart` -- complete uppercase stages 18-25 (5.2), digits 26-29 (5.3), punctuation 30-35 (5.4), and text 36-40 (5.5); verify each group before the next.
- [x] `lib/models/lesson.dart`, `lib/data/dutch_curriculum.dart` -- implement optional stages 41-46 with independent cumulative scope and euro (5.6).
- [x] `lib/providers/progress_provider.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart` -- integrate category-crossing required progress and separate optional navigation (5.7).
- [x] Relevant production files -- resolve only recorded review findings in the refactor sweep (5.8).
- [x] Existing `test/` homes -- add each story's focused contracts and final routed verification of 40 required plus 6 optional lessons (5.9).

**Acceptance Criteria:**
- Given the approved Dutch outline, when the full course is loaded, then 40 required lessons precede 6 optional lessons with exact stable IDs and valid taught characters.
- Given completion of a required lesson, when progress is saved and reloaded, then the next required lesson is recommended across category boundaries without unlocking later required lessons prematurely.
- Given foundation completion without core completion, when optional practice is opened, then its independent sequence is accessible without changing core totals or recommendations.
- Given Dutch and English routes, when all focused and routed tests run, then modifier cues, course completion, persistence, and unchanged English behavior are verified.

## Implementation Notes

- 2026-10-10: Added 29 stages, independent optional curriculum scope, Dutch category navigation and separate core progress. Routed widget tests complete 40 core and 6 optional lessons; the optional category is also entered immediately after the 16-letter foundation.
- 2026-10-10: Thorough review patched the optional label, core averages, direct next-lesson boundary coverage and full routed verification. No outstanding maintenance finding justified a separate 5.8 refactor. Story plans and tickets 5.2-5.9 were reconciled to done.
- Verification: `flutter test` passed 139 tests; `flutter analyze` reported no issues; macOS app built and hot-restarted with zero runtime diagnostics before the temporary run was stopped. Native-speaker release review remains a follow-up.

## Plan Change Log

## Review Triage Log

- blind-hunter 1: false/reject. Category headings remain distinct despite reused palette colors.
- blind-hunter 2: medium/patch. `Extra tekens` lacks an explicit optional label; make the category heading unambiguous.
- blind-hunter 3: false/reject. The category progress widget already displays the optional completed/total count; provider getters are available to other consumers.
- blind-hunter 4: false/reject. The approved outline fixes the foundation at `nl-letter-16`; changing that contract would require a new outline and migration.
- blind-hunter 5: low/reject. Shadowing in the foundation seeding closure does not change the cumulative keys and adds no user-facing harm.
- blind-hunter 6: medium/patch. The migrated learner test covers the old 17 stages; extend the new course test to verify persisted core completion after restart.
- blind-hunter 7: false/reject. The plan deliberately keeps the core recommendation after optional practice; the optional category remains directly accessible.
- blind-hunter 8: false/reject. The first Shift lesson explicitly introduces opposite-hand Shift; subsequent lessons build on it.
- blind-hunter 9: false/reject. Native-speaker release review is explicitly outside this epic and no such approval is claimed.
- blind-hunter 10: low/reject. Existing color constants are reused; the labeled advanced heading identifies its content without relying on color semantics.
- edge-case-hunter 1: false/reject. All fixed 16 foundation stages have nonempty `newKeys`, so the described empty entry cannot occur.
- edge-case-hunter 2: false/reject. `nl-letter-16` is the approved stable foundation boundary, not a mutable last-core-stage lookup.
- edge-case-hunter 3: false/reject. Optional practice must not displace the required-course recommendation.
- edge-case-hunter 4: medium/patch. Optional attempts affect the core-based accuracy badge through `averageAccuracy`; separate core averages from optional attempts.
- verification-gap 1: medium/patch. The required-to-optional `nextLesson` boundary drives result navigation but has no direct assertion; add one.
- verification-gap other: false/reject. `maxStars` is currently not consumed in the UI, and changing it does not introduce an observable regression.
- intent-alignment: medium/patch. The data and provider cover all stages, but the existing routed test stops at stage 17; extend routed traversal across the core and optional path before claiming final route verification.
- intent-alignment process: medium/patch. Story plan and ticket state must be reconciled after verification; still pending.

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/keyboard_data_test.dart test/features_test.dart test/dutch_letter_course_integration_test.dart test/widget_test.dart test/dutch_complete_product_integration_test.dart` -- focused curriculum and routed checks pass.
- `flutter test` and `flutter analyze` -- full suite and analyzer pass.
- Connected Flutter hot restart -- updated course loads without runtime errors.