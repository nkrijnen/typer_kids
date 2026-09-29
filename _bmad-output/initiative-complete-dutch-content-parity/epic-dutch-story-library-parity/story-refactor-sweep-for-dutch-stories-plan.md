---
title: 'Refactor sweep for Dutch stories'
type: 'refactor'
ticket: '12'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick']
review_loop_iteration: 1
context: []
baseline_revision: 'cf3c2920cd2e47fabbb2078d084cf075adb32030'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The completed story work may retain nonfunctional duplication or maintainability debt that should be resolved without moving missing behavior or content into the sweep.

**Approach:** Consolidate concrete story-local duplication while retaining broad application localization patterns with explicit reasons, then prove all Dutch and English passage behavior remains unchanged.

</frozen-after-approval>

## Implementation Notes

Consolidate three identical random-selection containment tests into one difficulty loop. Retain explicit `LanguageProvider` ternaries and repeated Back translations: they are an established repository-wide localization pattern spanning unrelated epics, and introducing an app-wide localization abstraction here would exceed story ownership and add migration risk.

## Plan Change Log

## Review Triage Log

- Quick review: no findings; all three tiers retain 30 random attempts and broad localization abstractions are correctly retained outside this story.

## Verification

**Commands:**
- `flutter test test/dutch_story_library_test.dart` -- passed: 5 tests
- `flutter test` -- passed: 99 tests
- `flutter analyze` -- passed: no issues found
