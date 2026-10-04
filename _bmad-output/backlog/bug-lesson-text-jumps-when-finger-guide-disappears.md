---
id: 7
type: bug
title: "Lesson text jumps when finger guidance disappears"
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

# Lesson text jumps when finger guidance disappears

## Description

The lesson prompt moves upward when the finger guidance disappears after the last character of an exercise. This is visible before the next exercise or results screen appears. The prompt should stay in the same position while guidance changes, as it does when the initial typing prompt hides.

## Reproduction

1. On a viewport tall enough to show finger guidance, start a typing lesson with more than one exercise.
2. Note the vertical position of the prompt while the last character of an exercise is highlighted and finger guidance is visible.
3. Type that character and watch the prompt before the next exercise appears (about half a second later). Repeat on the last exercise before the results screen appears (about 300 ms later).
4. Actual: finger guidance disappears and the completed prompt moves upward, then the next prompt moves back down when guidance returns. Expected: the completed prompt stays at its previous vertical position until the screen changes.

## Cause Hypothesis

The active character becomes absent at the end of an exercise, so the finger guide may stop occupying vertical space while the lesson prompt remains centered in the remaining space. Guidance for characters without a mapped finger may cause the same transition. Confirm the rendered positions before choosing a correction.

## Acceptance Criteria

1. **Exercise completion keeps the prompt steady**
   **Given** a lesson with finger guidance visible on the last character of a non-final exercise
   **When** that character is typed and the lesson waits to advance
   **Then** the completed prompt remains at the same vertical position until the next exercise appears, without losing its visible feedback.
2. **Lesson completion keeps the prompt steady**
   **Given** finger guidance visible on the last character of the final exercise
   **When** that character is typed and the lesson waits to show results
   **Then** the completed prompt remains at the same vertical position until the results screen appears.
3. **Other guidance transitions do not move the prompt**
   **Given** a lesson in which finger guidance appears, disappears, or changes between characters, including one without mapped guidance
   **When** the learner advances through those characters
   **Then** the prompt stays in place; on a short viewport where finger guidance is not shown, completing an exercise also leaves the prompt steady.
4. **Tests cover the condition found and fixed**
   **Given** the lesson widget tests
   **When** they run
   **Then** a regression check that fails on the reported behavior and passes after correction compares the rendered prompt position before and after an exercise completes, and checks any other guidance transitions changed by the correction.
5. **Or: no change is needed, with proof**
   **Given** the reproduction
   **When** it is run on the current code
   **Then** the prompt already stays in place, or the report was mistaken, with evidence recorded in Notes; this supersedes criteria 1 through 4.

## References

- parent — none

## Notes

- Assumption: the reported movement is on a viewport tall enough to show finger guidance; confirm the affected viewport during reproduction.
- Risk: the lesson layout is shared across exercises, languages, and viewport sizes, so a guidance change can cause other prompts to move or overflow.
- Severity: the shifting prompt is distracting but typing remains possible.