---
title: 'Author Dutch easy stories 7 through 12'
type: 'feature'
ticket: '3'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: '7fcc5e8f437a1156787eb7d461d043d7aea100fc'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The Dutch easy story library has six passages and needs a second distinct batch to reach twelve while preserving its easy-tier, originality, provenance, and keyboard contracts.

**Approach:** Add six original Netherlands-Dutch passages with new child-friendly topics and short common sentences, then raise the focused exact-count gate to twelve while retaining all uniqueness, metadata, provenance, character, and tier-isolation checks.

</frozen-after-approval>

## Implementation Notes

Append directly to `dutch_story_easy.dart`; do not alter the first six passages or other tiers. Use distinct everyday topics (library, train, baking, beach, class pet, market), approachable sentence length, no translated plots or copyrighted characters, exact source text, and only accepted easy characters.

## Plan Change Log

## Review Triage Log

- Quick content review: no findings; all six passages are natural Netherlands Dutch, easy-tier, age-appropriate, original, coherent, topically distinct, correctly attributed, typeable, and unique.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart` -- passed: 4 tests
- `flutter test` -- passed: 97 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
