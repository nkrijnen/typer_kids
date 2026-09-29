---
title: 'Establish Dutch story libraries and selection contract'
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
baseline_revision: 'eedd7537d18ccc243133c2e415526c79fcb3c650'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Dutch story selection currently returns the single easy passage for every requested difficulty, so medium and hard silently violate their tier contracts and later authoring lanes cannot work independently.

**Approach:** Split Dutch passage constants into easy, medium, and hard data files behind the unchanged `StoryContent` facade, retain `De jas in de boom` in easy, and route each Dutch difficulty only to its matching pool without altering English lists or random selection.

</frozen-after-approval>

## Implementation Notes

Use three Dart `part` files so independently authored tier data shares the existing `StoryPassage` model without circular imports or moving the public type. Preserve `StoryContent.dutch` as a compatibility alias for the retained passage used by existing screens/tests. Expose tier lists through `StoryContent.dutchEasy`, `dutchMedium`, and `dutchHard`; medium and hard intentionally start empty until their owning authoring tickets. `forDifficulty` delegates to the shared `ContentDifficulty.selectLocalized` policy from ticket 2.10. Empty Dutch tiers return empty lists and never fall back to English; `randomPassage` therefore keeps its existing fail-fast behavior if called before those tiers are populated.

## Plan Change Log

## Review Triage Log

- Quick review: no findings; retained story, tier isolation, public API compatibility, English 18/18/18 lists, part-file structure, and test isolation all verified.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart test/features_test.dart` -- passed: 35 tests
- `flutter test` -- passed: 97 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
