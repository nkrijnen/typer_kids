---
id: SPEC-dutch-iso-qwerty-keyboard
companions:
  - layout-matrix.md
sources: []
---

# Dutch ISO QWERTY Keyboard Guidance

## Why

Dutch keyboard guidance currently does not match the requested physical ISO QWERTY layout. Learners need the displayed keys, finger guidance, and typed-character mapping to agree with that layout.

## Capabilities

- **CAP-1**
  - **intent:** A Dutch learner can use keyboard guidance that matches the requested ISO QWERTY physical layout.
  - **success:** Automated checks validate every Dutch row, special key, physical finger mapping, shifted character, and typing lookup against the companion matrix, while English keyboard behavior remains unchanged.

## Constraints

- The companion `layout-matrix.md` is the canonical complete contract for physical keys and base, Shift, and AltGr outputs; characters absent from it have no mapping.
- Preserve English keyboard behavior and existing lesson and game mechanics; change only Dutch mapping, display, finger guidance, and the tests needed to prove them.

## Non-goals

- Redesigning the keyboard widget, adding AZERTY, changing scoring, or revising Dutch curriculum content.

## Success signal

A focused automated check rejects stale Dutch rows or mismatched physical keys, accepts the complete requested matrix including € and backslash, and the existing test and analysis suites remain green for English behavior.