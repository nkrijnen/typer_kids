---
title: 'Story 4: Dutch ISO QWERTY keyboard guidance'
type: 'bugfix'
ticket: '4'
baseline_revision: 'abbc6f7ce35d8356353092d1948b974d661fe448'
created: '2026-09-28'
status: built
route: 'oneshot'
route_source: 'auto'
review: 'quick'
review_source: 'auto'
lenses_ran: ['quick']
review_loop_iteration: 0
followup_review_recommended: false
context:
  - '{project-root}/_bmad-output/backlog/story-fix-dutch-iso-qwerty-keyboard.md'
  - '{project-root}/_bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md'
warnings: []
deferred: []
---

<intent-contract>

## Intent

**Problem:** Dutch keyboard guidance still shows Netherlands KBDNE positions, so displayed keys, finger guidance, and typed-character lookup do not match the requested ISO QWERTY layout.

**Approach:** Correct Dutch rows and dependent base-key, shifted-character, modifier, display, and finger mappings against the layout matrix, with focused regression coverage. Keep English guidance and existing typing, lesson, and game mechanics unchanged.

</intent-contract>

## Implementation Notes

Oneshot is appropriate: this is a localized mapping and test correction, with the acceptance matrix and implementation touchpoint already identified.

Clarification: The user confirmed `layout-matrix.md` was physically checked against an actual Dutch Mac keyboard and is the complete supported physical-key contract. Characters absent from it, including the legacy accent dead keys, are unsupported. The story, SPEC, and spec memory now link to the matrix rather than repeating row values. Ticket scope edits are in `story-fix-dutch-iso-qwerty-keyboard.md`, `../specs/spec-dutch-iso-qwerty-keyboard/SPEC.md`, and `../specs/spec-dutch-iso-qwerty-keyboard/.memlog.md`.

## Verification

**Commands:**
- `flutter test test/keyboard_data_test.dart` -- validates the complete Dutch matrix and mapping behavior while protecting English mappings.
- `flutter test` -- all project tests pass.
- `flutter analyze` -- no analyzer issues.

## Auto Run Result

Status: blocked
Blocking condition: intent gap

The current implementation and tests support accented Dutch characters through `´` and `¨` dead keys. The requested layout matrix defines neither key nor a replacement dead-key/AltGr sequence, so mapping those characters to a physical key would require inventing behavior. No product source or tests were changed. Resolve whether accented characters should remain supported and, if so, specify their physical key sequences.

### Clarification and resumed build — 2026-09-28

Summary: Implemented the physically verified matrix as the sole supported Dutch key contract, including Shift outputs and € via AltGr on 2. Removed unsupported legacy accent dead-key mappings and guidance.

Files changed:
- `story-fix-dutch-iso-qwerty-keyboard.md` — references the canonical matrix and scopes mappings to listed characters.
- `story-fix-dutch-iso-qwerty-keyboard-plan.md` — records the resumed build, review, and verification.
- `../specs/spec-dutch-iso-qwerty-keyboard/SPEC.md` — makes the companion matrix authoritative.
- `../specs/spec-dutch-iso-qwerty-keyboard/.memlog.md` — removes duplicated layout details.
- `../../lib/data/keyboard_data.dart` — defines Dutch ISO rows and physical base/Shift/AltGr mappings.
- `../../lib/widgets/keyboard_widget.dart` — shows 2 €, AltGr semantics, and matrix-based highlighting.
- `../../lib/widgets/finger_guide.dart` — shows AltGr guidance and omits unsupported accents.
- `../../test/keyboard_data_test.dart` — covers all rows, shifted outputs, fingers, AltGr, unsupported characters, and English positions.
- `../../test/widget_test.dart` — covers euro guidance, unsupported accents, and shifted punctuation.

Review findings breakdown: 0 findings; 0 patches, 0 deferred, 0 rejected. Follow-up review recommendation: false.

Verification: `flutter test test/keyboard_data_test.dart` passed (4 tests); the full `flutter test` suite passed (67 tests); focused widget tests passed (4 tests); `flutter analyze` reported no issues; macOS app built and hot restart succeeded.

Residual risks: Characters absent from the confirmed matrix, including accented dead-key characters, intentionally have no Dutch physical-key mapping.

## Review Triage Log

### 2026-09-28 — Review pass
- verdicts: 0 findings — high 0, medium 0, low 0, false 0, maybe-false 0
- findings:
  - None.