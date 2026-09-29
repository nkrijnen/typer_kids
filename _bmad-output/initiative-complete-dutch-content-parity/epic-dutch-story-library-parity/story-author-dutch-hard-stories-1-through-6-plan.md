---
title: 'Author Dutch hard stories 1 through 6'
type: 'feature'
ticket: '8'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: 'fe2e09cdc61952e0bd4f0bbf5f61a5842cb5c73d'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch hard story lane is empty and needs its first six original passages with a clear increase in structural and punctuation complexity.

**Approach:** Add six original Netherlands-Dutch passages with longer sentence structures, richer vocabulary, collectively broad supported punctuation, distinct age-appropriate topics, hard metadata, accepted characters, and exact Typer Kids provenance; add focused hard-tier data checks.

</frozen-after-approval>

## Implementation Notes

Author climate research, windmill restoration, underwater discovery, school mystery, original music, and emergency exercise passages in `dutch_story_hard.dart`. Across the batch cover commas, semicolons, colons, apostrophes, parentheses, questions, and exclamations. Validate exact count, uniqueness, provenance, hard metadata, non-empty prose, accepted characters, punctuation coverage, random containment, and no easy/medium leakage.

## Plan Change Log

## Review Triage Log

- `false`: reviewer suggested lowercasing `'s Avonds`; at the beginning of a Dutch sentence the first full word is correctly capitalized (`'s Avonds`), while lowercase is used mid-sentence.
- Reviewer verified all six passages for hard-tier structure, grammar, age fit, originality, distinct topics, metadata, accepted characters, punctuation breadth, uniqueness, tier isolation, and test completeness with no other findings.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart test/features_test.dart` -- passed: 38 tests
- `flutter test` -- passed: 100 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
