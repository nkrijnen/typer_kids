---
id: 13
type: bug
title: "Typing passage shifts when start hints disappear"
parent: none
covers: []
after: []
assignee: ""
refined: false
hitl: false
risk: medium
severity: P2
estimate: ""
---

# Typing passage shifts when start hints disappear

## Description

In Typing Test and Free Practice, the passage moves when start or focus hints disappear as typing begins. The passage should stay in the same position while these hints appear or disappear.

## Reproduction

1. Set a 1000 × 900 logical-pixel desktop viewport. Open Typing Test and start a test.
2. Note the passage's vertical center while its start or focus hint is visible.
3. Type the first correct character.
4. Actual: the hint disappears and the passage moves. Expected: the passage stays in the same position.
5. Repeat in Free Practice, where the focus hint disappears on the first typed character.

## Cause Hypothesis

The hints appear to be added to and removed from the vertical layout around the passage instead of keeping their space reserved. Rebuilding the screen after typing changes the available space for the passage.

## Acceptance Criteria

1. **Typing Test keeps its passage steady**
   **Given** a typing test with a start or focus hint visible
   **When** the first typed character causes the hint to disappear
   **Then** the passage remains at the same vertical position.
2. **Free Practice keeps its passage steady**
   **Given** Free Practice with its focus hint visible
   **When** the first typed character causes the hint to disappear
   **Then** the passage remains at the same vertical position.
3. **Tests cover the affected screens**
   **Given** the widget tests
   **When** they run
   **Then** regression tests compare each passage's vertical center before and after the hint disappears at a 1000 × 900 logical-pixel viewport, within one logical pixel.
4. **Or: no change is needed, with proof**
   **Given** the reported transitions
   **When** they are reproduced at the same viewport
   **Then** both passages already stay in place, or the report was mistaken, with evidence recorded in Notes; this supersedes criteria 1 through 3.

## References

- parent — none

## Notes

- Assumption: Keep the existing hint text and visual style; only stabilize the passage position. No UX design artifact was found for these screens.
- Assumption: Keep existing focus-change and rebuild behavior; this ticket only stabilizes layout when current rebuilds show or hide hints.
- Open question: Four game input placeholders also change to typed input. Their effect on surrounding layout at narrow viewports was not confirmed in this audit and is outside this ticket.