---
title: 'Highlighted space grows wider in Free Practice, Typing Test, and Story Sprint'
type: 'bugfix'
ticket: '11'
created: '2026-10-04'
status: 'built'
baseline_revision: '125a2432a9791197192bdf6723a59b0b3cbf5a27'
route: 'full'
route_source: 'auto'
review: 'thorough'
review_source: 'auto'
lenses_ran: ['blind-hunter', 'edge-case-hunter', 'verification-gap', 'intent-alignment']
review_loop_iteration: 0
followup_review_recommended: true
context: []
warnings: ['oversized']
deferred: []
---

<intent-contract>

## Intent

**Problem:** `PassageTypingDisplay` substitutes the `␣` glyph (U+2423) for a real space whenever that space is the current or incorrect character. No bundled JetBrains Mono weight contains U+2423, so the character is drawn from a fallback font with a different advance width, and the passage reflows sideways as the cursor steps across a space in Free Practice and the Typing Test.

**Approach:** Keep the real space in the text on the passage surfaces and draw the `␣` cue as a painted overlay over that space, the way `TypingDisplay` already does for lessons. Lift the existing cue painter into one shared widget used by both surfaces rather than writing a second implementation.

## Boundaries & Constraints

**Always:** The text spans keep the real `' '` character in every feedback state, so character advance widths never depend on state. The cue stays inside the space's own box and stays visible to the learner. `TypingDisplay`'s existing behaviour and its test keys `space-cue-<state>-<chunkStart>` survive unchanged. Both surfaces keep their own accent colour and highlight alpha.

**Never:** Do not change `Story Sprint` unless the verification in Task 5 shows it actually shifts. Do not change word-chunking, the long-text windowing window sizes, cursor-follow scrolling, or the typing font. Do not solve this by picking a different substitute character or by padding the space.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Cursor steps onto a space | passage `a b`, space state goes pending → current | every other character keeps its exact position and width; the space shows a visible cue | No error expected |
| Space typed wrong | space state `incorrect` | same positions as pending; cue plus incorrect highlight visible | No error expected |
| Cursor leaves the space | space state → correct | positions unchanged; no cue painted | No error expected |
| Several cued spaces in one window | two chunks each ending in a current/incorrect space | each chunk paints its own cue; no duplicate-key crash | No error expected |
| Windowed long passage | text longer than 1100 chars, cursor mid-text | only windowed chunks build; cues still land on the right spaces | No error expected |

</intent-contract>

## Code Map

- `lib/widgets/typing_display.dart` -- lesson surface, already correct. `_SpaceCuePainter` (lines ~158-215) is the reference implementation: it reads the `RenderParagraph` via a `GlobalKey`, calls `getBoxesForSelection` for the space, clips to that box, fills it, and paints a `␣` `TextPainter` horizontally scaled to fit. `_chunk` (lines ~95-124) collects `(offsetInChunk, state)` cues and wraps the paragraph in a `CustomPaint` keyed `ValueKey('space-cue-${state.name}-$start')`. Extract both into the shared widget and have this file use it, keeping identical keys and colours (`AppColors.secondary` at alpha 0.25 for current, `AppColors.incorrect` at alpha 0.15 for incorrect; glyph `AppColors.textPrimary` / `AppColors.incorrect`; `height: 1.5`).
- `lib/widgets/passage_typing_display.dart` -- the defect. `_charSpan` lines 87-92 build `display` by swapping `' '` for `'␣'` on current/incorrect — delete that swap. `build` lines 166-183 emits one `Text.rich` per chunk inside a `KeyedSubtree`; that is where the shared cue widget goes. Note `_cursorKey` is already a `GlobalKey` on the chunk containing the cursor, and the cue widget needs its own separate key for the paragraph. Uses `height` default 1.6 and accent `widget.accentColor` at alpha 0.22.
- `lib/core/theme/app_theme.dart` -- `typingTextStyle`, default weight w500, default height 1.6. Read only.
- `lib/screens/sandbox/sandbox_screen.dart` line ~363 and `lib/screens/test/typing_test_screen.dart` line ~421 -- the only two `PassageTypingDisplay` call sites; both use the default `fontSize: 22` and differ only in `accentColor`. Read only.
- `lib/screens/games/story_sprint_screen.dart` lines ~527-562 -- three-span sentence rendering; does **not** substitute a glyph. Only to be verified, not changed by default.
- `test/typing_display_test.dart` -- the model for the regression test. The `space feedback keeps lesson text in place at $fontSize` test measures the following character's `left`, the chunk `Rect`, and reads `RepaintBoundary` pixels to prove the cue is visible and stays inside the space box. Reuse this structure; keep this file passing.
- `test/dutch_story_ui_test.dart` lines ~106 and ~222 -- read `PassageTypingDisplay` widget properties; must keep passing.
- `README.md` line 68 -- describes the `␣` behaviour; still accurate after the fix, no change needed.

