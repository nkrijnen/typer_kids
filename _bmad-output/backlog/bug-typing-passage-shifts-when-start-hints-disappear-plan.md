---
title: 'Keep typing passages steady when hints disappear'
type: 'bugfix'
ticket: '13'
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

**Problem:** In Typing Test and Free Practice, removing start or focus hints changes the height available to the centered passage, making it jump while typing begins. The passage should remain in the same vertical position across these transitions.

**Approach:** Preserve the vertical space occupied by each hint while hiding its content, keeping the existing text, styling, focus behavior, and passage rendering intact.

</frozen-after-approval>

## Implementation Notes

The two typing screens each place conditional hints beside an `Expanded` region containing a centered `PassageTypingDisplay`. Changing the siblings' height changes the passage's center. This is a small, directly testable layout change (estimated under 100 lines), so the automatic route is oneshot. No coding subagent interface is available in this session; the workflow permits direct implementation for oneshot.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name 'Typing Test passage stays centered when start hint disappears'` -- at a 1000 x 900 logical-pixel viewport, compare `PassageTypingDisplay` center before and after the first correct character, within one logical pixel; confirm the start hint disappears.
- `flutter test test/widget_test.dart --plain-name 'Free Practice passage stays centered when focus hint disappears'` -- at the same viewport, compare the passage center with focus hint visible and after it disappears, within one logical pixel.
- `flutter analyze lib/screens/test/typing_test_screen.dart lib/screens/sandbox/sandbox_screen.dart test/widget_test.dart` -- no new diagnostics.

The implementation should modify `lib/screens/test/typing_test_screen.dart` and `lib/screens/sandbox/sandbox_screen.dart` at their hint siblings in `_buildTyping`, plus `test/widget_test.dart` for screen-level tests. Reuse `LanguageProvider`, `GoogleFonts.config.allowRuntimeFetching = false`, `tester.view.devicePixelRatio = 1`, and the existing passage finder and key-event patterns. The Typing Test start hint is removed by `_hasStartedTyping` on first character; the focus hint is controlled by `_typingFocusNode.hasFocus` in both screens. For Free Practice, arrange a visible unfocused hint before measuring, then regain focus and send the first correct character; ensure a rebuild makes the focus transition observable. Avoid changing `PassageTypingDisplay`, timers, navigation, game placeholders, or unrelated tickets. If a pre-fix measurement shows both passages already stable, record evidence for the ticket's no-change acceptance route instead of modifying screen code.

## Plan Change Log

## Review Triage Log