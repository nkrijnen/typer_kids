---
type: epic
title: "Build the complete Dutch story library"
parent: initiative-complete-dutch-content-parity
covers: [DP-6, DP-7, DP-8, DP-9]
after: [epic-dutch-game-parity]
risk: medium
---

# Build the complete Dutch story library

## Description

Replace the one-story Dutch fallback with difficulty-specific libraries matching the English 18/18/18 shape, using original Netherlands-Dutch prose and the existing practice and statistics mechanics.

## Outcome

Dutch learners receive varied, age-appropriate original passages at every difficulty in both Free Practice and Typing Test.

## Requirements

- DS-1 (DP-6): Dutch content is split into exactly 18 easy, 18 medium, and 18 hard passages; `De jas in de boom` remains one easy passage.
- DS-2 (DP-6, DP-9): Easy passages use short common sentences, medium passages use broader vocabulary and mixed punctuation, and hard passages use longer structures and the full supported punctuation set.
- DS-3 (DP-9): Every title and text is original Typer Kids Netherlands-Dutch for ages 10-12, uses only accepted keyboard characters, records `Origineel verhaal van Typer Kids`, and is neither copied nor translated from a copyrighted work.
- DS-4 (DP-6, DP-7): Difficulty selection in Free Practice and Typing Test chooses only the matching Dutch pool and shows Dutch titles, source, controls, statistics, results, and semantics.
- DS-5 (DP-8): English passage lists, random selection, display, and statistics remain unchanged.

## Done when

1. Automated data checks prove exact 18/18/18 counts, unique titles and text, required provenance, difficulty metadata, non-empty prose, and accepted characters.
2. Repeated Dutch selection at each difficulty never returns another tier or English passage.
3. Free Practice and Typing Test complete Dutch passages and show Dutch progress, WPM, accuracy, source, results, and semantics.
4. English selection and statistics regression tests remain green.

## Boundaries

The passage library and its existing Free Practice/Typing Test selection and presentation. Not Story Sprint sentences, translations of the English library, reading-comprehension mechanics, or a content-management system.

## References

- parent — _bmad-output/initiative-complete-dutch-content-parity/initiative-complete-dutch-content-parity.md, DP-6 and DP-9
- existing contract — lib/data/story_content.dart, StoryPassage and difficulty lists
- existing surfaces — lib/screens/sandbox and lib/screens/test
- keyboard constraint — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md

## Notes

- Waits on epic-dutch-game-parity because passage selection adopts its settled difficulty and language-routing contract.
- Decision: create separate Dutch data files by difficulty so easy, medium, and hard authoring lanes do not collide; `StoryContent` remains the public facade (2026-09-28).
- Decision: exactly 18 passages per tier matches the measured English lists; the existing Dutch easy passage counts as one (2026-09-28).
- Decision: no passage translates or adapts an English library excerpt. All prose is newly authored and carries the exact original-content source label (2026-09-28).
- Decision: batches are six passages except the first easy batch, which adds five beside the retained story; each batch validates its own data (2026-09-28).
- Decision: tracer is entry 1 plus the first easy batch; the three difficulty lanes then proceed independently before selection integration (2026-09-28).