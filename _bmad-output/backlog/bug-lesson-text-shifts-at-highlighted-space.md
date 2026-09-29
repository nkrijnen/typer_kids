---
id: 5
type: bug
title: "Lesson text shifts when the highlighted character is a space"
parent: none
covers: []
after: []
assignee: ""
refined: true
hitl: false
risk: medium
severity: P2
estimate: ""
---

# Lesson text shifts when the highlighted character is a space

## Description

While typing a lesson, the prompt changes width when the highlighted character moves from a letter to a space. The following letters shift position, making the prompt wiggle as the learner types. The visible space cue should remain clear without moving the surrounding text.

## Reproduction

1. On macOS, open a typing lesson whose prompt contains a space between letters, such as the F lesson shown in the report screenshots.
2. Observe the prompt with a letter highlighted just before the space.
3. Type that letter so the space becomes the highlighted target, then type the space to advance again.
4. Actual: the highlighted space occupies more horizontal room than the ordinary space; the prompt width and neighboring letter positions shift as the cursor advances. Expected: each character keeps its horizontal position while the highlighted target changes.

## Cause Hypothesis

The lesson prompt displays an ordinary space in its pending and correct states but a visible `␣` glyph in its current and incorrect states. That glyph may have a different advance width or trigger a different font than the ordinary space despite the shared fixed-width typing style. Confirm by comparing rendered character positions across those states before choosing a correction.

## Acceptance Criteria

1. **Lesson text stays in place around spaces**
   **Given** a lesson prompt containing a space between letters
   **When** the highlighted target moves from the preceding letter onto the space and then to the following letter
   **Then** the prompt width and the positions of its letters remain unchanged, while the active space remains visually distinguishable.
2. **Other feedback states do not shift the prompt**
   **Given** a lesson prompt containing spaces
   **When** a space is pending, correct, or marked incorrect
   **Then** changing its feedback state does not move neighboring characters or alter the prompt's line breaks.
3. **Tests cover the condition found and fixed**
   **Given** the lesson display tests
   **When** they run
   **Then** a regression check that fails on the reported behavior and passes on the correction compares rendered positions or widths as a space changes state, including the affected feedback states.
4. **Or: no change is needed, with proof**
   **Given** the reproduction
   **When** it is run on the current code
   **Then** the lesson text already stays in place, or the report is mistaken, with evidence recorded in Notes; this supersedes criteria 1 through 3.

## References

- parent — none

## Notes

- The two screenshots attached to the original report show the prompt before and during the highlighted space; they are not stored as repository files.
- Assumption: the space transition shown in the screenshots is from a lesson on macOS; confirm the exact lesson and other affected platforms during reproduction.
- Risk: the lesson display is shared across exercises, so a visual change can affect other lesson prompts and wrapping.
- Severity: typing remains possible, but the moving target disrupts the core practice flow.