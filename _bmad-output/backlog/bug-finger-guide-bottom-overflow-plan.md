---
title: 'Fix Dutch finger guide bottom overflow'
type: 'bugfix'
ticket: '12'
created: '2026-10-05'
status: done
baseline_revision: 'c47da5d744e3ef0ce8fa0a7664eef0442447b4f3'
route: 'oneshot'
route_source: 'auto'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
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

The 114px lesson slot is in `lib/screens/typing_screen.dart`; the widget test reproduces a 4px RenderFlex overflow with Dutch thumb guidance at 1.2 text scale. At default test text scale it does not reproduce. The screenshot's reported 600x374 physical pixels do not establish a logical viewport or text scale. `Flexible(fit: FlexFit.loose)` lets the diagrams shrink to the space left by the label while retaining their 80px height when it fits. The regression covers the thumb and Dutch AltGr labels in `test/widget_test.dart`; targeted tests, analyzer, and macOS hot reload passed.

## Plan Change Log

## Review Triage Log

- Quick review (independent reviewer): No findings. Implementation matches plan requirements; code and regression test are valid.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name 'Dutch finger guide fits lesson slot'` -- expected: passes with no Flutter overflow and visible hands and label.
- `flutter analyze lib/widgets/finger_guide.dart test/widget_test.dart` -- expected: no new diagnostics.
- Dart hot reload or restart after code changes; connect to running app via DTD first.