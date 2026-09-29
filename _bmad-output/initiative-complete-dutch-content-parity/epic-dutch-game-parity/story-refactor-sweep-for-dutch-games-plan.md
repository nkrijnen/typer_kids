---
title: 'Refactor sweep for Dutch games'
type: 'refactor'
ticket: '10'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick', 'quick']
review_loop_iteration: 2
context: []
baseline_revision: 'b459b0109da69155b304db5c5f16a70495cc53d3'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Tickets 2.1-2.9 may have left nonfunctional duplication or maintainability debt while adding Dutch game content and localization. Any recorded cleanup finding must be resolved or retained with a reason without moving missing behavior, localization, content, or tests into this sweep.

**Approach:** Audit the completed game work and its review logs, make only evidence-backed nonfunctional refactors, and prove Dutch and English game behavior remains unchanged. When no actionable finding remains, record the no-op result and avoid speculative abstraction.

</frozen-after-approval>

## Implementation Notes

The plans for tickets 2.1-2.9 contain no deferred review findings; every finding was patched in its owning story. The first quick review identified byte-identical language-and-difficulty switches in `WordLists.forDifficulty` and `SentenceLists.forDifficulty`. `ContentDifficulty.selectLocalized` now owns that shared policy and both game content classes delegate to it.

`StoryContent.forDifficulty` remains separate because its Dutch branch is still the singleton placeholder owned by unfinished epic 3. Localized game-string ternaries also remain at their context-specific UI call sites; they carry distinct copy rather than duplicated selection behavior.

## Plan Change Log

- 2026-09-29: Quick review showed the original no-op conclusion overlooked identical word/sentence selectors. Added one shared `ContentDifficulty` policy while keeping unfinished story-library behavior out of scope.

## Review Triage Log

- `low` / patch: corrected the story content class name from `StoryPassageContent` to `StoryContent`.
- `medium` / patch: consolidated the identical `WordLists` and `SentenceLists` localized difficulty switches in `ContentDifficulty.selectLocalized`.
- `low` / patch: removed the unsupported count of localized UI ternaries; the retain decision does not depend on a count.
- `false`: verification had run before review (91 tests passed and analysis was clean), but the evidence was not yet recorded in the in-progress plan; final post-refactor evidence is recorded below.
- `low` / patch: final verification results are recorded explicitly below before completion.
- `low` / patch: the second review found no code defect but required the post-refactor command results to be written into the plan; added them below.

## Verification

**Commands:**
- `flutter test` -- passed: 91 tests
- `flutter analyze` -- passed: no issues found
- focused `dutch_word_game_test.dart` and `widget_test.dart` run -- passed: 43 tests
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
