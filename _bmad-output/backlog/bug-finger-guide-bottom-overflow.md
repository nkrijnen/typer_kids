---
id: 12
type: bug
title: "Dutch finger guide overflows its vertical layout by one pixel"
parent: none
covers: []
after: []
assignee: ""
refined: true
hitl: false
risk: medium
severity: P3
estimate: ""
---

# Dutch finger guide overflows its vertical layout by one pixel

## Description

When the Dutch finger guide shows the thumb label, Flutter reports a one-pixel bottom overflow across the guide. The hands and the `Duim 👍` label should fit inside the guide without a layout warning or clipped content.

This was introduced recently. Didn't happen before okt 4, 2026.

## Reproduction

1. Run the macOS app with Dutch selected.
2. Open a typing lesson while the current target is a space, so the finger guide shows both hands and `Duim 👍`.
3. Actual: Flutter shows `BOTTOM OVERFLOWED BY 1.00 PIXELS` across the bottom of the finger guide, over the label. Expected: the complete guide and label fit with no overflow.

## Cause Hypothesis

The finger-guide content may be one pixel taller than the fixed-height area allocated to it. The hand diagram, spacing, and label are stacked vertically; the Dutch thumb label includes an emoji whose text metrics may make the content exceed that area.

## Acceptance Criteria

1. **The thumb guide fits without overflow**
   **Given** a Dutch typing lesson whose current target is a space
   **When** the finger guide is displayed
   **Then** both hands and the `Duim 👍` label remain fully visible, with no bottom overflow.
2. **Regression coverage detects the overflow**
   **Given** the widget tests
   **When** the Dutch thumb-guide state is rendered at the viewport that reproduces the report
   **Then** a test fails on the current overflow and passes when the guide fits, and covers any related label or viewport case changed by the correction.
3. **Or: no change is needed, with proof**
   **Given** the reported Dutch thumb-guide state
   **When** it is rendered at the viewport that reproduces the report
   **Then** no overflow occurs and the screenshot report is explained by recorded evidence in Notes; this supersedes criteria 1 and 2.

## References

- parent — none

## Notes

- Assumption: the screenshot shows the finger guide during a Dutch typing lesson with a space as the current target.
- Open question: confirm the exact lesson route and logical viewport dimensions used for the screenshot; the attachment shows a 600×374 image but does not identify its device-pixel ratio.