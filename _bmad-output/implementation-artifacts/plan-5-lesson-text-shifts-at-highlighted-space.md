---
title: 'Keep lesson text stable around highlighted spaces'
type: 'bugfix'
ticket: '5'
created: '2026-09-29'
status: 'built'
route: 'oneshot'
route_source: 'auto'
baseline_revision: 'ba8957de268ad740d5acf6c273fe23154a4fbdeb'
review: 'quick'
review_source: 'auto'
lenses_ran: ['quick']
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Highlighting a space replaces the ordinary space with a visible open-box glyph whose advance width differs, shifting neighboring lesson characters.

**Approach:** Keep the rendered character width stable across pending, correct, current, and incorrect space feedback while retaining a clear visual cue for the active or incorrect space. Add a focused widget regression test that detects the former geometry shift.

</frozen-after-approval>

## Implementation Notes

The code investigation confirmed the backlog cause in `TypingDisplay._charSpan`: current and incorrect spaces render `␣`, while pending and correct spaces render `' '`. The smallest correction is to render the same ordinary space in every state and use the existing state styling to distinguish current and incorrect spaces. The regression test should compare the prompt's measured width or neighboring character position across state transitions.

The regression test measures the following word's global position. During validation, literal spaces still shifted when current/incorrect feedback applied bold weights, so space feedback now retains the normal typing weight while keeping its background and underline cues. Focused widget tests and analysis pass.

## Review Triage Log

- `patch` -- The first review correctly identified that local paragraph coordinates could not detect movement inside the centered `Wrap`; the test now compares the following paragraph's global position.
- `false` -- State-list length alignment is intentional for the exact three-character fixture and is unrelated to the reported layout behavior.
- `false` -- The baseline source and the focused regression establish the prior glyph substitution and the corrected state behavior; no additional production assertion is needed.

## Verification

**Commands:**
- `flutter test test/typing_display_test.dart` -- expected: focused regression and existing display tests pass.
- `flutter analyze lib/widgets/typing_display.dart test/typing_display_test.dart` -- expected: no diagnostics.
