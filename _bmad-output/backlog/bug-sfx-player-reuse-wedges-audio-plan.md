---
title: 'Stop reusing in-flight audio players for sound effects'
type: 'bugfix'
ticket: '8'
created: '2026-10-04'
status: done
route: 'oneshot'
route_source: 'auto'
baseline_revision: '6950ae8bde4140ac9444873feee7c17521f193ea'
review: 'quick'
review_source: 'auto'
lenses_ran: ['quick']
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: ['Ticket written in hindsight: the fix landed before the ticket existed.']
deferred: ['Unresponsive-button symptom is unconfirmed and needs its own ticket if it recurs.']
---

<intent-contract>

## Intent

**Problem:** `SoundManager` replayed sounds via `AudioPlayer.play(AssetSource(...))`
on a shared pool, re-entering `setSourceUrl` on players that were still loading.
On macOS that destroys the pending `AVPlayerItem.status` observation and leaks
the Swift continuation, permanently wedging the player.

**Approach:** Preload a small set of players per sound so the source is set once
per player, and replay with stop/resume so `setSourceUrl` is never re-entered.
Cover the call pattern with tests against a fake audio platform.

</intent-contract>

## Implementation Notes

`lib/core/sound_manager.dart` replaced the six-player pool and its
`p.state != PlayerState.playing` selection with a per-asset map of preloaded
players, cached behind a shared `Future` so concurrent first plays load once.
Replay is `setVolume` then `stop` then `resume`.

A first pass left a dead error path: the inner `catch` evicted a failed load and
rethrew, but the outer `catch` latched `_audioAvailable = false`, so the eviction
could never be retried and one bad asset silenced the whole app. Corrected to
evict and return for load failures, keeping the global latch for playback errors
only. `dispose` now also resets `_audioAvailable`, which test isolation needs.

`test/sound_manager_test.dart` is new and substitutes a fake
`AudioplayersPlatformInterface`, with `plugins.flutter.io/path_provider` mocked
because `AssetSource` copies the asset to a temp directory. This required adding
`audioplayers_platform_interface` to dev dependencies.

## Plan Change Log

- Ticket authored after the fix, at the user's request, to log the defect.

## Review Triage Log

### 2026-10-04 - Review pass
- verdicts: 2 findings -- high 0, medium 1, low 1, false 0, maybe-false 0
- findings:
  - medium: dead eviction path meant a single asset load failure latched all
    audio off for the session; fixed.
  - low: `dispose` did not restore `_audioAvailable`, leaving state sticky;
    fixed.

## Verification

**Commands:**
- `flutter test test/sound_manager_test.dart` -- expected: a sound's source is
  set once per player and replays issue only resume.
- `flutter test` -- expected: whole suite passes.
- `flutter analyze lib/core/sound_manager.dart test/sound_manager_test.dart` --
  expected: no new diagnostics.

## Auto Run Result

- Fixed sound effect playback wedging its native players by preloading a set of
  players per sound instead of re-setting the source on a shared pool.
- `lib/core/sound_manager.dart`: per-asset preloaded players, stop/resume
  replay, per-asset load failure handling.
- `test/sound_manager_test.dart`: new regression coverage over the platform call
  pattern.
- `pubspec.yaml`: added `audioplayers_platform_interface` dev dependency.
- Review: 2 findings, both patched (high 0, medium 1, low 1); zero deferred code
  changes. Follow-up review not recommended.
- Verification: restoring the pre-fix `_play` fails four of the five new tests
  and shows three `setSourceUrl` calls against one player id, which is the leak
  precondition; the correction passes all five, the full suite is 118 passing,
  and focused `flutter analyze` is clean.
- Residual risk: the unresponsive-button symptom was never reproduced, so the
  causal link to the leaked continuations is unproven and untested. The
  `audioplayers` constraint `^6.4.0` floats, so an upgrade could change the
  plugin behavior this works around; the new tests are the guard.
