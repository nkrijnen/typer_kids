---
title: 'Establish production lesson IDs and migrate milestone progress'
type: 'feature'
ticket: '1'
created: '2026-09-28'
status: done
route: 'full'
route_source: 'auto'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
followup_review_recommended: false
context: []
warnings: []
deferred: []
baseline_revision: 'bae54d868c4257e7e1941d88bddf857649edcba1'
---

<intent-contract>

## Intent

**Problem:** The Dutch curriculum only has 3 vertical-slice lessons (`nl-home-letters`, `nl-home-words`, `nl-home-house`) instead of the approved production lesson IDs, and existing learner progress on those 3 lessons has nowhere to migrate to.

**Approach:** Replace the 3 vertical-slice lessons with production lessons `nl-letter-01` through `nl-letter-04` (cumulative keys per the approved curriculum outline), and add an idempotent migration in `ProgressProvider` that copies each legacy lesson's completion record onto its equivalent new-stage record(s) without overwriting progress that is already better.

## Boundaries & Constraints

**Always:** New lessons use lowercase letters/spaces only and only the keys the outline stages 1-4 assign (stage1: f j; stage2: d k; stage3: s l; stage4: a), cumulative with prior stages. Migration is idempotent (safe to run every launch) and never weakens an existing destination record (compares by whichever record "wins" — prefer the higher star rating/accuracy, keep both attempts/history additive is out of scope; a simple rule: only copy legacy data onto a destination that has no record yet, or one whose `bestStarRating` is lower). English progress and lesson data are untouched.

**Never:** Do not implement stage 5 (`nl-letter-05`) as a lesson object in this story (that's ticket 1.2) — but migration MUST still write legacy `nl-home-house` progress onto a `nl-letter-05` progress key that will be consumed once that lesson exists. Do not add capitals, accents, punctuation, or dead keys. Do not touch English lesson data, keys, or migration.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Fresh install, no legacy data | No `nl-home-*` progress keys stored | No migration writes occur; `nl-letter-01..04` start unlocked/locked per normal unlock rules | None |
| Legacy completion exists, no destination yet | `nl-home-letters` completed with stars=3 | `nl-letter-01` AND `nl-letter-02` progress records created from that data | None |
| Legacy exists, destination already better | `nl-letter-01` already has stars=3; `nl-home-letters` has stars=1 | `nl-letter-01` unchanged | None |
| Legacy exists, destination worse or absent | `nl-letter-01` absent; `nl-home-letters` has stars=2 | `nl-letter-01` becomes stars=2 | None |
| Migration re-run twice | Same legacy state at two consecutive app inits | Second run makes no further writes (state stable) | None |
| English progress present alongside Dutch legacy | `profile_{id}_progress_*` (English) keys exist | English keys and values are byte-identical after migration runs | None |

</intent-contract>

## Code Map

- `lib/data/dutch_curriculum.dart` -- replace the 3 vertical-slice lessons with `nl-letter-01`..`nl-letter-04`, cumulative `focusKeys` per outline stages 1-4, add a `LessonCategory` for Dutch Letters if the enum needs one (reuse `homeRow` if adequate, confirm against outline intent — "Dutch Letters category" in the ticket description means the app-facing curriculum category, reuse existing `LessonCategory.homeRow` unless doing so would mislabel the UI; if a distinct category is warranted, add it to the enum in `lib/models/lesson.dart` and wire label/consumers)
- `lib/providers/progress_provider.dart` -- add an idempotent `_migrateLegacyDutchLessonIds()` (or similarly named) step invoked once during Dutch init/switch, mapping `nl-home-letters` -> [`nl-letter-01`, `nl-letter-02`], `nl-home-words` -> [`nl-letter-03`, `nl-letter-04`], `nl-home-house` -> [`nl-letter-05`]; only write when destination is absent or has a lower `bestStarRating`; never delete the legacy record (so re-running stays idempotent and non-destructive)
- `lib/models/lesson_progress.dart` -- reference only, no change expected unless a comparison helper is convenient to add
- `test/dutch_curriculum_plan_test.dart` -- extend/add assertions that `nl-letter-01..04` exist, in order, with the exact cumulative key sets from the outline
- new `test/dutch_lesson_migration_test.dart` -- focused tests for the migration matrix above, using `SharedPreferences.setMockInitialValues` and `ProgressProvider`, following the pattern in `test/features_test.dart`

## Tasks & Acceptance

**Execution:**
- [ ] `lib/data/dutch_curriculum.dart` -- replace vertical-slice lessons with `nl-letter-01`..`nl-letter-04` (cumulative focusKeys: [f,j], [f,j,d,k], [f,j,d,k,s,l], [f,j,d,k,s,l,a]) -- required production IDs per approved outline
- [ ] `lib/providers/progress_provider.dart` -- add idempotent legacy-to-production migration for the 3 legacy lesson ids -- preserves existing learners' progress without weakening it
- [ ] `test/dutch_curriculum_plan_test.dart` -- assert new lesson IDs/order/keys -- DC-1..DC-3 contract
- [ ] `test/dutch_lesson_migration_test.dart` (new) -- cover the I/O matrix above -- DC-4/DC-6 contract, non-destructive idempotent migration

**Acceptance Criteria:**
- Given a fresh profile with no Dutch progress, when the app initializes Dutch, then `nl-letter-01` through `nl-letter-04` exist with the exact cumulative key sets and no migration writes occur.
- Given a profile with legacy `nl-home-letters`/`nl-home-words`/`nl-home-house` progress, when migration runs, then each legacy record's data appears on every one of its equivalent destination stage records, English progress is unchanged, and running migration again produces no further change.
- Given a destination stage that already has equal-or-better progress than its legacy source, when migration runs, then the existing (better) destination record is preserved unchanged.

## Implementation Notes

## Plan Change Log

## Review Triage Log

### 2026-09-28 — Review pass
- verdicts: 2 findings — high 1, medium 0, low 0, false 0, maybe-false 0
- findings:
  - `[high]` `[patch]` Retained legacy Dutch progress records and the not-yet-real `nl-letter-05` migration target leaked into `completedLessons`/`totalStars`/`averageAccuracy`/`averageWpm`, inflating stats and enabling early `allCompleted`/badge triggers — fixed by adding a `_curriculumProgress` filter (only ids present in `LessonCurriculum.allLessons`) and routing all four aggregate getters through it; verified with a new regression test asserting `completedLessons`/`totalStars`/`averageAccuracy` stay correct with legacy+phantom records present.
  - `[high]` `[patch]` Missing test coverage for the above scenario — fixed together with the same patch by adding `retained legacy and not-yet-real migration targets never leak into aggregate stats` to test/dutch_lesson_migration_test.dart.


## Design Notes

Migration comparison rule: destination wins ties (`>=` on `bestStarRating`) so re-running migration is a no-op once destinations have been touched by real play — this is what makes "exactly once" verifiable via idempotence rather than a one-time flag.

## Verification

**Commands:**
- `flutter test test/dutch_curriculum_plan_test.dart test/dutch_lesson_migration_test.dart` -- expected: all pass
- `flutter analyze` -- expected: no new errors introduced by this change
