---
type: epic
title: "Complete the Dutch letter curriculum"
parent: initiative-complete-dutch-content-parity
status: done
covers: [DP-1, DP-2, DP-3, DP-8, DP-9]
risk: medium
---

# Complete the Dutch letter curriculum

## Description

Replace the three compressed milestone lessons with the approved 16-stage F/J-first progression while preserving equivalent completed progress and keeping English untouched.

## Outcome

A Dutch learner moves through every letter exactly once in the approved order with cumulative, typeable practice and reliable unlocks.

## Requirements

- DC-1 (DP-1): `DutchCurriculum.allLessons` contains exactly 16 lessons ordered as `nl-letter-01` through `nl-letter-16`, with focus keys and difficulty matching the curriculum outline.
- DC-2 (DP-1, DP-9): Every lesson has a Dutch title, movement-focused description and tip, a focused drill, cumulative mixed practice, and a checkpoint exercise; natural Dutch words are used only when the taught set permits them.
- DC-3 (DP-2): Flutter data tests enforce the outline's IDs, key order, cumulative allowed characters, unique introduction, required fields, and lowercase-letter-plus-space boundary.
- DC-4 (DP-3): Old completions migrate `nl-home-letters` to stages 1-2, `nl-home-words` to stages 3-4, and `nl-home-house` to stage 5 without deleting old keys or overwriting newer destination results.
- DC-5 (DP-1, DP-3): The lesson list presents one Dutch Letters category in stage order, completion unlocks only the next stage, and recommended lesson/progress survives restart.
- DC-6 (DP-8): English lesson lists, IDs, categories, unlocks, and stored progress remain byte-for-byte compatible.

## Done when

1. The Dutch lesson list shows exactly 16 ordered stages and completes from F/J through Y.
2. Automated curriculum checks reject every unintroduced letter and any punctuation, capital, accent, duplicate ID, skipped order, or missing letter.
3. Migration tests cover each legacy lesson alone, all three together, repeat execution, and pre-existing destination progress.
4. Restart and language-switch tests preserve Dutch and English progress independently.

## Boundaries

The Dutch lowercase letter curriculum, its list/category presentation, unlock order, and legacy progress migration. Not punctuation, capitals, accents, word-game pools, stories, or new teaching mechanics.

## References

- parent — _bmad-output/initiative-complete-dutch-content-parity/initiative-complete-dutch-content-parity.md, DP-1 through DP-3
- spec — _bmad-output/specs/spec-dutch-touch-typing-curriculum/SPEC.md, Capabilities and Constraints
- content source — _bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md, First-version letter-key progression
- keyboard — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md, letter positions

## Notes

- Decision: one lesson implements one curriculum stage; no extra lesson type or runtime stage model is added (2026-09-28).
- Decision: use a Dutch-only Letters category so top and bottom reaches remain in pedagogical order instead of being regrouped by keyboard row (2026-09-28).
- Decision: stages 1-7 are beginner, 8-13 intermediate, and 14-16 advanced, matching the outline's difficulty column (2026-09-28).
- Decision: every story adds focused Flutter tests with its content; the closing test proves the integrated route (2026-09-28).
- Decision: tracer is entry 1; sequence is stage content, UI/progress integration, cleanup, then end-to-end verification (2026-09-28).