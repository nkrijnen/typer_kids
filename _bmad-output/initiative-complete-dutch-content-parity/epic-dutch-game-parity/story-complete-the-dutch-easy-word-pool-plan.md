---
title: 'Complete the Dutch easy word pool'
type: 'feature'
ticket: '1'
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
baseline_revision: 'd33cccd'
---

<intent-contract>

## Intent

**Problem:** `WordLists.dutchEasy` has only 24 words; DG-1 requires exactly 302 unique, lowercase, keyboard-typeable easy Dutch words (matching the English easy pool's size), and the existing Dutch word-game test already constrains easy-tier words to length <= 3.

**Approach:** Expand `WordLists.dutchEasy` to exactly 302 unique real, child-appropriate, natural Netherlands-Dutch words of 1-3 lowercase letters (a-z only, no accents), covering common nouns, verbs, adjectives, pronouns, and function words. Add a focused test asserting the exact count, uniqueness, character set, and length constraint. English pools are untouched.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): pure content addition to one `const` list plus one new test. Words were hand-compiled and mechanically verified offline (Python script) for exact count (302), uniqueness, lowercase a-z-only characters, and length <= 3 before being written into Dart. No production logic changed.

## Verification

**Commands:**
- `flutter test test/dutch_word_game_test.dart` -- expected: pass, including the new 302-count assertion
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 1 finding — high 0, medium 1, low 0, false 0, maybe-false 0
- findings:
  - `[medium]` `[patch]` `wip` (seesaw) also has common colloquial slang meaning ("een wipje") unsuitable for a children's word pool — swapped for `wij` (we), a safe, common Dutch pronoun not already in the list; count and uniqueness re-verified at exactly 302.

