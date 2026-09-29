---
title: 'Author Dutch easy stories 2 through 6'
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
baseline_revision: 'bcd5c5b8f7c398e894d23ad55b1c8ee4196e72ab'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch easy story library contains only the retained passage, leaving it five stories short of the first six-passage authoring milestone.

**Approach:** Add five original Netherlands-Dutch passages with distinct child-friendly topics, short common sentences, easy metadata, accepted keyboard characters, and exact Typer Kids provenance; strengthen focused data checks for the six-story pool and tier isolation.

</frozen-after-approval>

## Implementation Notes

Author directly in `dutch_story_easy.dart` so later easy batches can extend the same lane without touching medium or hard. Match the retained passage's approachable length and sentence shape; avoid translated plots, copyrighted characters, diacritics, and vocabulary that raises the difficulty tier. Extend `dutch_story_library_test.dart` with exact count, unique title/text, source, difficulty, non-empty prose, accepted-character, and no-leak assertions.

## Plan Change Log

## Review Triage Log

- `false`: reviewer claimed `De tuin op school` was 9 sentences versus 4 retained; the texts contain 8 and 7 sentences respectively and have comparable easy-tier typing length.
- `low` / rejected: a comment explaining 30 random-selection attempts would add narration without changing the containment assertion.
- `false`: both retained-story dropdown selections execute successfully in focused and full tests; `.last` targets the selectable overlay entry after the menu opens, and completion proves the intended passage was selected.
- Content review found all five passages natural Netherlands Dutch, original, age-appropriate, internally coherent, distinct, correctly attributed, typeable, unique, and confined to easy.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart` -- passed: 4 tests
- `flutter test` -- passed: 97 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
