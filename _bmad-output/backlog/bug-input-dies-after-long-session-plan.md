---
title: 'Buttons and keys stop responding after a long session'
type: 'bugfix'
ticket: '10'
created: '2026-10-05'
status: 'draft'
route: 'full'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent - do not modify unless human renegotiates">

## Intent

**Problem:** After extended macOS use, some buttons stop reacting and keys may stop too; no crash or error has been captured. The sound player defect in bug 8 was fixed, but its connection to this symptom was never established.

**Approach:** First attempt a measured reproduction on current code, recording diagnostic heartbeat and visible UI state. Fix only the demonstrated failure mode, with a regression check that fails before the fix; if the symptom does not recur, report that limit rather than claiming it is resolved.

## Boundaries & Constraints

**Always:** Keep bug 10's acceptance criteria and the original diagnostics in view; capture the macOS build revision, duration, transitions, button/key probes, and timestamped heartbeat when evaluating any failure. Compare with the original reported session length before invoking the bug 8 no-change acceptance route.

**Never:** Treat a stale focus, stuck route, overlay, or stalled UI thread as proven without evidence. Do not change unrelated games, input flows, sound playback, or other backlog tickets just to make this report appear fixed.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|---------------|----------------------------|----------------|
| Healthy session | Navigate among lessons, games and home, click controls and type with sound on | Buttons and keys keep changing state; heartbeats continue | Record duration and sample heartbeat; absence of failure alone is not a root-cause fix |
| Failure recurs | Record screen, last action, failed click/key, and adjacent heartbeats | Tap/key deltas, route depth/top, focus and frame timing discriminate delivery, interception, focus, and stall | If heartbeat ceases, note last timestamp and app responsiveness before restart |
| No reproduction | Run ends without failed controls | Do not assert criteria 1-3 or 4 without comparable original duration | Record an honest blocked or inconclusive result and the missing reproduction conditions |

</frozen-after-approval>

## Code Map

- `lib/main.dart` -- installs diagnostics and wraps the app in the pointer-counting listener; keep in place for the measured run.
- `lib/core/diagnostics.dart` -- five-second heartbeat counts taps, keys, frames, errors, route depth and current focus; distinguish delivered events from handled actions.
- `lib/core/router/app_router.dart` -- registers the route observer on the GoRouter root navigator; home links push lessons, games and practice views.
- `lib/screens/typing_screen.dart` -- one representative KeyboardListener and non-dismissible quit dialog; inspect only if failure points here.
- `test/widget_test.dart` -- existing TyperKidsApp pump, navigation, focus and key-event checks; reuse only once a cause can be asserted.
- `_bmad-output/backlog/bug-input-dies-after-long-session.md` -- acceptance criteria and Notes; record observed reproduction and limits there only after approval to update ticket evidence.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/main.dart`, `lib/core/diagnostics.dart`, `lib/core/router/app_router.dart` -- run the existing debug macOS build and capture `[diag]` output while cycling home -> lesson intro -> typing -> quit/stay -> home -> games -> game setup/play/quit -> home, probing both clicks and keys each cycle; do not change code for this step.
- [ ] `_bmad-output/backlog/bug-input-dies-after-long-session.md` -- record revision, session duration, screen/transition, first failed button and key, last working action, heartbeat excerpts, and resulting hypothesis or explicit non-reproduction.
- [ ] `test/widget_test.dart` (or the closest existing focused test file for the observed path) -- add a regression check that fails for the captured condition, then change only its demonstrated owner (for example `lib/screens/typing_screen.dart` if that screen's focus/dialog is implicated). Do not implement this conditional task without a reproducer.
- [ ] `_bmad-output/backlog/bug-input-dies-after-long-session.md` -- record focused test, macOS rerun and whether the original acceptance criteria were met; if not, keep the ticket unfinished.

**Acceptance Criteria:**
- Given a captured failure on the current revision, when the diagnostics and UI state are compared, then the cause and repeatable trigger are recorded before any code fix.
- Given the identified cause and failing regression check, when the smallest correction is applied, then the check passes and clicks and keys continue working in a comparable macOS session.
- Given no failure in a session at least as long as the original, when heartbeat and input probes remain healthy throughout, then record evidence for criterion 4, without claiming a separately identified cause.
- Given no reproducible failure and no comparable duration, when the investigation ends, then record the blocker and do not mark the ticket fixed.

## Implementation Notes

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `flutter test test/widget_test.dart` -- expected: focused regression passes after demonstrating pre-fix failure, if a cause was reproduced.
- `flutter analyze` -- expected: no new diagnostics after any source change.
- `flutter run -d macos` -- expected: `[diag]` heartbeat every five seconds and responsive controls during a comparable manual session; save the log and note any missing heartbeat.

## Open Questions

1. What was the original failed session's approximate duration and last screen/transition? **Provide the original details** to define a comparable run and a targeted circuit; or **authorize a time-boxed exploratory run** (proposed: 60 minutes across lessons and games) with the explicit outcome that a clean run shorter than the original cannot establish criterion 4. Without one of these, the no-reproduction result is inconclusive and the fix remains blocked.