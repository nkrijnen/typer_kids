---
type: epic
title: "Extend the Dutch course across the full keyboard"
parent: initiative-complete-dutch-content-parity
status: done
covers: [DP-8, DP-11, DP-12, DP-13, DP-14, DP-15]
after: []
risk: medium
---

# Extend the Dutch course across the full keyboard

## Description

Continue the completed 16-lesson Dutch letter foundation with an ordered course that teaches uppercase, everyday punctuation, digits, and useful Dutch text, plus a separate optional advanced path for remaining mapped symbols and euro.

## Outcome

Dutch learners can progress from letter accuracy to practical full-keyboard typing with clear required-course completion and optional advanced practice.

## Requirements

- FC-1 (DP-11): Preserve the existing `nl-letter-01` through `nl-letter-16` lessons and their saved progress; new required stages continue after them in a stable, cumulative order.
- FC-2 (DP-11): Define and implement a substantial core sequence for uppercase letters, digits, everyday Dutch punctuation, and integrated Dutch words and sentences, using short introductions, mixing, and review inspired by the English comprehensive curriculum without adopting its alphabetic key order.
- FC-3 (DP-13): Every taught character and modifier cue agrees with the Dutch ISO QWERTY matrix; uppercase and shifted punctuation teach Shift, and physical finger/key guidance matches the mapped base key.
- FC-4 (DP-12, DP-13): Provide a separate advanced optional sequence for the other matrix symbols and `€` via AltGr+2; accented characters and dead keys stay out of scope, and this sequence does not gate core completion.
- FC-5 (DP-14): Dutch categories, global core unlocks, next/recommended lesson, progress totals, and completion state work across category boundaries and distinguish required core lessons from optional lessons.
- FC-6 (DP-15): Automated tests cover the curriculum contract, matrix-valid exercises, modifier guidance, progress persistence, routed core completion, optional-path access, and unchanged English behavior.

## Done when

1. All 16 original letter lessons retain their IDs, content, and saved progress, followed by a complete, ordered core course through uppercase, everyday punctuation, digits, and practical Dutch text.
2. Learners receive accurate physical key and modifier guidance for every core exercise character covered by the Dutch ISO QWERTY matrix.
3. The full core path unlocks in order across categories, resumes correctly after restart, and reports completion without requiring optional lessons.
4. Remaining mapped symbols and euro are available in a clearly separate optional advanced path; completing it never changes core completion semantics.
5. Focused curriculum and routed integration tests pass, the complete Flutter suite and `flutter analyze` pass, and English lesson behavior and progress remain unchanged.

## Boundaries

This epic owns Dutch lesson content, lesson ordering, key/modifier guidance in the lesson experience, and required-versus-optional lesson progress. It consumes the existing Dutch ISO QWERTY mapping and does not redesign that mapping, add dead keys or accented characters, alter games or story libraries, or change English lessons. Learning-outcome research and native-speaker release review remain follow-ups.

## References

- parent — _bmad-output/initiative-complete-dutch-content-parity/initiative-complete-dutch-content-parity.md, DP-11 through DP-15
- curriculum baseline — _bmad-output/specs/spec-dutch-touch-typing-curriculum/SPEC.md, Constraints and Non-goals
- letter outline — _bmad-output/specs/spec-dutch-touch-typing-curriculum/curriculum-outline.md, First-version letter-key progression
- keyboard contract — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md, base and shifted key matrices
- keyboard behavior — _bmad-output/specs/spec-dutch-iso-qwerty-keyboard/SPEC.md, CAP-1
- inspiration — lib/data/lesson_curriculum_comprehensive.dart, introduction/mix/review formats

## Notes

- Source conflict: the first-version curriculum spec and outline end after lowercase letters and explicitly defer Shift and punctuation; the later Dutch ISO QWERTY matrix now supplies the missing mapping contract.
- Decision: keep the 16 existing letter lessons as the required foundation, then teach uppercase, digits, everyday writing punctuation, and integrated Dutch text in the required course; put remaining symbols and euro in a separate optional advanced path (2026-10-04).
- Decision: optional lessons do not block required-course completion; entry 1 defines exact lesson IDs, grouping, and punctuation scope against the matrix before implementation begins (2026-10-04).
- Decision: use the English comprehensive pack only for varied introduction, mix, and review formats; preserve the Dutch F/J-first movement progression (2026-10-04).
- Decision: on 2026-10-05, the user directed autonomous implementation of this epic before epic-verify-complete-dutch-route closes; proceed from completed story 4.5 and keep route-wide release closure separate.
- Tracer: start with the full-keyboard outline and first Shift lesson, then complete all required categories, optional advanced content, cross-category progress, and the routed course test.
- Waits on epic-verify-complete-dutch-route because: the expansion builds on the verified 16-lesson foundation and Dutch production route.
