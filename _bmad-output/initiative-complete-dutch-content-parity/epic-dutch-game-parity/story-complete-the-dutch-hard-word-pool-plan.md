---
title: 'Complete the Dutch hard word pool'
type: 'feature'
ticket: '3'
created: '2026-09-29'
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
baseline_revision: 'c159083'
---

<intent-contract>

## Intent

**Problem:** `WordLists.dutchHard` has only 12 words; DG-1 requires exactly 279 unique, lowercase, keyboard-typeable hard Dutch words matching the English hard pool's size, with the existing Dutch word-game test constraining hard-tier words to length >= 7.

**Approach:** Expand `WordLists.dutchHard` to exactly 279 unique real, child-appropriate, natural Netherlands-Dutch words and valid compounds of 7+ lowercase letters (a-z only), covering house/rooms, nature, food, school, toys, family, verbs, adjectives, and calendar vocabulary (weekdays/months). Add a focused test asserting the exact count, uniqueness, character set, and length constraint. English pools are untouched.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): pure content addition to one `const` list plus one new test. Words were compiled across semantic categories (heavy use of authentic Dutch compounding), then mechanically verified offline (Python script) for exact count (279), uniqueness, lowercase a-z-only characters, and length >= 7 before being written into Dart. A dedicated review pass checked all 279 words for authenticity and age-appropriateness and found no issues. No production logic changed.

## Verification

**Commands:**
- `flutter test test/dutch_word_game_test.dart` -- expected: pass, including the new 279-count assertion
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 0 findings — high 0, medium 0, low 0, false 0, maybe-false 0
- findings: none. A dedicated content-quality reviewer checked all 279 words for spelling/authenticity, duplicates, and age-appropriateness and reported zero problems.