## Tasks & Acceptance

**Execution:**
- [x] `lib/widgets/space_cue_text.dart` -- new file: move `_SpaceCuePainter` here and wrap it in a reusable widget that takes the chunk's `TextSpan`, the list of `(offsetInChunk, CharState)` cues, `fontSize`, line `height`, and the current/incorrect highlight colours, and returns the plain paragraph when there are no cues -- one cue implementation serving both surfaces, as the ticket requires.
- [x] `lib/widgets/typing_display.dart` -- delete the local painter and build chunks through the shared widget, passing `AppColors.secondary` at alpha 0.25, `AppColors.incorrect` at alpha 0.15, and `height: 1.5` -- behaviour and widget keys must be byte-for-byte equivalent so the existing test still passes untouched.
- [x] `lib/widgets/passage_typing_display.dart` -- drop the `'␣'` substitution from `_charSpan`, collect cue offsets per chunk, and render each chunk through the shared widget with `widget.accentColor` at alpha 0.22 and `height` matching the spans -- removes the fallback-font advance that causes the shift.
- [x] `test/passage_typing_display_test.dart` -- new file: regression coverage over the I/O matrix, modelled on `test/typing_display_test.dart` -- must fail before the fix and pass after.
- [x] `lib/screens/games/story_sprint_screen.dart` -- verify only: measure whether a highlighted space shifts the sentence. If it does not, record the evidence in Implementation Notes and leave the file unchanged; if it does, fix it the same way and cover it.

**Acceptance Criteria:**
- Given a passage containing a space, when the highlighted target moves from the character before that space onto it and then past it, then every other character's position and the passage's line breaks are identical in all four states, verified by measurement, not by eye.
- Given a space marked incorrect, when it renders, then its width equals its pending width and the mistake is still visible.
- Given the typing font sizes the passage surfaces use, when a space is current or incorrect, then the cue paints visible pixels strictly inside the space's own box and no pixels outside it.
- Given Story Sprint, when the highlighted character crosses a space, then the sentence holds position — either shown to already hold, with evidence in Implementation Notes, or corrected.
- Given the full test suite, when it runs, then it passes, including `test/typing_display_test.dart` and `test/dutch_story_ui_test.dart` unchanged.

## Implementation Notes

- `SpaceCueText` is a `StatefulWidget` so the paragraph `GlobalKey` is created once in `State` rather than on every build (the old `TypingDisplay._chunk` minted a fresh `GlobalKey` per build). Keys, colours and painter maths are otherwise unchanged; `test/typing_display_test.dart` passes untouched.
- The cue key is still `ValueKey('space-cue-<state>-<chunkStart>')` on the `CustomPaint`, so lessons keep their ticket-6-safe per-chunk uniqueness and the passage surface gets the same scheme.
- Story Sprint verification (temporary probe test, since removed): pumped the real `StorySprintScreen`, typed up to and past the first space of `"the milk is very cold."` (space at index 3) and measured the last character's text box plus the sentence `RichText` rect at cursor index 2, 3 and 4:
  - box: `Rect.fromLTRB(332.9, 4.0, 348.7, 38.4)` at all three positions
  - paragraph rect: `Rect.fromLTRB(225.6, 338.5, 574.4, 380.5)` at all three positions
  Story Sprint never substitutes a glyph, so it already holds position. `lib/screens/games/story_sprint_screen.dart` left unchanged.
- Limit of the test harness, measured in the parent session with a throwaway probe: rendering `a b` and `a␣b` at 28 px gives the same 50.4 px width, i.e. 0.6 em per character for both. The headless test environment has no system font-fallback chain, so the missing U+2423 renders as JetBrains Mono's own `.notdef` box at the normal monospace advance. The width shift the ticket reports therefore cannot be reproduced in a widget test — it needs the platform fallback font that a real macOS run supplies. The new test still fails on the unfixed code (the chunk's plain text reads `a␣` instead of `a `), and the font-metric evidence in the ticket (U+2423 absent from all four bundled weights) is what establishes the runtime cause. Confirm the fix on a real macOS run.

## Plan Change Log

## Review Triage Log

### 2026-10-04 — Review pass
- verdicts: 37 findings — high 0, medium 2, low 19, false 16, maybe-false 0
- findings:
  - `[false]` `[reject]` blind-hunter: cued space highlight is painted twice (span `backgroundColor` plus painter fill), roughly doubling its alpha — the lesson surface has shipped this exact doubling since ticket 5; only one character is current at a time, the ticket's own AC asks that the active space stay "visually distinguishable", and a stronger tint on the target serves that. No bad outcome established.
  - `[low]` `[reject]` blind-hunter: `height` is a duplicated magic number (1.6 passage / 1.5 lesson) with nothing keeping it in sync with `_charSpan` — real coupling, but the fix is a new constant or a style-reading API, not a direct correction, and a drifted value only mis-centres a glyph.
  - `[low]` `[reject]` blind-hunter: cue collection and key derivation are still duplicated across both surfaces — the plan scoped sharing to the painter; the fix adds a public factory to `SpaceCueText`, which is more than a direct correction.
  - `[false]` `[reject]` blind-hunter: `cueKey: cues.isEmpty ? null : ...` is dead branching — it is not dead. `cues.first` throws `StateError` on an empty list, so the guard is load-bearing at both call sites.
  - `[false]` `[reject]` blind-hunter: the painter force-unwraps `currentContext!` and the cast with no fallback — no reachable null path was shown; the painter runs while painting the `CustomPaint` whose own child holds the key. The window-slide test added this pass exercises the one scenario proposed (element reuse as the window moves) and raises nothing.
  - `[low]` `[reject]` blind-hunter: `shouldRepaint` always returns `true` — the passage rebuilds on every keystroke regardless, so the extra repaints are not additional work; the fix adds field-by-field equality, which is added complexity for no measured cost.
  - `[false]` `[reject]` blind-hunter: `horizontalScale` collapses to 0 when the space box is ≤ 2 px — the box is 0.6 × fontSize, so this needs a font size at or below 3.3. Not reachable from either call site (both default to 22).
  - `[false]` `[reject]` blind-hunter: unkeyed chunk widgets let the per-`State` `GlobalKey` be re-matched to a different chunk — each `_SpaceCueTextState` owns a distinct key attached to the paragraph it builds itself, so a re-matched element simply rebuilds with a new span. The window-slide test added this pass drives exactly this and passes.
  - `[low]` `[reject]` blind-hunter: removing `'␣'` from the span removes the only non-visual signal of a space — the lesson surface already made this trade in ticket 5 and the change restores parity, not a new divergence; the fix adds `Semantics`, which is new public surface.
  - `[low]` `[reject]` blind-hunter: `pendingPixels!` depends on implicit ordering of the state list in the test — inherited verbatim from `test/typing_display_test.dart`; a reorder fails loudly on the next line either way.
  - `[low]` `[reject]` blind-hunter: no coverage for `textScaler` or RTL — the same gap exists in the lesson test this one is modelled on; neither call site varies either input.
  - `[low]` `[reject]` blind-hunter: `SpaceCueText` has no test of its own — it is exercised through both hosts, including the no-cue path, which is the contract that matters.
  - `[low]` `[patch]` blind-hunter: the windowing test hardcodes `greaterThan(1100)` with no tie to `_windowBehind + _windowAhead` — patched: added that comment and raised the passage to 800 words so the two pumped cursors land in non-overlapping windows.
  - `[low]` `[reject]` blind-hunter: Story Sprint verification left no durable guard — ticket AC 3 explicitly permits recorded evidence in notes; adding a screen-level guard is new scope the intent does not require.
  - `[low]` `[reject]` blind-hunter: `image.dispose()` sits on the happy path only — leaks only on a run that is already failing.
  - `[low]` `[reject]` blind-hunter: first test case pumps `cursorPosition: 1` while marking index 0 current — only `_cursorKey` placement depends on it, and nothing asserted depends on `_cursorKey`.
  - `[low]` `[patch]` edge-case: passage `_charSpan` still applies w700/w600 to a space while `TypingDisplay` pins spaces to w500 — no bundled JetBrains Mono weight changes the advance (all 600/1000 em), so nothing shifts today, but it violates the plan's own "advance never depends on state" invariant. Patched: spaces pinned to w500 in both feedback states.
  - `[low]` `[reject]` edge-case: in a chunk with two cued spaces of different states the key names only the first state — keys stay unique per chunk (the ticket-6 crash condition), and nothing in the app looks a cue up by key.
  - `[low]` `[reject]` edge-case: same key-naming point on the lesson surface — same reasoning; changing the scheme would also rewrite the untouched lesson test.
  - `[false]` `[reject]` edge-case: unguarded `findRenderObject()` cast can throw during paint — duplicate of the blind-hunter force-unwrap finding; no reachable path shown.
  - `[false]` `[reject]` edge-case: `box.width <= 2` leaves the cue invisible — duplicate; requires a font size no call site uses.
  - `[false]` `[reject]` edge-case: `cue.width == 0` divides by zero — the division sits behind `cue.width > box.width - 2`, which is false at 0, so `horizontalScale` stays 1.0.
  - `[false]` `[reject]` edge-case: `cueKey` supplied while `cues` is empty silently drops the key — both call sites pass `null` in that case, and no caller looks the widget up when there is no cue.
  - `[false]` `[reject]` edge-case: a space past the end of `charStates` is silently skipped — that is correct. `_charSpan` treats out-of-range as pending, and pending spaces get no cue.
  - `[low]` `[reject]` edge-case: no `Semantics` label replaces the removed glyph — duplicate of the blind-hunter accessibility finding.
  - `[low]` `[patch]` edge-case: the class doc comment still describes the `␣` as a substituted character — patched: it now says the cue is painted over a real space.
  - `[low]` `[patch]` edge-case: claim "spans keep the real `' '` so advance never depends on state" is not fully honoured because the weight still varies — same root cause as the w700/w600 finding; covered by the same patch.
  - `[false]` `[reject]` edge-case: claim "both surfaces keep their own accent colour and highlight alpha" is broken by the doubled fill — duplicate of the double-paint finding; rejected on the same refutation.
  - `[false]` `[reject]` edge-case: claim "byte-for-byte equivalent" is untrue because the paragraph `GlobalKey` moved from per-build to per-`State` — the deviation is disclosed in Implementation Notes and no behavioural difference was found; the untouched lesson test still passes.
  - `[medium]` `[patch]` verification-gap: the chunk-relative cue offset (`i - start`) is only ever exercised where `start == 0`, so replacing it with the absolute index would silently drop every cue outside the first word and keep the suite green — verified by mutation. Patched: added `a cued space outside the first chunk is still painted`, which measures painted pixels inside the second chunk's space; confirmed it fails under that exact mutation and passes after restoring.
  - `[medium]` `[patch]` verification-gap: windowed passages were pumped as a single frame, so the window never slid against the new per-`State` `GlobalKey` — the configuration the 5-minute test actually runs in. Patched: the windowed test now pumps two cursors in non-overlapping windows; both frames cue correctly and throw nothing.
  - `[false]` `[reject]` verification-gap: the passage highlight is now blended twice over a cued space — duplicate of the double-paint finding; rejected on the same refutation.
  - `[low]` `[reject]` intent-alignment: expectations live at the screen surface while the diff's tests exercise the widget — each screen has exactly one call site differing only in `accentColor`, and `test/dutch_story_ui_test.dart` already drives both screens through real keystrokes.
  - `[false]` `[reject]` intent-alignment: 28.0 is a font size no passage surface renders — testing a superset of the shipped size is not a defect; 22.0, the only shipped size, is covered.
  - `[false]` `[reject]` intent-alignment: the Story Sprint probe omitted the `_stumbled` state — `_stumbled` changes only colour and background on that screen; weight and decoration are unchanged, so it cannot alter an advance width.
  - `[false]` `[reject]` intent-alignment: `typing_display.dart` was described as already fixed yet is rewritten here — sharing one cue implementation is the plan's stated approach, and the lesson test is unmodified and passing.
  - `[low]` `[reject]` intent-alignment: positional assertions use a single-line 3-character text, so multi-line and line-break stability are asserted only as "no exception" — the defect is a per-character advance width; proving it at one line proves it at all, and line breaks follow from character widths.

