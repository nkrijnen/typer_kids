---
title: 'Refactor sweep for complete Dutch parity'
type: 'refactor'
ticket: '4'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '779326ecf973ab0ad9d8f8274722a62fad7c773f'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The completed initiative repeats the same progress-state reload sequence across initialization, profile switching, and language switching, creating cross-capability maintenance risk.

**Approach:** Extract one private ProgressProvider reload helper without changing persistence keys, migration order, notification timing, or public APIs; retain approved WPM terminology and broad test-fixture patterns with explicit reasons.

</frozen-after-approval>

## Implementation Notes

`_reloadProgress` owns clearing state, loading current prefix data, running Dutch legacy migration, and restoring last lesson. `init`, `switchProfile`, and `switchLanguage` continue setting their identity fields and notifying at the same points. WPM is an accepted bilingual abbreviation. A shared helper migration across 179 test setups is disproportionate infrastructure churn outside this initiative.

## Plan Change Log

## Review Triage Log

- Quick review: no findings; reload ordering, migration, last lesson, isLoaded, notification timing, prefixes, and public API behavior are preserved.
- WPM and broad test-fixture patterns retained for documented scope reasons.

## Verification

**Commands:**
- focused persistence integration -- passed: 12 tests
- `flutter test` -- passed: 106 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload -- passed
