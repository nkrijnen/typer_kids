---
title: 'Trace one Dutch path across the app'
type: 'feature'
ticket: '1'
created: '2026-09-27'
status: 'in-review'
route: 'full'
route_source: 'auto'
baseline_revision: '30c5f1b046badd4a2af58049734287374aca25ac'
review: 'thorough'
review_source: 'auto'
lenses_ran: ['blind-hunter', 'edge-case-hunter', 'verification-gap', 'intent-alignment']
review_loop_iteration: 1
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Typer Kids has only English content and an English-only progress namespace, so a child cannot choose a persistent Dutch route without mixing lesson completion across languages.

**Approach:** Persist English/Nederlands once for the app, route a first letter-drill lesson, Falling Words run, and original Dutch story through language-aware content, and isolate lesson progress by profile and language while retaining existing English saves.

## Boundaries & Constraints

**Always:** English remains the default and existing English IDs, keys, scores, mechanics, and profile saves remain readable. Changing profiles must not change the selected language. Dutch milestone screens, instructions, feedback, and accessibility labels must be Dutch, without falling back to English content. Document original story licensing; beginner guidance covers letters only until Netherlands QWERTY punctuation and dead keys are physically verified.

**Never:** Migrate or delete English progress, localize the entire app, change scoring, claim the whole Dutch course is complete, or expose unsupported English-only games and stories as Dutch content.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| First launch | No locale preference | English course and original progress load | Treat unknown locale as English |
| Switch and restart | Choose Nederlands, change profile, restart | Dutch lesson, game and story still selected | No fallback to English content |
| Isolated progress | Finish Dutch drill then switch to English and back | Dutch completion survives; English unlocks and stored scores unchanged | Corrupt Dutch progress does not corrupt English |
| Dutch content | Pick story or start Falling Words | Only authored Dutch text and suitable Dutch words appear | No English material offered in Dutch mode |

</frozen-after-approval>

## Code Map

- `lib/main.dart`, `lib/screens/settings_screen.dart` -- provider initialization and Settings preference UI; locale is app-wide, not a Profile field.
- `lib/providers/progress_provider.dart` -- profile-prefixed progress, last lesson, streak, key errors and high scores; preserve English `profile_{id}_*` keys and use separate Dutch keys for lesson state.
- `lib/data/lesson_curriculum_selector.dart`, `lib/models/lesson.dart`, `lib/screens/lesson_list_screen.dart`, `lib/screens/typing_screen.dart`, `lib/screens/results_screen.dart`, `lib/core/router/app_router.dart` -- curriculum facade and lesson entry/completion/navigation; avoid modifying English curriculum IDs.
- `lib/data/word_lists.dart`, `lib/screens/games/falling_words_screen.dart`, `lib/screens/games/widgets/falling_words_views.dart` -- Falling Words uses `WordLists.randomWord`; preserve mechanics and scoring.
- `lib/data/story_content.dart`, `lib/screens/sandbox/sandbox_screen.dart` -- Free Practice selects passages by difficulty; supply authored Dutch passage, not an English fallback.
- `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/widgets/keyboard_widget.dart`, `lib/widgets/quit_dialog.dart` -- reachable navigation, dialogs and letter guidance; localize only the route actually exposed in Dutch mode.
- `test/features_test.dart`, `test/widget_test.dart` -- existing regression tests; add focused locale/content/storage and route tests using existing test conventions.

## Tasks & Acceptance

**Execution:**
- [ ] `lib/main.dart`, `lib/providers/language_provider.dart`, `lib/screens/settings_screen.dart` -- load/save app-wide language and switch content/progress even if Settings closes during an async save; set Flutter's locale for reachable framework labels and test a Settings selection plus cold startup with distinct saved English/Dutch progress.
- [ ] `lib/providers/progress_provider.dart` -- scope Dutch lesson progress and recommendation/unlocks by profile and language; keep English storage untouched and audit shared streak, tricky-key and score behavior.
- [ ] `lib/data/lesson_curriculum_selector.dart`, `lib/data/dutch_curriculum.dart`, `lib/data/word_lists.dart`, `lib/data/story_content.dart`, `README.md` -- add a Dutch letter drill with valid taught keys, Dutch words and an original story with licensing provenance.
- [ ] `lib/core/router/app_router.dart`, `lib/screens/home_screen.dart`, `lib/screens/profile_screen.dart`, `lib/screens/lesson_list_screen.dart`, `lib/screens/typing_screen.dart`, `lib/screens/results_screen.dart`, `lib/widgets/keyboard_widget.dart` -- connect the Dutch lesson through completion; retain supported keyboard navigation, show active profile, use natural singular lesson count, and translate visible key guidance.
- [ ] `lib/screens/games/falling_words_screen.dart`, `lib/screens/games/widgets/falling_words_views.dart`, `lib/screens/sandbox/sandbox_screen.dart`, `lib/screens/sandbox/widgets/sandbox_views.dart` -- expose only the Dutch game/story, translate all reachable game hints, and keep single-story selection and difficulty shortcuts consistent with displayed choices.
- [ ] `test/features_test.dart`, `test/widget_test.dart` -- verify Settings and startup integration, complete the lesson and story through UI and check results/storage, finish a Falling Words run and verify Dutch feedback/high score, plus matrix rows and English regression.

