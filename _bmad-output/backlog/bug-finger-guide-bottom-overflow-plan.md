---
title: 'Fix Dutch finger guide bottom overflow'
type: 'bugfix'
ticket: '12'
created: '2026-10-05'
status: 'in-progress'
route: 'oneshot'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch space-target finger guide can overflow its 114 logical-pixel lesson slot, obscuring the thumb label and triggering a Flutter layout warning.

**Approach:** Reproduce the constrained guide in a widget test, then adjust its internal vertical sizing so the hand diagrams and complete label fit without clipping. Cover the Dutch thumb state and another affected label state.

</frozen-after-approval>

## Implementation Notes

One-shot route: expected small widget sizing correction and focused regression in two files. Candidate cause is the fixed 80px diagram plus 4px gap and a padded emoji label exceeding the 114px parent slot; confirm with a failing test before choosing the correction.

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name 'Dutch finger guide fits lesson slot'` -- expected: passes with no Flutter overflow and visible hands and label.
- `flutter analyze lib/widgets/finger_guide.dart test/widget_test.dart` -- expected: no new diagnostics.
- Dart hot reload or restart after code changes; connect to running app via DTD first.