---
type: initiative
title: "Complete Dutch typing curriculum and content parity"
parent: none
covers: [DP-1, DP-2, DP-3, DP-4, DP-5, DP-6, DP-7, DP-8, DP-9, DP-10, DP-11, DP-12, DP-13, DP-14, DP-15]
risk: high
---

# Complete Dutch typing curriculum and content parity

## Description

Turn the proven Dutch vertical slice into a complete Dutch variant of Typer Kids. The initiative delivers the 16-stage letter foundation, every existing game, the complete story library, every user-facing route reachable in Dutch, and a full-keyboard learning progression through uppercase, everyday punctuation, digits, and applied Dutch text.

## Outcome

A Dutch child can learn every letter, progress through uppercase, everyday punctuation, digits, and useful Dutch text, optionally explore advanced keyboard symbols and euro, play all six games, use all three story difficulties, and return after restart without seeing English fallback or changing English progress.

## Requirements

- DP-1: The Dutch letter foundation contains exactly 16 ordered lessons corresponding one-to-one with `nl-letter-01` through `nl-letter-16` in the approved curriculum outline; each lesson teaches only its new keys plus prior keys and uses lowercase letters and spaces.
- DP-2: Automated Flutter tests prove unique stable lesson IDs and order, every letter introduced exactly once, cumulative prior-key validity, non-empty exercises, and no premature punctuation, capitals, accents, or unmapped characters within the letter foundation.
- DP-3: Existing completion for `nl-home-letters`, `nl-home-words`, and `nl-home-house` migrates idempotently to stages 1-2, 3-4, and 5 respectively; Dutch progress remains isolated by profile and language.
- DP-4: Falling Words, Defend the Temple, Word Bubbles, Speed Chase, Key Critters, and Story Sprint all select Dutch content at every supported difficulty and show Dutch setup, play, pause, feedback, result, and semantic text.
- DP-5: Dutch game data matches the existing English pool sizes: 302 unique easy words, 309 unique medium words, 279 unique hard words, and exactly 20 original Dutch Story Sprint sentences per difficulty; content is child-appropriate and difficulty-appropriate.
- DP-6: Free Practice and Typing Test expose exactly 18 original Dutch passages at each difficulty, matching the English 18/18/18 library; the existing `De jas in de boom` remains in easy.
- DP-7: Home, profiles, settings, progress, badges, lessons, all games, Free Practice, Typing Test, dialogs, tooltips, feedback, and accessibility semantics reachable in Dutch contain no unexplained English text or clipped Dutch labels.
- DP-8: English curriculum, content, game behavior, UI, saves, and progress remain unchanged.
- DP-9: All new Dutch prose is original Typer Kids content with recorded provenance, uses natural Netherlands Dutch for ages 10-12, and contains only characters typeable through the accepted Netherlands QWERTY mapping.
- DP-10: Focused tests, the full Flutter suite, `flutter analyze`, persistence restart tests, and one complete Dutch-route integration check pass.
- DP-11: After the unchanged 16-lesson letter foundation, the Dutch course provides an ordered, cumulative core progression for uppercase, digits, punctuation used in ordinary Dutch writing, and applied Dutch text, using varied introduction, mixing, and review formats inspired by the English comprehensive curriculum rather than its alphabetic key order.
- DP-12: A separate advanced, optional path teaches the remaining mapped keyboard symbols and `€` through the documented Shift and AltGr mappings; it does not block completion of the required core course.
- DP-13: Every new exercise character is covered by the Dutch ISO QWERTY matrix, and learner guidance identifies the correct physical key and required modifier; dead keys and accented letters remain out of scope.
- DP-14: Dutch lesson categories, unlocks, recommendations, progress totals, and restart behavior distinguish required core completion from optional advanced completion while preserving existing progress and all English behavior.
- DP-15: Automated curriculum, modifier-input, progress, and routed integration checks prove the full core path and optional path work without English regressions.

## Done when

