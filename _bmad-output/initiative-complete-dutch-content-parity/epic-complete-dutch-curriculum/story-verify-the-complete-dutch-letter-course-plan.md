---
title: 'Verify the complete Dutch letter course'
type: 'feature'
ticket: '7'
created: '2026-09-28'
status: done
route: 'oneshot'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
baseline_revision: '8fb6de7'
---

<intent-contract>

## Intent

**Problem:** No single test proves the end-to-end Dutch letter-course tracer: a learner migrating from the old vertical-slice lessons, completing every remaining stage through Y, surviving a restart, and having profile/language switches return the correct Dutch recommendation — all without disturbing English progress.

**Approach:** Add a focused integration test (provider-level, no widget pump) that: seeds legacy `nl-home-*` completion, initializes `ProgressProvider` for Dutch (triggering migration), completes every one of the 16 `nl-letter-*` lessons via `recordAttempt`, re-initializes a fresh `ProgressProvider` (simulating restart), asserts `recommendedLesson` after full completion, switches to a second profile and to English and back, and asserts English progress recorded before/after is untouched.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): new test file using the same `SharedPreferences.setMockInitialValues` / `ProgressProvider` pattern as `test/dutch_lesson_migration_test.dart` and `test/features_test.dart`. No production code changes expected; only add the missing closing test.

## Verification

**Commands:**
- `flutter test test/dutch_letter_course_integration_test.dart` -- expected: pass
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues
