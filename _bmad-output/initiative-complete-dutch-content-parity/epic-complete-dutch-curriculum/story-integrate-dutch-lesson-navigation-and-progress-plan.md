---
title: 'Integrate Dutch lesson navigation and progress'
type: 'feature'
ticket: '5'
created: '2026-09-28'
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
baseline_revision: '92202fc'
---

<intent-contract>

## Intent

**Problem:** All 16 Dutch letter lessons are now authored, but the Dutch category header still says "Thuisrij" (home row) even though the lessons now span the full keyboard, not just the home row. Navigation/unlock/recommendation logic is already generic over `LessonCurriculum.allLessons` and already passes with 16 stages (verified by existing widget/provider tests updated in prior stories), so the only functional gap is the mislabeled category.

**Approach:** Relabel the Dutch lesson-list category header from "Thuisrij" to "Letters" in `lib/screens/lesson_list_screen.dart`, and add a focused widget test asserting the Dutch label and that lessons render in stage order under it. Confirm (do not re-implement) that next-lesson, recommendation, unlock, completion, profile/language-switch, and restart behavior already follow the 16-stage production order and that English is unaffected.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot): the label fix is a one-line change; navigation/progress/unlock/recommendation already worked generically (confirmed via existing tests exercising all 16 lessons in order, added in tickets 1.2-1.4). No other code changes needed.

## Verification

**Commands:**
- `flutter test test/widget_test.dart` -- expected: pass, including a new assertion for the Dutch "Letters" category label
- `flutter test` -- expected: all pass
- `flutter analyze` -- expected: no issues
