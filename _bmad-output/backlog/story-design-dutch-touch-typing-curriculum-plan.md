---
title: 'Complete the first-version Dutch touch-typing curriculum design'
type: 'feature'
ticket: '3'
created: '2026-09-27'
status: done
baseline_revision: '33f224baaac530577addf8b61f1e5254522c7eae'
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

**Problem:** The Dutch curriculum specification stops after six opening stages, so maintainers do not yet have a complete, checked letter-key progression to build from. The post-E/I order and executable checks for cumulative keys, metadata, and examples are still unsettled.

**Approach:** Complete the specification companion with a Netherlands-QWERTY progression through every letter and add focused tests that parse the documented stages and report structural or taught-key violations. Keep this as curriculum design evidence rather than shipping the planned lessons in the app.

## Boundaries & Constraints

**Always:** Start from F/J anchors; introduce every lowercase letter exactly once; keep prior-key sets cumulative; state finger movement, practice type, difficulty, examples, and a review checkpoint for every stable stage ID; label non-words as drills; use natural age-appropriate Netherlands Dutch words only after their letters are available; preserve the existing Dutch vertical slice's three-lesson limit.

**Never:** Change either English curriculum, ship the complete plan through `DutchCurriculum`, alter runtime lesson models or unlock behavior, introduce punctuation, capitals, shift, dead keys, or accents, or add a human-review gate to first-version acceptance.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Complete outline | Ordered stage table beginning with the existing six stages | All 26 letters appear once, prior keys match preceding stages, and every example uses available letters or spaces | No errors |
| Missing or repeated structure | Missing/duplicate stage, letter, ID, order, or required metadata | Validation identifies each structural defect | Aggregate descriptive failures instead of stopping at the first row |
| Invalid example | Example contains an unavailable letter or unsupported character | Validation names the stage, example, and offending character | Keep punctuation and other deferred mappings rejected |

</frozen-after-approval>

## Code Map

- `_bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md` -- primary deliverable; retain its English-pack comparison and replace the post-stage-6 placeholder with the complete metadata-rich progression.
- `test/dutch_curriculum_plan_test.dart` -- new focused artifact test; parse the Markdown table with Dart core APIs, aggregate validation errors, and exercise malformed inputs as well as the real outline.
- `lib/data/lesson_curriculum.dart` -- evidence for F/J-first pairing, reach-and-return guidance, and cumulative reviews; read only.
- `lib/data/lesson_curriculum_comprehensive.dart` -- evidence for practice variety and for rejecting alphabetic sequencing; read only.
- `lib/data/dutch_curriculum.dart` -- existing one-lesson vertical-slice runtime content; do not expand in this story.
- `_bmad-output/initiative-dutch-vertical-slice/epic-dutch-learning-path/epic-dutch-learning-path.md` -- consumer boundary: story 1.3 later selects exactly three lessons from this completed design.

## Tasks & Acceptance

**Execution:**
- [x] `_bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md` -- expand the comparison rationale and rewrite the progression as stable stages from F/J through all letters, settling the post-E/I order by finger reach, movement review, and useful Dutch vocabulary.
- [x] `test/dutch_curriculum_plan_test.dart` -- validate stage order/IDs, required metadata, exact single introduction of a-z, cumulative prior keys, supported characters, and examples against available keys; include malformed cases proving actionable aggregate errors.

**Acceptance Criteria:**
- Given the classic and comprehensive English packs, when the outline is read, then it records retained and rejected key-order, finger-guidance, drill, and review patterns and explains why alphabetic introduction is unsuitable.
- Given the established six opening stages, when the completed table is parsed, then an ordered Netherlands-QWERTY progression introduces every remaining letter exactly once with complete cumulative metadata and review checkpoints.
- Given each stage's labelled examples, when content validation runs, then every character is already taught or newly introduced, drills are distinguished from Dutch words, and the documented words are natural and age-appropriate without English filler.
- Given malformed stage data, when focused tests run, then missing or duplicate stages, incomplete metadata, missing or duplicate letters, and unavailable example characters are reported while deferred non-letter mappings remain rejected.

