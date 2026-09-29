---
title: 'Complete Dutch story practice and typing-test UI'
type: 'feature'
ticket: '11'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '44346a27c8003ebf5b8415e535ee1e55b3c976b8'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Free Practice is mostly Dutch-aware, but Typing Test remains blocked by the router and hardcoded English, preventing Dutch learners from using the complete 18/18/18 library across both story surfaces.

**Approach:** Remove the stale Dutch Typing Test redirect, localize all setup/play/quit/result strings and labels using the established LanguageProvider pattern, preserve language-aware story selection and English behavior, and add routed Dutch tests across all three tiers.

</frozen-after-approval>

## Implementation Notes

Keep calculations, timers, and content selection unchanged. Localize only presentation and route access. Reuse DifficultyCard's existing language behavior and localize Typing Test view strings at their owning widgets. Add focused route/UI tests rather than duplicating long character-by-character completion for every tier; existing sandbox completion and typing-stat tests remain regression owners.

## Plan Change Log

## Review Triage Log

- `medium` / patch: localized remaining Sandbox `Choose Difficulty` and `Surprise me!` strings and updated walkthroughs.
- `false`: `WPM` is the standard Dutch abbreviation and does not require translation.
- `false`: Sandbox `Totaal` and Typing Test `Totaal tekens` are clear in their different stat contexts.
- Reviewer found no route, semantics, calculation, or test false-positive issues.

## Verification

**Commands:**
- focused Dutch Sandbox and Typing Test widget tests -- passed: 3 tests
- `flutter test` -- passed: 101 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed
