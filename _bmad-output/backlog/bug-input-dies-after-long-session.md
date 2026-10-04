---
id: 10
type: bug
title: "Buttons and keys stop responding after a long session"
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

# Buttons and keys stop responding after a long session

## Description

After using the app for a while on macOS, some on-screen buttons stop reacting
to clicks. Keyboard input sometimes still works at that point and sometimes does
not. The app does not crash and shows no error.

This was reported alongside the audio continuation leak (bug 8) and initially
assumed to share its cause. That link was never demonstrated. Bug 8 is fixed and
proven by test; this symptom is unreproduced and its cause is unknown, so it is
tracked separately rather than being treated as closed by that fix.

## Reproduction

Not yet reproduced on demand. Observed conditions:

1. Run the app on macOS (`flutter run -d macos`).
2. Use it for an extended session across lessons and games, which involves
   repeated navigation and many focus changes between `KeyboardListener` nodes.
3. Eventually some buttons stop responding to clicks, while key input is
   intermittently still handled.

Unknown: how long it takes, whether a specific screen or transition triggers it,
whether it survives navigating away and back, and whether it occurs on Windows,
Linux or web.

## Cause Hypotheses

Untested, roughly in order of suspicion:

1. **Stale or trapped focus.** Every screen owns two or three `FocusNode`s
   feeding a `KeyboardListener`, with `requestFocus()` called on transitions.
   A node that keeps primary focus after its screen is gone, or a focus scope
   that is never restored, would explain keys working while buttons do not.
2. **A route or barrier that never popped.** A dialog or modal route left on the
   stack puts an invisible barrier over the page, which absorbs clicks while
   keyboard handlers further up may still fire.
3. **An overlay widget intercepting hit tests**, for example a confetti or
   celebration layer that outlives its animation without an `IgnorePointer`.
4. **A stalled UI thread.** Would match buttons dying, but not keys continuing
   to work, so this ranks last. It is also the hypothesis the bug 8 fix would
   have addressed, and the symptom should be re-checked now that it has landed.

## Diagnostics Added

`lib/core/diagnostics.dart` instruments the app so a recurrence is
self-reporting. On in debug builds, or with
`--dart-define=typer_diagnostics=true`. Every five seconds it emits:

```
[diag] alive 120s frames=38 worst=18ms taps=57(2s ago) keys=310(0s ago) errors=0 routes=2/TypingScreen focus=FocusNode#a1b2c
```

Reading it when the symptom appears:

- **Heartbeat stops entirely** — the UI thread is wedged. Hypothesis 4.
- **Heartbeat continues and `taps` keeps climbing** — pointer events arrive and
  something swallows them. Compare `routes` against the screen actually on
  display: a depth that only grows is hypothesis 2.
- **`focus` names a node that is not the visible screen's**, or is marked
  `detached` or `!canRequest` — hypothesis 1.
- **`keys` climbing while nothing happens** — the engine delivers keys but no
  `KeyboardListener` handles them, which is also hypothesis 1.
- **`errors` above zero** — an exception was thrown and swallowed; the preceding
  `[diag] FlutterError:` line names it.
- **`slow frame` lines** — main-thread stalls, with build and raster split out.

## Acceptance Criteria

1. **The failure is reproduced and its cause named**
   **Given** the diagnostics above
   **When** the symptom recurs
   **Then** the captured log identifies which hypothesis holds, recorded in
   Notes, and the reproduction steps are narrowed to something repeatable.
2. **Input keeps working for a full session**
   **Given** the identified cause is corrected
   **When** the app is used across lessons, games and navigation for a session
   as long as the one that triggered the report
   **Then** every on-screen button and key continues to respond.
3. **Tests cover the condition found and fixed**
   **Given** the cause is known
   **When** the tests run
   **Then** a regression check that fails on the reported behavior and passes on
   the correction covers it, at whatever level the cause sits.
4. **Or: the bug 8 fix already resolved it, with proof**
   **Given** an extended session on the current code
   **When** it is run with diagnostics on
   **Then** input keeps working and the log shows no stall, recorded in Notes;
   this supersedes criteria 1 through 3.

## References

- parent — none
- bug 8 — `bug-sfx-player-reuse-wedges-audio.md`, reported together, fixed, and
  not proven to be the cause of this symptom
- `lib/core/diagnostics.dart` — the instrumentation described above

## Notes

- No test covers this; none can until the cause is known.
- Criterion 4 is the cheapest next step: run a long session on the current build
  with diagnostics on and see whether it still happens at all.
- The diagnostics deliberately skip installation under a test binding, because
  overriding `FlutterError.onError` hides test framework failures and a periodic
  timer fails the "timer still pending" invariant.
- Severity: the app keeps running and a restart clears it, but a child who
  cannot press a button is stuck, and the failure is silent.
