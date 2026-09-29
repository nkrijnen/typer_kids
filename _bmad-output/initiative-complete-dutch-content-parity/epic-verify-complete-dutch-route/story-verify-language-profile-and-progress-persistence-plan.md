---
title: 'Verify language, profile, and progress persistence'
type: 'feature'
ticket: '1'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '485dfe50e51d3c522121e22d0dc938659ce5029c'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Completed Dutch content has persistence coverage for language, migration, lesson progress, and language-scoped scores, but lacks a combined game-score profile-switch plus restart proof.

**Approach:** Add the missing two-profile/two-language/all-six-score restart matrix and use the existing migration, lesson completion, story-stat calculation, and language restart tests as the complete persistence suite.

</frozen-after-approval>

## Implementation Notes

Add one focused provider integration test to `dutch_games_integration_test.dart`: record Dutch scores for profile A, switch to profile B and English, record distinct scores, recreate the provider, and recover each profile/language map without leakage. Story WPM/accuracy are session calculations rather than persisted state; existing completion widget tests verify those calculations and no unsupported persistence mechanism is introduced.

## Plan Change Log

## Review Triage Log

- Quick review: no findings; all four profile/language score combinations survive restart and existing migration, lesson, and transient story-stat coverage validly completes scope.

## Verification

**Commands:**
- focused score integration -- passed: 3 tests
- `flutter test` -- passed: 103 tests
- `flutter analyze` -- passed: no issues found
