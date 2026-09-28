---
type: epic
title: "Dutch learning path works end to end"
parent: initiative-dutch-vertical-slice
covers: [CAP-1, CAP-2, CAP-3, CAP-4, CAP-5, CAP-6, CAP-7, CAP-8]
risk: high
status: in-progress
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
4. Locale, keyboard, content, accessibility, and end-to-end tests pass; human Dutch-language review follows the initiative before release.

## Boundaries

Includes only reachable milestone UI, content, keyboard, and per-profile progress. The spec's non-goals exclude the full Dutch course, all games, typing tests, and unrelated refactors.

## References

- parent — _bmad-output/initiative-dutch-vertical-slice/initiative-dutch-vertical-slice.md, Done when
- curriculum design — _bmad-output/backlog/story-design-dutch-touch-typing-curriculum.md, Description and Acceptance Criteria
- curriculum spec — _bmad-output/specs/spec-dutch-touch-typing-curriculum/SPEC.md, Capabilities and companion
- curriculum outline — _bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md, First-version letter-key progression
- spec — _bmad-output/specs/spec-dutch-vertical-slice/SPEC.md, Capabilities and companion

## Notes

- Assumption: Falling Words is the candidate game; story 1 checks which existing game fits before committing (2026-09-26).
- Superseded decision: Netherlands QWERTY is the target; story 2 originally required physical verification of its punctuation and dead keys (2026-09-26; superseded 2026-09-28).
- Baseline: user ran `flutter doctor` and `flutter pub get` successfully and `flutter test` passed all 37 existing tests (2026-09-27). The agent terminal still needs a path to `flutter` for its own checks.
- Completed: story 1.1, "Trace one Dutch path across the app", is done (2026-09-27).
- Next story: start planned story 1.2, "Implement Netherlands QWERTY keyboard guidance"; keep the baseline green and record the documented layout reference and automated checks.
- Decision: story 1 is the smallest real lesson/game/story path; stories 2-6 deepen it in one dependency lane to avoid shared-code collisions (2026-09-26).
- Decision: only recorded review cleanup belongs in the refactor sweep; functional fixes and tests stay in their owning stories (2026-09-26).
- Decision: standalone backlog story 3 owns the complete first-version Dutch curriculum design; story 1.3 consumes only the three milestone lessons from its result, while the full course remains outside this epic (2026-09-27).
- Satisfied external gate: standalone backlog story 3 is done and its curriculum outline is final (2026-09-27). Story 1.3 remains sequenced after story 1.2 through its in-epic prerequisite.
- Decision: accept the seven remaining stories in dependency order using automated verification; no human review checkpoint blocks their completion. Assume documented Netherlands QWERTY mappings, keep original-content provenance and all regression checks, and review Dutch language after the initiative before release. No physical-keyboard review is required (2026-09-28).