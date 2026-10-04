---
id: 11
type: bug
title: "Highlighted space grows wider in Free Practice, Typing Test, and Story Sprint"
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

# Highlighted space grows wider in Free Practice, Typing Test, and Story Sprint

## Description

While typing a passage, the character the cursor sits on is highlighted. When that character is a space, the highlighted space takes more horizontal room than the ordinary space it replaces, so the rest of the line nudges sideways as the cursor steps onto and off the space. The prompt should keep every character in place while only its feedback changes.

This is the same family of defect as ticket 5, which covers the lesson prompt. Ticket 5's surface, `TypingDisplay`, now paints the space cue instead of substituting a glyph. The passage surfaces were never changed and still shift.

## Reproduction

1. Open Free Practice (sandbox) or the Typing Test and pick any passage containing spaces.
2. Type up to the character just before a space and note the horizontal position of the next word.
3. Type that character so the space becomes the highlighted target.
4. Actual: the highlighted space is visibly wider than the ordinary space and the following word moves to the right; it moves back when the cursor advances past the space. Expected: the space keeps the same width in every feedback state while remaining visually distinguishable.
5. Repeat with a deliberately wrong keystroke on a space so it is marked incorrect; the same widening appears.
6. Repeat in Story Sprint, where the highlighted character is also styled differently from its neighbours.

## Cause Hypothesis

`PassageTypingDisplay` (used by Free Practice and the Typing Test) swaps the real space for the `␣` open-box glyph, U+2423, whenever the space is the current or incorrect character. The bundled typing font JetBrains Mono has no glyph for U+2423 at any weight, so that one character is drawn from a fallback font whose advance width is not the monospace 600/1000 em that every other character uses. The substituted character is therefore a different width from the space it replaced, and the line reflows.

Weight is not the cause: every bundled JetBrains Mono weight gives the space and the letters the same 600/1000 em advance, so the bold current-character styling alone does not move text. Story Sprint does not substitute a glyph, so it is listed for confirmation rather than as a known defect — verify whether it shifts before changing it.

The lesson surface already solves this by drawing the cue as an overlay over the real space, leaving the text untouched. Confirm the measured widths on the passage surfaces before choosing a correction, and prefer reusing the lesson approach over inventing a second one.

## Acceptance Criteria

1. **Passage text stays in place around spaces**
   **Given** a Free Practice or Typing Test passage containing spaces
   **When** the highlighted target moves from the character before a space onto the space and then past it
   **Then** the positions of all other characters and the passage's line breaks are unchanged, while the active space stays visually distinguishable from an untyped one.
2. **Incorrect spaces do not shift the passage**
   **Given** a passage in which a space has been typed incorrectly
   **When** that space is marked incorrect
   **Then** its width and its neighbours' positions are the same as in every other feedback state, and the mistake is still visible.
3. **Story Sprint is confirmed**
   **Given** a Story Sprint sentence containing spaces
   **When** the highlighted character moves across a space
   **Then** the sentence does not shift, either because it already holds position — recorded in Notes — or because it is corrected alongside the passage surfaces.
4. **The space cue stays legible**
   **Given** the smallest and largest typing font sizes the passage surfaces use
   **When** a space is the current or the incorrect character
   **Then** the cue remains visible and contained within the space, without overlapping neighbouring characters.
5. **Tests cover the condition found and fixed**
   **Given** the widget tests
   **When** they run
   **Then** a regression check that fails on the reported behaviour and passes after the correction compares rendered character positions or widths as a space moves through the pending, current, incorrect, and correct states on the passage surfaces, across the font sizes in criterion 4.
6. **Or: no change is needed, with proof**
   **Given** the reproduction
   **When** it is run on the current code
   **Then** the passage text already stays in place, or the report is mistaken, with evidence recorded in Notes; this supersedes criteria 1 through 5.

## References

- parent — none
- related — ticket 5, the same defect on the lesson prompt

## Notes

- Verified while writing this report: `assets/fonts/JetBrainsMono-{Regular,Medium,SemiBold,Bold}.ttf` have no U+2423 glyph, and the space and letter advance widths are 600/1000 em in all four weights.
- Assumption: the report came from one of the passage surfaces. If it was the lesson prompt instead, this report folds into ticket 5 — confirm the surface during reproduction.
- Risk: the passage display is shared by Free Practice and the Typing Test and windows long texts for performance, so a layout change can affect wrapping, scrolling, and the visible window.
- Severity: typing still works, but a target that moves while the learner aims at it undermines the core practice loop.
