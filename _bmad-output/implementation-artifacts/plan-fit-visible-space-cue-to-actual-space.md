---
title: 'Fit visible space cue within the actual lesson space'
type: 'bugfix'
ticket: ''
created: '2026-09-29'
status: 'built'
route: 'oneshot'
route_source: 'auto'
baseline_revision: '2003c7030b008966e9f6bb2dfa58ca4a387f2d11'
review: 'quick'
review_source: 'auto'
lenses_ran: ['quick']
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The visible cue for a current or incorrect space paints wider than the actual space and its highlight overlaps neighboring lesson letters.

**Approach:** Keep the ordinary space and stable word positions; constrain the visible cue and highlight to the space's measured bounds, with a focused rendering regression check.

</frozen-after-approval>

## Implementation Notes

The lesson text already renders an ordinary space in all states. `_SpaceCuePainter` centers an independently styled `␣` TextPainter over that space and its glyph and duplicate background/underline can extend outside the selected space box. Adjust only this painter and its existing widget test; keep the separate duplicate-key crash bug out of scope.

The first pass reduced the glyph font size and removed its duplicate background. The user's screenshot showed that this made the open box too small and removed the visible highlight. The final painter keeps the glyph's full height while narrowing it horizontally to the measured space and paints feedback only within that space. The widget test compares pixels outside the space against pending feedback, checks that the background fills the real space, and checks ink margins at 22, 28, 31, and 48 px. Focused tests and analysis pass; the running macOS app hot-reloaded after the final change. A live screenshot could not be captured through the Flutter driver because the app has no driver extension.

## Plan Change Log

## Review Triage Log

- `false` -- The reviewer suggested lost coverage for space feedback with earlier non-correct characters, but the original test never exercised those states; the new pixel comparison needs an identical preceding character as its baseline.
- `false` -- The reviewer could not see test or analyzer output in the diff; both commands completed successfully during this run.
- `false` -- Pixel comparisons use freshly rendered snapshots with identical neighboring text and font settings; the existing test already depended on Flutter-rendered pixels. The assertions are scoped to the measured space.
- `false` -- Implementation plans are kept under `implementation-artifacts` in this repository; existing build plans are versioned there.
- `patch` -- The user's screenshot showed a too-small glyph and missing highlight after the first pass; retained glyph height, constrained its width, and painted a background exactly within the measured space, with pixel regression coverage.

## Verification

**Commands:**
- `flutter test test/typing_display_test.dart` -- expected: space feedback remains visible, stays within the real space, and does not shift following letters.
- `flutter analyze lib/widgets/typing_display.dart test/typing_display_test.dart` -- expected: no diagnostics.