**Acceptance Criteria:**
- Given a fresh or existing English save, when a player chooses Nederlands in Settings, then the first Dutch letter drill is reachable and English progress remains intact.
- Given a Dutch lesson completion, when a player changes profile or restarts, then Dutch completion belongs only to that profile and English unlocks remain unchanged.
- Given Dutch mode, when the player finishes a Falling Words run and types the Free Practice story, then reachable instructions, content and feedback are Dutch and both runs retain existing scoring behavior.

## Implementation Notes

## Plan Change Log

- Review 1: Settings can unmount during save; Dutch home loses shortcuts/profile context; framework, keyboard and game hints remain English; story setup hides active shortcuts; one-story picker misleads; tests stop at activity starts. Re-derive with explicit UI and completed-route tasks above, avoiding mixed progress, English fallback and unverified success. KEEP additive Dutch/English key namespaces, authored content, supported-route guard, working lesson intro layout fix, and passing existing 43 tests.

## Review Triage Log

Review 1: high 1, medium 13, low 5, false 0, maybe-false 1. Duplicate claims are logged separately.
- blind/settings: high, bad_plan; mounted guard after saved locale skips progress switch when Settings closes, leaving Dutch UI with English progress.
- blind/home shortcuts: medium, bad_plan; Dutch branch returns before English KeyboardListener and disables all home shortcuts.
- blind/profile context: medium, bad_plan; Dutch home never renders active profile, obscuring whose progress is shown after switching.
- blind/singular count: low, patch; single Dutch lesson renders `1/1 lessen voltooid`.
- blind/framework locale: medium, bad_plan; MaterialApp has no locale configuration, so built-in accessible labels stay English on Dutch route.
- blind/space bar: low, patch; Dutch keyboard still draws `SPACE` for required spaces.
- blind/game space hint: low, patch; unmatched Dutch game input displays `Space`.
- blind/story shortcuts: medium, bad_plan; hidden 2/3 shortcuts change difficulty while Dutch run badge always says Makkelijk.
- blind/random picker: low, patch; one Dutch passage still exposes `Kies voor mij!` as if there were choices.
- blind/lesson completion: medium, bad_plan; widget test stops at intro, so UI completion/storage are not established.
- blind/game completion: medium, bad_plan; test starts game but never reaches Dutch game-over or score persistence.
- blind/story completion: medium, bad_plan; test enters story but never checks Dutch completion and accuracy/WPM.
- edge/settings: high, bad_plan; same mounted guard confirmed at Settings selection callback.
- edge/story shortcuts: medium, bad_plan; same hidden shortcut and Makkelijk label mismatch confirmed.
- edge/game hint: low, patch; same reachable `Space` hint confirmed.
- verification/Settings integration: medium, bad_plan; all tests call provider switch directly; dropping Settings handoff would still pass.
- verification/startup integration: medium, bad_plan; restart test manually switches provider, not the main startup handoff.
- verification/lesson attempt: medium, bad_plan; provider test records directly; no screen exercise is completed.
- verification/game score: medium, bad_plan; direct recordScore test leaves game-over persistence untested.
- intent-alignment: medium, bad_plan; component tests establish content/routing but not the completed child journey described in the approved intent.

## Design Notes

Keep the locale outside Profile: the spec requires one preference independent of profile switching. Reuse the existing English prefix verbatim; a Dutch namespace is additive. Limit Dutch keyboard prompts to letters pending the later physical layout check.

## Verification

**Commands:**
- `/Users/nico/develop/flutter/bin/flutter test` -- existing and new tests pass.
- `/Users/nico/develop/flutter/bin/flutter analyze` -- no new diagnostics.

**Manual checks:**
- With a real Netherlands QWERTY keyboard, inspect Dutch letter guidance and the Settings -> lesson -> game -> story -> English path; record human review of Dutch text and story provenance. Punctuation/dead-key acceptance belongs to the later story.