## Design Notes

The shared widget keeps the same shape `TypingDisplay` uses today: build the chunk's `Text.rich` with a fresh `GlobalKey`, and when the chunk has cues return a `CustomPaint(foregroundPainter: ..., child: paragraph)`. The painter resolves the paragraph through that key at paint time, so the overlay never participates in layout — that is the whole point, and it is why the text stops moving.

```dart
SpaceCueText(
  span: TextSpan(children: [for (var i = start; i < end; i++) _charSpan(i)]),
  cues: cues,                       // (offset within the chunk, CharState)
  fontSize: widget.fontSize,
  height: 1.6,
  currentHighlight: widget.accentColor.withValues(alpha: 0.22),
  incorrectHighlight: AppColors.incorrect.withValues(alpha: 0.15),
  cueKey: ValueKey('space-cue-${cues.first.$2.name}-$start'),
)
```

A per-chunk key derived from the chunk start is required: a key derived from state alone collided across chunks and crashed lessons once already (ticket 6). Keep the key unique per chunk.

## Verification

**Commands:**
- `flutter analyze` -- expected: no new issues
- `flutter test test/typing_display_test.dart test/passage_typing_display_test.dart test/dutch_story_ui_test.dart` -- expected: all pass
- `flutter test` -- expected: whole suite passes
- `git stash && flutter test test/passage_typing_display_test.dart` (or equivalent) -- expected: the new test fails without the production change, proving it catches the reported defect; restore afterwards

