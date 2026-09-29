---
title: 'Author Dutch hard stories 13 through 18'
type: 'feature'
ticket: '10'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '5b3dd32e24d46e3f12085c384cff1f230757497a'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch hard library has twelve passages and needs its final six original stories to meet exact 18-passage parity.

**Approach:** Add six original Netherlands-Dutch hard passages with new topics, longer structures, richer vocabulary, supported punctuation, accepted characters, exact metadata and provenance; raise focused count and uniqueness gates to eighteen.

</frozen-after-approval>

## Implementation Notes

Append flood-model planning, museum provenance, accessibility design, night-train logistics, reef restoration, and mock-court debate passages to the hard part only. Preserve aggregate punctuation and all existing tier contracts.

## Plan Change Log

## Review Triage Log

- `false`: reviewer reported `As ze alleen...`; source already correctly reads `Als ze alleen...`.
- Reviewer found no other language, structure, age-fit, originality, logic, keyboard, punctuation, metadata, or uniqueness issues.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart` -- passed: 7 tests
- `flutter test` -- passed: 100 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload -- passed
