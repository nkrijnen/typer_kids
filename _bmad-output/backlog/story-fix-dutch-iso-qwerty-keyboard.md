---
id: 4
type: story
title: "Dutch keyboard guidance matches the requested ISO QWERTY layout"
parent: none
covers: [CAP-1]
after: []
assignee: ""
refined: false
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
   **Then** the number row starts with § and contains 2 (€), the top row ends with [ ], the home row ends with ; ' \\, and the bottom row starts with backtick followed by Z through / exactly as documented in the layout companion.
2. **Characters resolve to physical keys**
   **Given** Dutch letters, uppercase letters, punctuation, and €
   **When** a key is highlighted or its finger guidance is requested
   **Then** the physical base key, Shift requirement, display label, and finger are correct for the requested layout, including the ISO extra key and bottom-row backtick.
3. **Typing behavior stays coherent**
   **Given** Dutch exercises containing supported keys
   **When** a learner types them
   **Then** the same physical-key lookup used by guidance accepts the intended characters without changing lesson or game scoring.
4. **English behavior is preserved**
   **Given** the existing English keyboard and tests
   **When** the Dutch correction is applied
   **Then** English rows, colors, physical-key highlighting, and typing behavior remain unchanged.
5. **Regression checks are automated**
   **Given** the corrected mapping
   **When** focused keyboard tests and the existing Flutter checks run
   **Then** they pass for the Dutch matrix and English regression, and fail if any requested row or dependent mapping regresses.

## Boundaries

- Must not change: English keyboard behavior, lesson/game mechanics, scoring, or Dutch curriculum content.
- Do not redesign the keyboard widget, add AZERTY, or infer mappings from the previous Netherlands layout.
- No physical-keyboard review is required; the requested matrix is the acceptance reference.

## References

- requirement contract — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/SPEC.md
- layout matrix — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md
- current mapping implementation — lib/data/keyboard_data.dart
- related completed story — _bmad-output/initiative-dutch-vertical-slice/epic-dutch-learning-path/tickets.toml, entry 2

## Notes

- Decision: this is a follow-up to the completed keyboard story because the requested physical matrix supersedes its earlier mapping assumption (2026-09-28).
- Risk: shared keyboard helpers can affect Dutch lessons and games; focused mapping/widget tests must run before the full suite.