**Manual checks (if no CLI):**
- Confirm the new test asserts on measured positions/widths and painted pixels, not merely on the absence of the `␣` character in the span text.

## Auto Run Result

Status: `built`

**Change.** `PassageTypingDisplay` no longer swaps a real space for the `␣` glyph. The cue is painted over the real space instead, using the same overlay the lesson prompt has used since ticket 5 — lifted out of `TypingDisplay` into one shared `SpaceCueText` widget so a third surface cannot drift again. Story Sprint was measured and left unchanged.

**Files changed.**
- [../../lib/widgets/space_cue_text.dart](../../lib/widgets/space_cue_text.dart) — new shared cue widget and painter, parameterised by line height and the two highlight colours.
- [../../lib/widgets/typing_display.dart](../../lib/widgets/typing_display.dart) — local painter deleted; builds chunks through `SpaceCueText` with identical colours and widget keys.
- [../../lib/widgets/passage_typing_display.dart](../../lib/widgets/passage_typing_display.dart) — glyph substitution removed, per-chunk cues collected, spaces pinned to one weight, class doc corrected.
- [../../test/passage_typing_display_test.dart](../../test/passage_typing_display_test.dart) — new regression coverage for the I/O matrix plus the two gaps review found.

**Review findings.** 37 findings across four lenses — 0 high, 2 medium, 19 low, 16 false. Five entries patched (2 medium, 3 low); nothing deferred. Every rejection and its reason is recorded row by row in the Review Triage Log above; the recurring ones were the doubled highlight alpha (rejected: parity with the already-shipped lesson surface, and the AC only asks that the active space stay distinguishable), unreachable guard suggestions (rejected: no path shown from either call site), and duplication the plan deliberately scoped out.

**Follow-up review recommended: true.** Patched by verdict: medium 2, low 3. The named unverified risk: both medium patches were coverage gaps around the same new code path — the chunk-relative cue offset and the sliding render window — and the tests added this pass assert each one once, at the widget level. Neither passage screen is driven through a real keystroke loop over a windowed passage anywhere in the suite, so the `GlobalKey`-per-`State` lifetime introduced by `SpaceCueText` is still unexercised under the scroll-and-rebuild behaviour the 5-minute typing test actually produces.

**Verification.**
- `flutter analyze` — no issues.
- `flutter test` — 125/125 pass, including `test/typing_display_test.dart` and `test/dutch_story_ui_test.dart` unmodified.
- Mutation check — replacing the chunk-relative cue offset with the absolute index makes the new second-chunk test fail; restoring it makes it pass.
- Probe (removed): `a b` and `a␣b` render to the same width in the test harness, so the reported shift is not reproducible headlessly; see Implementation Notes.

**Residual risks.**
- The width shift itself is only established by font metrics (U+2423 is absent from all four bundled JetBrains Mono weights) and cannot be asserted in a widget test, because the headless harness has no system fallback chain. Confirm on a real macOS run.
- Story Sprint's "already correct" status rests on a one-time measurement recorded in Implementation Notes, with no standing test.

