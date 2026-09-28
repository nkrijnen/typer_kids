---
type: epic
title: "Give every game complete Dutch content"
parent: initiative-complete-dutch-content-parity
covers: [DP-4, DP-5, DP-7, DP-8, DP-9]
after: [epic-complete-dutch-curriculum]
risk: medium
---

# Give every game complete Dutch content

## Description

Fill the existing difficulty contracts with Dutch words and sentences, route all six game mechanics through them, and localize every game state without changing scoring or timing.

## Outcome

A Dutch learner can choose any game and difficulty and receive only suitable Dutch content and UI for the whole round.

## Requirements

- DG-1 (DP-5, DP-9): Dutch word pools contain exactly 302 easy, 309 medium, and 279 hard lowercase Netherlands-Dutch words, unique within each tier and typeable on the accepted keyboard.
- DG-2 (DP-5, DP-9): Story Sprint contains exactly 20 original Dutch sentences per tier; easy uses short lowercase statements, medium adds capitals and commas, and hard adds the punctuation already supported by the game and keyboard.
- DG-3 (DP-4): Every game chooses Dutch data whenever Dutch is active; Key Critters keeps its letter/digit mechanic but uses Dutch labels and the accepted key set.
- DG-4 (DP-4, DP-7): Menus, instructions, countdowns, pause/quit dialogs, live feedback, scores, records, statistics, results, buttons, tooltips, and semantics are Dutch in all six games.
- DG-5 (DP-8): Difficulty, timing, scoring, spawn behavior, sound, high scores, and all English content/UI remain unchanged.

## Done when

1. Exact-count, uniqueness, character, and difficulty-shape tests pass for all Dutch word and sentence pools.
2. Every game completes one automated Dutch round at each supported difficulty without selecting English content.
3. Dutch widget walkthroughs of menu, play, pause, and result states find no known English labels or semantics.
4. Equivalent English game tests remain green and stored scores retain their existing behavior.

## Boundaries

Content selection and localization for the six existing games. Not new mechanics, adaptive curriculum-stage filtering, new score storage, or punctuation teaching.

## References

- parent — _bmad-output/initiative-complete-dutch-content-parity/initiative-complete-dutch-content-parity.md, DP-4 and DP-5
- content contract — lib/data/word_lists.dart and lib/data/sentence_lists.dart
- game surfaces — lib/screens/games and lib/screens/games/widgets
- keyboard constraint — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md

## Notes

- Waits on epic-complete-dutch-curriculum because game vocabulary may use the full approved lowercase alphabet and must pass its character contract.
- Decision: game difficulty is independent of curriculum unlock state; do not add stage-aware filtering (2026-09-28).
- Decision: exact English word-pool counts are the parity target: 302/309/279. Keep words unique within each tier; cross-tier reuse is allowed only when the difficulty role differs (2026-09-28).
- Decision: Story Sprint owns its separate 20/20/20 sentence pools; these are not Free Practice passages (2026-09-28).
- Decision: tracer is completing the three word pools, then one full Defend the Temple route; remaining games follow the same settled contract (2026-09-28).