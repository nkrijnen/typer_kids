---
title: 'Add the complete Dutch no-fallback audit'
type: 'feature'
ticket: '3'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '4a12747c3f9766bf4ec7eb7f39e2cba7300660f0'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Individual route tests prove localized features, but no single automated audit fails on known English labels leaking into Dutch-reachable production routes.

**Approach:** Add an exact-label English inventory with a self-test proving injection detection, then walk the Dutch production route setup inventory and audit rendered text without broad dictionary matching or false positives.

</frozen-after-approval>

## Implementation Notes

Create `dutch_no_fallback_audit_test.dart`. Extract visible Text/RichText values after routing through Home, Lessons, Games and all game setups, Sandbox, Typing Test, Settings, and representative lesson setup. Compare exact normalized labels against a curated known-English UI inventory. Keep `WPM`, English story attribution/content, keyboard symbols, and English-only Tricky Keys out of the inventory by documented intent. Existing per-feature tests own play/results/dialog states; the full suite composes those with this route audit.

## Plan Change Log

## Review Triage Log

- `medium` / patch: added payload-dependent lesson results route and known English result labels to audit.
- `false`: profiles are covered by the separate no-active-profile route test.
- `false`: WPM is an explicit accepted bilingual abbreviation; injection self-test verifies it remains ignored while `Settings` fails.
- `false`: English lesson unlock behavior is intentionally distinct from the sequential Dutch curriculum.
- `low` / retained: curated exact inventory avoids dictionary false positives; full feature tests compose play/results/dialog states with route setup audit.

## Verification

**Commands:**
- `flutter test test/dutch_no_fallback_audit_test.dart` -- passed: 3 tests
- `flutter test` -- passed: 106 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload -- passed
