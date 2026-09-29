---
title: 'Verify the complete Dutch story library'
type: 'feature'
ticket: '13'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: 'ab2e25c7f032cb2a2c3619d15cd397fe6a23ad1e'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The 54-passage library and localized surfaces need one closing integration tracer proving complete data coverage and successful Dutch use at every difficulty without fallback.

**Approach:** Add aggregate validation over every Dutch passage and widget completion coverage for easy, medium, and hard in Free Practice and Typing Test, while relying on existing English route/statistics regressions for parity.

</frozen-after-approval>

## Implementation Notes

Extend the dedicated story UI integration test. Verify the union contains exactly 54 unique passages with correct tier metadata. For each difficulty, complete an explicitly selected passage in Sandbox and start/finish a short Typing Test using content from the matching pool. Keep existing English list/random/stat tests as the equivalent English proof.

## Plan Change Log

## Review Triage Log

- `medium` / patch: added English all-tier Typing Test selection/results statistics and Sandbox route/UI regression coverage.
- `false`: Sandbox intentionally selects a known passage for deterministic completion; random selection is separately covered by 30 attempts per tier.
- `false`: 30 one-second timer pumps are proven by result-state assertions after each test.
- `false`: ticket requires sampling every passage and completing each difficulty, not completing all 54 passages through both UIs; aggregate tests validate every passage and UI tests complete each tier.

## Verification

**Commands:**
- `flutter test test/dutch_story_ui_test.dart` -- passed: 4 tests
- `flutter test` -- passed: 102 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload -- passed
