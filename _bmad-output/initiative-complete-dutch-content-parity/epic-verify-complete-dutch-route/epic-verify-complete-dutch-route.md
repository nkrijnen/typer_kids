---
type: epic
title: "Verify the complete Dutch product route"
parent: initiative-complete-dutch-content-parity
covers: [DP-3, DP-4, DP-6, DP-7, DP-8, DP-10]
after: [epic-complete-dutch-curriculum, epic-dutch-game-parity, epic-dutch-story-library-parity]
risk: medium
---

# Verify the complete Dutch product route

## Description

Close all shared localization and routing gaps, then prove the complete Dutch product and unchanged English product as one restart-safe route.

## Outcome

The full Dutch variant is release-candidate complete under automated checks, with only native-language review remaining before release.

## Requirements

- DV-1 (DP-7): Every user-visible and semantic string reachable from the Dutch home route is Dutch, including profiles, settings, progress, badges, lessons, games, Free Practice, Typing Test, dialogs, feedback, errors, tooltips, and accessibility labels.
- DV-2 (DP-3, DP-8): Language and per-profile progress persist independently through restart and repeated Dutch-English switching without changing legacy English data.
- DV-3 (DP-4, DP-6): The final route reaches all 16 lessons, all six games and difficulties, and all three story difficulties without English fallback.
- DV-4 (DP-10): Focused tests, full Flutter tests, `flutter analyze`, automated restart coverage, and a connected hot restart smoke check pass.
- DV-5 (DP-8): The same route in English retains its current text, content counts, behavior, scores, statistics, progress, and saves.

## Done when

1. A Dutch widget/semantics inventory finds no known English string on any in-scope route and no clipped Dutch labels at tested phone and desktop sizes.
2. The final integration test completes the curriculum, every game, and every story tier, restarts, switches profiles and languages, and recovers the same state.
3. English regression tests prove unchanged content counts, routes, progress, games, stories, and statistics.
4. The full suite and analyzer pass and a connected app hot restarts without runtime errors.

## Boundaries

Shared app-shell localization, cross-capability routing, regression, responsive checks, and final verification. Not new content, new mechanics, native-language approval, platform packaging, or store release.

## References

- parent — _bmad-output/initiative-complete-dutch-content-parity/initiative-complete-dutch-content-parity.md, DP-7 through DP-10
- curriculum provider — _bmad-output/initiative-complete-dutch-content-parity/epic-complete-dutch-curriculum/epic-complete-dutch-curriculum.md
- game provider — _bmad-output/initiative-complete-dutch-content-parity/epic-dutch-game-parity/epic-dutch-game-parity.md
- story provider — _bmad-output/initiative-complete-dutch-content-parity/epic-dutch-story-library-parity/epic-dutch-story-library-parity.md

## Notes

- Waits on all three content epics because this epic changes no missing content on their behalf; it verifies and integrates their finished contracts.
- Decision: in-scope means every production route reachable from Home in Dutch, including profile management, settings, progress/badges, all lesson states, game states, Free Practice, Typing Test, dialogs, errors, tooltips, and semantics. Sandbox/dev-only routes not reachable from Home are excluded (2026-09-28).
- Decision: known-English absence is checked against the app's English string inventory, not a dictionary, because Dutch and English legitimately share words (2026-09-28).
- Decision: native-speaker review remains a release gate after autonomous build and is not represented as a blocking leaf (2026-09-28).
- Decision: tracer is the persisted language/profile regression, followed by the full route audit, cleanup, and one closing integration check (2026-09-28).