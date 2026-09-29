---
title: 'Complete the Dutch medium word pool'
type: 'feature'
ticket: '2'
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
baseline_revision: '18baea5'
---

<intent-contract>

## Intent

**Problem:** `WordLists.dutchMedium` has only 18 words; DG-1 requires exactly 309 unique, lowercase, keyboard-typeable medium Dutch words matching the English medium pool's size, with the existing Dutch word-game test constraining medium-tier words to length 4-6.

**Approach:** Expand `WordLists.dutchMedium` to exactly 309 unique real, child-appropriate, natural Netherlands-Dutch words of 4-6 lowercase letters (a-z only), covering animals, food, house/objects, clothing, nature, body, school, sports, family, verbs, and adjectives. Add a focused test asserting the exact count, uniqueness, character set, and length constraint. English pools are untouched.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): pure content addition to one `const` list plus one new test. Words were compiled across semantic categories, then mechanically verified offline (Python script) for exact count (309), uniqueness, lowercase a-z-only characters, and length 4-6 before being written into Dart. Foreign loanwords and more obscure/rare entries were trimmed in favor of common, natural Netherlands Dutch vocabulary appropriate for ages 10-12. No production logic changed.

## Verification

**Commands:**
- `flutter test test/dutch_word_game_test.dart` -- expected: pass, including the new 309-count assertion
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 2 findings — high 0, medium 2, low 0, false 0, maybe-false 0
- findings:
  - `[medium]` `[patch]` `speel` is only a verb stem/imperative, not a standalone noun, out of place among concrete nouns — replaced with `cadeau` (gift); count and uniqueness re-verified at exactly 309.
  - `[medium]` `[patch]` `poes` (kitten) has a common vulgar slang secondary meaning in adult Dutch — swapped for `kater` (tomcat), a safe, unambiguous alternative not already in the list.

