---
title: 'Verify the complete Dutch product'
type: 'feature'
ticket: '5'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: 'cdaab7099ef24e7349db488633334f9323b24680'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The initiative needs one final executable product contract and responsive route smoke test tying together the completed curriculum, games, stories, persistence, localization, fallback audit, and English regressions.

**Approach:** Add a closing test asserting all exact Dutch content totals and smoke every top-level Dutch workflow at phone and desktop sizes, then run the full specialized suite, analyzer, connected hot restart, runtime check, and independent final review.

</frozen-after-approval>

## Implementation Notes

The closing test complements rather than duplicates focused integration tests: data contract asserts 16 lessons, 302/309/279 words, 20/20/20 game sentences, and 18/18/18 passages; responsive smoke verifies Dutch Home and top-level Lessons, Games, Free Practice, Typing Test, and Settings routes render without exceptions at 390x844 and 1440x900. Existing tests own complete lesson progression, all games/difficulties, passage completion, persistence, English parity, and no-fallback inventory.

## Plan Change Log

## Review Triage Log

- Final independent review: no findings; all content totals, routes, persistence combinations, no-fallback checks, English regressions, and responsive requirements verified.

## Verification

**Commands:**
- `flutter test test/dutch_complete_product_integration_test.dart` -- passed: 2 tests
- `flutter test` -- passed: 108 tests
- `flutter analyze` -- passed: no issues found
- connected Flutter hot restart -- passed; no runtime errors were reported before the device connection closed
