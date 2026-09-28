---
id: 4
type: story
title: "Dutch keyboard guidance matches the requested ISO QWERTY layout"
parent: none
covers: [CAP-1]
after: []
assignee: ""
refined: true
hitl: false
risk: medium
estimate: ""
---

# Dutch keyboard guidance matches the requested ISO QWERTY layout

## Description

Correct the Dutch keyboard rows and all dependent mapping helpers so visual guidance represents the requested ISO QWERTY keyboard from left to right. Keep English guidance and existing typing mechanics unchanged.

## Acceptance Criteria

1. **Rows match the physical layout**
   **Given** Dutch keyboard guidance
   **When** the rows are rendered or inspected
   **Then** every row matches the base-key rows in the canonical layout matrix; the space bar remains available as the thumb key.
2. **Characters resolve to physical keys**
   **Given** characters listed in the canonical layout matrix
   **When** a character is highlighted or its finger guidance is shown
   **Then** its base key, display label, and finger match the physical position in the matrix; uppercase letters use their lowercase key with Shift, shifted punctuation uses the listed shifted output with Shift, and € maps to 2 with AltGr. Characters not listed in the matrix have no Dutch physical-key mapping.
3. **Typing behavior stays coherent**
   **Given** Dutch exercises containing supported keys
   **When** a learner types them
   **Then** matching characters are accepted, other characters do not advance the exercise, and lesson and game scoring remain unchanged.
4. **English behavior is preserved**
   **Given** the existing English keyboard and tests
   **When** the Dutch correction is applied
   **Then** English rows, colors, physical-key highlighting, and typing behavior remain unchanged.
5. **Regression checks are automated**
   **Given** the Dutch mapping and English keyboard
   **When** `flutter test test/keyboard_data_test.dart`, `flutter test`, and `flutter analyze` run
   **Then** the focused tests check every row, special key, finger, shifted character, modifier, and typing lookup against the layout companion, English behavior remains unchanged, and all checks pass.

## Boundaries

- Must not change: English keyboard behavior, lesson/game mechanics, scoring, or Dutch curriculum content.
- Do not redesign the keyboard widget, add AZERTY, or infer mappings from the previous Netherlands layout.
- The matrix is the acceptance reference and was physically checked against an actual Dutch Mac keyboard.

## References

- requirement — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/SPEC.md, CAP-1
- canonical layout — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md, Dutch ISO QWERTY Layout Matrix

## Notes

- Decision: the requested ISO QWERTY matrix supersedes the earlier KBDNE mapping decision recorded in _bmad-output/initiative-dutch-vertical-slice/epic-dutch-learning-path/tickets.toml, entry 2 (2026-09-28).
- Implementation touchpoint: lib/data/keyboard_data.dart.
- Risk: shared keyboard helpers can affect Dutch lessons and games; focused mapping/widget tests must run before the full suite.