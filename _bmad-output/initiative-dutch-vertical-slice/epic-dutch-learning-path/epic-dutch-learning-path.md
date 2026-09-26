---
type: epic
title: "Dutch learning path works end to end"
parent: initiative-dutch-vertical-slice
covers: [CAP-1, CAP-2, CAP-3, CAP-4, CAP-5, CAP-6, CAP-7, CAP-8]
risk: high
---

# Dutch learning path works end to end

## Description

Build the first language-aware Dutch route while leaving English behavior and existing progress intact. The referenced spec owns CAP-1 through CAP-8.

## Outcome

The spec's success signal: a child learns, plays, and practices in Dutch, then returns to unchanged English progress after restart.

## Done when

1. Dutch keyboard guidance, two introductory lessons, and one themed lesson work in order with validated taught keys.
2. One game and one original story work in Dutch without English content or UI on their paths.
3. Locale selection and progress isolation survive profile changes and restart without damaging English saves.
4. Locale, keyboard, content, accessibility, and end-to-end tests pass, with human Dutch language and physical keyboard review recorded.

## Boundaries

Includes only reachable milestone UI, content, keyboard, and per-profile progress. The spec's non-goals exclude the full Dutch course, all games, typing tests, and unrelated refactors.

## References

- parent — _bmad-output/initiative-dutch-vertical-slice/initiative-dutch-vertical-slice.md, Done when
- spec — _bmad-output/specs/spec-dutch-vertical-slice/SPEC.md, Capabilities and companion

## Notes

- Assumption: Falling Words is the candidate game; story 1 checks which existing game fits before committing (2026-09-26).
- Decision: Netherlands QWERTY is the target; story 2 still requires physical verification of its punctuation and dead keys (2026-09-26).
- Blocker: user confirmed Flutter SDK is not installed; install an SDK accessible to this workspace before implementation.
- Decision: story 1 is the smallest real lesson/game/story path; stories 2-6 deepen it in one dependency lane to avoid shared-code collisions (2026-09-26).
- Decision: only recorded review cleanup belongs in the refactor sweep; functional fixes and tests stay in their owning stories (2026-09-26).