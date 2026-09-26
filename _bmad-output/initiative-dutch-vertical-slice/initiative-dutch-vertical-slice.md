---
type: initiative
title: "Dutch vertical slice for Typer Kids"
parent: none
covers: [CAP-1, CAP-2, CAP-3, CAP-4, CAP-5, CAP-6, CAP-7, CAP-8]
risk: high
---

# Dutch vertical slice for Typer Kids

## Description

Prove the first Dutch typing path before building the full course. The linked spec defines the slice.

## Outcome

A child finishes the Dutch path and returns to intact English progress after restart, as in the spec's success signal.

## Done when

1. A child completes Dutch lessons 1 and 2 and a themed lesson with accurate keyboard guidance.
2. One game and one story run entirely with Dutch content and reachable Dutch UI.
3. Language and per-profile progress persist through restart without changing existing English data.
4. Automated and human checks in the spec's companion pass for this path.

## Boundaries

Only the first vertical slice. Full Dutch course and cross-platform release remain in the roadmap. One epic owns every app touch point: settings, keyboard, curriculum, game, Free Practice, and progress.

## References

- spec — _bmad-output/specs/spec-dutch-vertical-slice/SPEC.md, Capabilities and companion

## Notes

- Decision: one slice epic includes its own platform baseline, so there is no separate platform-baseline epic (2026-09-26).
- Decision: target Netherlands QWERTY; physical punctuation/dead-key mappings require human verification (2026-09-26).
- Blocker: user confirmed Flutter SDK is not installed; implementation verification needs an accessible SDK.