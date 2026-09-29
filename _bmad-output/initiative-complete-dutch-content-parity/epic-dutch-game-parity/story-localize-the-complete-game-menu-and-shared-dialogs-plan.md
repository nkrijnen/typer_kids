---
title: 'Localize the complete game menu and shared dialogs'
type: 'feature'
ticket: '9'
created: '2026-09-29'
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
baseline_revision: '5d4c825'
---

<intent-contract>

## Intent

**Problem:** `game_menu_screen.dart` (all six game titles/descriptions, header, back button) was entirely hardcoded English. Worse, the router (`app_router.dart`) and home screen (`home_screen.dart`) still carried a leftover restriction from the original vertical slice: Dutch users were redirected away from `/games` and every game except Falling Words, and the home screen's game shortcut card sent Dutch users straight into Falling Words instead of opening the full menu — actively blocking access to the five games completed in tickets 2.4-2.8.

**Approach:** Localize the game menu screen (header, subtitle, all six titles/descriptions, back button) with the same `context.watch<LanguageProvider>().isDutch` pattern. Remove the now-stale `/games*` block from the router redirect (keep the `/test` block — Typing Test Dutch content is a separate, not-yet-complete epic 3 concern). Update the home screen's game shortcut card and its `G` keyboard shortcut to open the full menu for Dutch too, matching English behavior. Shared widgets (`QuitDialog`, `EmojiStatTile`, `DifficultyCard`) take all their labels from callers (already localized in 2.4-2.8) or are already Dutch-aware, so they needed no changes.

</intent-contract>

## Implementation Notes

Direct implementation (oneshot). The router/home-screen fix was not anticipated by the ticket description but is required to satisfy its verify clause ("finds all six routes... in Dutch") — the six games were unreachable via normal navigation for Dutch users before this fix, even though each screen itself was already localized.

## Verification

**Commands:**
- `flutter test test/widget_test.dart --plain-name "game menu"` -- expected: pass (1 new Dutch test covering all six titles + absence of English)
- `flutter test` -- expected: all pass (fixed 2 pre-existing tests that referenced the old "Vallende woorden" home shortcut)
- `flutter analyze` -- expected: no issues

## Review Triage Log

### 2026-09-29 — Review pass
- verdicts: 1 finding — high 0, medium 0, low 1, false 0, maybe-false 0
- findings:
  - `[low]` `[patch]` Router doc comment still only listed `/games/falling-words` under `/games`, leftover from the old restriction — updated to list all six game sub-routes.

