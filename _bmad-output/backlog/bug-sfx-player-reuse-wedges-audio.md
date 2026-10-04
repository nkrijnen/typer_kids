---
id: 8
type: bug
title: "Sound effects wedge the audio players and stall the app after extended play"
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

# Sound effects wedge the audio players and stall the app after extended play

## Description

Logged in hindsight: the defect was reported from a running macOS build and
corrected in the same session, before a ticket existed. This records it so the
cause, the correction, and its regression coverage are traceable.

After playing for a while on macOS, the app logged repeated
`SWIFT TASK CONTINUATION MISUSE: setUpPlayerItemStatusObservation(_:) leaked its
continuation without resuming it`, and the user reported that some buttons
stopped responding while keyboard input sometimes still worked.

## Reproduction

1. Run the app on macOS (`flutter run -d macos`) with sound enabled.
2. Play through lessons or a game so sound effects fire in quick succession,
   especially the keystroke click during fast typing.
3. Watch the macOS app log.
4. Actual: `SWIFT TASK CONTINUATION MISUSE` appears for
   `setUpPlayerItemStatusObservation` and repeats as play continues; after a
   while some on-screen buttons stop responding. Expected: no continuation
   warnings, and the UI stays responsive for the whole session.

## Cause

`SoundManager._play` called `AudioPlayer.play(AssetSource(...))` on a player
drawn from a shared pool of six. `play` re-runs `setSourceUrl` every time, and
in `audioplayers_darwin`'s `WrappedMediaPlayer` that begins with `reset()`,
which invalidates `playerItemStatusObservation`.

`setUpPlayerItemStatusObservation` suspends on
`withCheckedThrowingContinuation` and is resumed only from the `AVPlayerItem.status`
KVO callback, on `.readyToPlay` or `.failed`. A second `play` landing on the
same player before the first reaches either state destroys the observation with
the continuation unresumed — the reported warning — and the native call never
replies, so the Dart future never completes.

The pool then made it self-reinforcing: `_getPlayer` selected any player whose
state was not `playing`, and a player stuck mid-load never reaches `playing`, so
the same wedged players were handed out repeatedly, each reuse leaking another
continuation and churning `replaceCurrentItem` on the main actor.

A restored copy of the pre-fix `_play` reproduces the precondition directly:
three concurrent plays of one sound issue three `setSourceUrl` calls against a
single player id.

## Resolution

`lib/core/sound_manager.dart` now keeps a small set of preloaded players per
sound. `setSource` runs exactly once per player, cached behind a shared future
so concurrent first plays load once. Replay is `setVolume` then `stop` then
`resume`, which never re-enters `setSourceUrl`, so no continuation can be
leaked. A failed load evicts only that sound and is retried on the next play,
rather than latching the global `_audioAvailable` flag off for the session.

## Acceptance Criteria

1. **A sound's source is set once per player**
   **Given** a sound effect that has already been played
   **When** it is played again any number of times
   **Then** no further `setSourceUrl` call is issued for that player.
2. **Concurrent first plays load a sound once**
   **Given** a sound that has never been played
   **When** several plays of it are started in the same frame
   **Then** the sound is loaded once and its players are reused.
3. **One sound's load failure does not silence the rest**
   **Given** a sound whose asset fails to load
   **When** other sounds are played afterwards
   **Then** they still play, and the failed sound is retried on its next play.
4. **Tests cover the condition found and fixed**
   **Given** the sound manager tests
   **When** they run
   **Then** a regression check that fails on the pooled `play(AssetSource(...))`
   implementation and passes on the correction asserts the call pattern above.

## References

- parent — none
- `lib/core/sound_manager.dart` — the pooled player reuse that caused it
- `test/sound_manager_test.dart` — regression coverage
- audioplayers_darwin `WrappedMediaPlayer.setUpPlayerItemStatusObservation` —
  the upstream continuation that leaks

## Notes

- Verified: the continuation leak and its precondition. Four of the five tests
  in `test/sound_manager_test.dart` fail against the restored pre-fix
  implementation and pass against the correction; full suite is 118 passing and
  focused `flutter analyze` is clean.
- Unverified: the causal link from the leaked continuations to the unresponsive
  buttons. It is plausible — repeated `replaceCurrentItem` against a `@MainActor`
  player stalls the main actor — but it was not reproduced or measured, and no
  test covers it. If buttons still stop responding after this change, the UI
  cause is separate and needs its own ticket.
- `audioplayers` is pinned `^6.4.0`, which floats. The workaround is load-bearing
  against plugin behavior that an upgrade could change in either direction; the
  regression test is what guards it.
- Resource trade: 2 players per sound across 8 assets, so up to 16 native players
  held for the app's lifetime versus the previous 6. The clips are short WAVs.
- `audioplayers_platform_interface` was added as a dev dependency so the test can
  substitute a fake platform.