1. The original 16 Dutch letter lessons remain unchanged, and the expanded core course completes through uppercase, digits, everyday punctuation, and integrated Dutch text.
2. All six games run at every difficulty with the exact Dutch pool contracts in DP-5 and no English fallback.
3. Dutch Free Practice and Typing Test each select from 18 easy, 18 medium, and 18 hard original passages.
4. An automated Dutch walkthrough covers every in-scope route and reports no known English UI or semantic labels; English regression checks remain green.
5. The full Flutter test suite and `flutter analyze` pass, followed by a successful hot restart smoke check.
6. The advanced symbols and euro path is clearly optional, uses mapped Shift/AltGr output, and does not prevent the core course from showing complete.

## Boundaries

The initiative owns Dutch content parity and the expanded Dutch typing course in the existing Flutter app. It adds uppercase, digits, everyday punctuation, and applied Dutch text after the original letter foundation; remaining matrix symbols and euro are optional advanced practice. It does not add dead keys, accented letters, new game mechanics, new games, cloud sync, or a new localization framework. Native-speaker release review and learning-outcome research remain pre-release follow-ups, not autonomous build gates. Tracer path: complete the 16 letter lessons, continue through the required full-keyboard course, optionally complete advanced symbols/euro, play each game, type each story tier, restart, switch to English, and return to intact Dutch progress.

- Touch point: `ProgressProvider` storage — idempotent Dutch lesson-ID migration and isolation; owner: epic-complete-dutch-curriculum
- Touch point: shared difficulty and keyboard data — consumed without changing English contracts; owner: epic-dutch-game-parity
- Touch point: shared app shell and semantics — Dutch routing and final audit; owner: epic-verify-complete-dutch-route
- Touch point: lesson keyboard and progress presentation — modifier guidance, required/optional completion, and category display; owner: epic-dutch-full-keyboard-curriculum

## References

- curriculum spec — _bmad-output/specs/spec-dutch-touch-typing-curriculum/SPEC.md, Capabilities and Constraints
- curriculum plan — _bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md, First-version letter-key progression
- keyboard constraint — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md, canonical layout
- keyboard guidance — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/SPEC.md, complete Dutch ISO QWERTY mapping contract
- proven baseline — _bmad-output/initiative-dutch-vertical-slice/initiative-dutch-vertical-slice.md, Done when and Notes
- code baseline — lib/data and lib/screens/games, current English and Dutch content contracts

## Notes

- Decision: create a new initiative because the completed vertical slice explicitly excludes the full course and remaining games (2026-09-28).
- Decision: the approved 16 stages become exactly 16 lessons; no unapproved number, punctuation, capital, accent, or mastery stages are invented (2026-09-28).
- Decision: rename production lessons to `nl-letter-01` through `nl-letter-16` and migrate old completion automatically; migration copies the old result to every equivalent replacement stage and is safe to run repeatedly (2026-09-28).
- Decision: game word pools match the current English counts exactly: 302 easy, 309 medium, and 279 hard; words are unique within a tier, lowercase, and may repeat across tiers only when their difficulty use differs (2026-09-28).
- Decision: story parity means Free Practice/Typing Test passages only, exactly 18 per difficulty; Story Sprint's 20 sentences per difficulty are separate game content (2026-09-28).
- Decision: builders author original Dutch content autonomously under automated constraints. Native-speaker review is deferred until before release and does not pause this build (2026-09-28).
- Decision: all content validation lives in Flutter tests under `test/`; do not add a second runtime validator or CI framework (2026-09-28).
- Decision: no entry has a plan or done checkpoint; the full tree is intended for one unattended `bmad-build-auto` run (2026-09-28).
- Source conflict: first-version curriculum SPEC and outline — they end the course at the lowercase alphabet and defer Shift/punctuation until a physical mapping exists; this initiative now extends that completed letter foundation using the later-established Dutch ISO QWERTY matrix.
- Decision: preserve the original 16 lesson IDs and completed progress as the required letter foundation; add a subsequent full-keyboard core course for uppercase, everyday punctuation, digits, and integrated Dutch text, with remaining symbols and euro in a separate optional advanced path (2026-10-04).
- Decision: the optional advanced path does not gate core course completion; the expanded curriculum epic owns its exact stages, stable IDs, and punctuation selection in a new curriculum outline (2026-10-04).
- Source conflict: DP-6 — the English hard pool contains modern copyrighted excerpts, but Dutch parity is count and difficulty parity only; Dutch content must be original and must not translate those excerpts.