## Implementation Notes

- Completed a 16-stage F/J-first progression through every letter with stable IDs, cumulative prior-key metadata, reviewed Dutch examples, movement guidance, difficulty, and checkpoints. Runtime lesson data remained unchanged.
- Added focused Markdown parsing and aggregate validation for table framing, exact stage/key order, metadata, duplicate keys, unsupported or unavailable characters, and an approved Dutch-word set.
- Verification: focused tests 4/4, full Flutter suite 53/53, and Flutter hot reload passed. Thorough review fixed 16 actionable findings, rejected 6 false findings, and deferred nothing.

## Plan Change Log

## Review Triage Log

- Pass 1 verdicts: high 0, medium 15, low 1, false 6, maybe-false 0.
- BH-1 — `medium`, `patch`: stage 4 assigns A to the wrong home finger movement; the left little finger rests on A and does not return to S.
- BH-2 — `low`, `patch`: stage 16 calls three Y words a full review although they do not exercise all learned letters; narrow the claim to mixed retrieval with earlier stages.
- BH-3 — `medium`, `patch`: validation derives cumulative state from row position but never checks that row orders ascend, so reordered stages can pass.
- BH-4 — `medium`, `patch`: converting prior keys to a set hides duplicate metadata instead of reporting it.
- BH-5 — `medium`, `patch`: any available-letter string labelled Dutch passes; a curated allowlist is needed to pin the editorially approved words.
- BH-6 — `false`, `reject`: the explicit consumer boundary permits up to three runtime lessons, and the diff itself confirms this story did not modify `DutchCurriculum`.
- BH-7 — `false`, `reject`: `in-review` and empty task/log state are transient workflow state before review completion, not product inconsistency.
- BH-8 — `false`, `reject`: the font plan labels its auto-run block as a previous attempt, so a current resumed `in-progress` state does not contradict that historical result.
- EC-1 — `medium`, `patch`: the parser skips the line after the header without verifying the Markdown separator, which can silently discard stage 1.
- EC-2 — `medium`, `patch`: a one-character pipe row reaches an invalid substring range instead of producing an aggregate diagnostic.
- EC-3 — `false`, `reject`: a blank or prose line terminates a Markdown table; exact sequence validation will report the resulting omitted stages without treating a later table as continuation.
- EC-4 — `medium`, `patch`: document-order rows with valid but shuffled order numbers are accepted; same defect as BH-3.
- EC-5 — `medium`, `patch`: zero or negative orders are not rejected and can evade the current positive-order scan.
- EC-6 — `medium`, `patch`: scanning only through the observed maximum does not report omitted trailing stable stages.
- EC-7 — `medium`, `patch`: duplicate prior keys are hidden by set conversion; same defect as BH-4.
- EC-8 — `medium`, `patch`: concatenating example text lets one non-empty example hide another empty example.
- EC-9 — `medium`, `patch`: arbitrary available-letter text can claim the Dutch label; same defect as BH-5.
- VG-1 — `medium`, `patch`: the test proves coverage but does not pin the approved F/J-first and post-E/I new-key sequence.
- VG-2 — `medium`, `patch`: exact orders 1 through 16 are not required, allowing order zero to replace the final stage; same root as EC-5 and EC-6.
- IA-1 — `medium`, `patch`: semantic vocabulary expectations currently live only in prose while tests cover syntax; the curated allowlist closes that executable gap.
- IA-2 — `false`, `reject`: the README change belongs to concurrent offline-font work and is not an implementation surface of this story.
- IA-3 — `false`, `reject`: the font plan status change belongs to that concurrent workflow and is not an implementation surface of this story.

## Design Notes

Use deliberate reach pairs after E/I rather than alphabetic groups: upper index reaches first, then lower/index and outer-finger reaches, reserving rare Dutch letters for later stages when words such as `taxi`, `quiz`, and `aqua` can be typed naturally. Validation should derive cumulative state from table order instead of trusting the documented prior-key column.

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart` -- expected: real outline and malformed-case diagnostics pass.
- `flutter test` -- expected: full existing suite remains green.