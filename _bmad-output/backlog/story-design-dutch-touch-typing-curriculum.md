---
id: 3
type: story
title: "A first-version Dutch touch-typing curriculum is ready to build"
parent: none
covers: [CAP-1, CAP-2, CAP-3]
after: []
assignee: ""
refined: false
hitl: false
risk: low
estimate: ""
---

# A first-version Dutch touch-typing curriculum is ready to build

## Description

Produce a complete first-version lesson progression for Dutch children aged 10-12, starting from F/J finger landmarks. Compare the classic and comprehensive English packs, extend the spec's opening stages across the remaining letter keys, and supply usable exercise examples and review points. This story designs and checks curriculum content; it does not ship the whole course or require real-world review.

## Acceptance Criteria

1. **English packs inform the design**
   **Given** the classic and comprehensive English lesson packs
   **When** the curriculum plan is completed
   **Then** it records which key-order, finger guidance, drill, and review patterns to retain or reject, including why alphabetic introduction is unsuitable for the Dutch course.
2. **The Dutch progression is complete**
   **Given** the spec's opening F/J-first stages
   **When** the first-version plan is completed
   **Then** it extends the six-stage outline through all remaining letter keys in an ordered, cumulative Netherlands-QWERTY progression, settling the post-E/I order and recording new and prior keys, finger movement, practice type, and review checkpoints for each stage.
3. **Practice fits the keys taught**
   **Given** each planned stage and its example exercises
   **When** the examples are checked
   **Then** every typed character has already been taught or is introduced in that stage, early patterns are labelled drills, and words presented as Dutch are natural and age-appropriate without English filler.
4. **The plan can be checked and revised**
   **Given** the completed progression
   **When** the first-version content checks run
   **Then** they report missing or duplicate stages, incomplete lesson metadata, and examples with unintroduced characters; unresolved later punctuation and accent mappings remain deferred rather than guessed.

## Boundaries

- Must not change: existing English lesson order or the limited acceptance scope of the Dutch vertical slice.
- No human review, child testing, or physical-keyboard verification is required for this first version; feedback after use may inform a later revision.
- Do not ship all planned lessons in this story. Punctuation, shift, dead keys, and accents need a separately established keyboard mapping before introduction.

## References

- curriculum contract — _bmad-output/specs/spec-dutch-touch-typing-curriculum/SPEC.md, Capabilities and companion
- milestone consumer — _bmad-output/initiative-dutch-vertical-slice/epic-dutch-learning-path/epic-dutch-learning-path.md, Done when and Notes

## Notes

- Decision: user requested a first version without any human real-world review gate (2026-09-27).
- Open question: settle the post-E/I letter order while completing the progression; use finger reach and useful Dutch words rather than alphabet order.
- Risk: low; this story writes a reversible plan and content checks without changing the running course.
- Consumer: Dutch learning-path story 1.3 uses this curriculum to replace the tracer lesson with exactly two introductory lessons and one themed lesson; the remaining curriculum stays outside that milestone.
- Decision: the first version covers every letter key and settles the post-E/I order; punctuation, shift, dead keys, and accents remain deferred (2026-09-27).