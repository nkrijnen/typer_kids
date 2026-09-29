---
title: 'Author Dutch easy stories 13 through 18'
type: 'feature'
ticket: '4'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '5ebb8f61ed46a1cb9920f008c93292c03b376042'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch easy story lane has twelve passages and needs its final six original stories to meet the exact 18-passage parity contract.

**Approach:** Add six original Netherlands-Dutch passages with new child-friendly topics, short common sentences, easy metadata, accepted characters, and exact Typer Kids provenance; raise the focused exact-count and uniqueness gates to eighteen.

</frozen-after-approval>

## Implementation Notes

Append only to the easy part file. Use bicycle repair, treasure hunt, museum, backyard camping, neighbor help, and kite flying to avoid prior topics. Keep prose original, concrete, and easy to type; do not modify the first twelve passages or medium/hard lanes.

## Plan Change Log

## Review Triage Log

- `low` / patch: `Een nacht in de tuin` used singular `hun zak` for two children and two sleeping bags; corrected to natural plural `hun slaapzakken`.
- Reviewer found no other grammar, idiom, difficulty, originality, topic, metadata, character, uniqueness, or test issues.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart` -- passed: 4 tests
- `flutter test` -- passed: 97 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
