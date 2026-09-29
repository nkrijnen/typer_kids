---
title: 'Localize every remaining Dutch production route'
type: 'feature'
ticket: '2'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '9ed128a368f74a35d9f8f64ea99f5937ea987a0b'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** A complete production-route audit found one remaining English label in Dutch Settings: the language selector displays `English` instead of `Engels`.

**Approach:** Localize both language names according to the active UI language and add a routed Dutch/English settings regression while preserving all route access and existing behavior.

</frozen-after-approval>

## Implementation Notes

Change only the two segmented-control labels in Settings. Add a focused widget test that opens `/settings` in Dutch and English and verifies `Engels`/`Nederlands` versus `English`/`Dutch`. The audit found no other route, dialog, tooltip, semantics, badge, or progress-copy gaps.

## Plan Change Log

## Review Triage Log

- `high` / patch: localized Typing Test was routable but hidden from Dutch Home and its `T` shortcut; exposed/localized the card and enabled the shortcut with focused coverage.
- Initial route audit found and patched Settings `English` -> `Engels`; no other visible route strings remained.

## Verification

**Commands:**
- focused Settings/Home/shortcut tests -- passed
- `flutter test` -- passed: 103 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload -- passed
