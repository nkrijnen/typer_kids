---
title: 'Complete Dutch vertical slice'
type: 'feature'
ticket: ''
created: '2026-09-28'
status: 'in-progress'
route: 'full'
route_source: 'auto'
baseline_revision: '32e3ab801915d7252cf578d1bfb7413376308770'
review: ''
review_source: ''
lenses_ran: []
review_loop_iteration: 0
context: []
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** The existing Dutch tracer proves locale persistence, one lesson, a game and a story, but does not yet deliver the approved keyboard guidance, three-lesson progression, complete content and reachable Dutch UI, or closing regression checks.

**Approach:** Complete the remaining epic entries 1.2 through 1.8 in their recorded order, verifying and committing each finished entry before starting the next.

## Boundaries & Constraints

**Always:** Keep English saves, IDs, mechanics, scoring and locale/profile isolation intact. Use the documented Netherlands QWERTY layout with automated mapping checks; no physical-keyboard gate. Follow the completed Dutch curriculum's taught-key sequence; document original story provenance and licensing. Each ticket needs focused tests and a clean `flutter analyze` and `flutter test` before its own commit and `tickets.py mark` transition to done. Human Dutch-language review follows initiative completion before release, not during this build.

**Never:** Ship the entire Dutch course, expose unsupported English-only activities in Dutch mode, replace English progress, change scoring, or treat generated pseudo-words as Dutch vocabulary. Do not commit unrelated changes or bypass git hooks.

## I/O & Edge-Case Matrix

| Scenario | Input / State | Expected Output / Behavior | Error Handling |
|----------|--------------|---------------------------|----------------|
| Layout and progression | Dutch keyboard, lessons 1 and 2, themed lesson | Mapped guidance and staged taught keys; unlocks in order | Unsupported characters do not highlight a wrong physical key |
| Locale and profile switch | Dutch progress followed by English and another profile, then restart | English saves untouched; Dutch progress stays with its profile | Unknown locale falls back to English without erasing Dutch |
| Dutch play and practice | Start and finish the supported game and story | Dutch content, instructions, results and unchanged stats | No English fallback on reachable Dutch surfaces |

</frozen-after-approval>

## Code Map

- `lib/data/keyboard_data.dart`, `lib/widgets/keyboard_widget.dart`, `lib/widgets/finger_guide.dart` -- US-QWERTY static rows, shift/base lookup and guidance; add a Dutch mapping without changing the English one. Record its reference beside the mapping.
- `lib/data/dutch_curriculum.dart`, `lib/data/lesson_curriculum_selector.dart`, `lib/screens/lesson_list_screen.dart`, `lib/providers/progress_provider.dart` -- tracer curriculum and existing locale/profile namespace; reuse selection and storage contracts.
- `lib/data/word_lists.dart`, `lib/screens/games/falling_words_screen.dart`, `lib/screens/games/widgets/falling_words_views.dart` -- chosen Dutch game and difficulty routing; preserve its game loop.
- `lib/data/story_content.dart`, `lib/screens/sandbox/sandbox_screen.dart`, `lib/screens/sandbox/widgets/sandbox_views.dart`, `README.md` -- original Dutch story, difficulty selection, statistics and provenance.
- `lib/screens/home_screen.dart`, `lib/screens/settings_screen.dart`, `lib/screens/typing_screen.dart`, `lib/screens/results_screen.dart`, `lib/widgets/quit_dialog.dart`, `lib/widgets/home/`, `lib/main.dart` -- reachable milestone strings and accessibility labels; keep English branch unchanged.
- `test/dutch_curriculum_plan_test.dart`, `test/features_test.dart`, `test/widget_test.dart` -- curriculum, storage/content and widget route regression checks; extend these instead of creating test scaffolds.
- `_bmad-output/initiative-dutch-vertical-slice/epic-dutch-learning-path/tickets.toml` -- authoritative entry order and verification; completed 1.1 plan is historical, not an active gate.

## Tasks & Acceptance

**Execution:**
- [x] 1.2: keyboard data and guidance widgets -- add referenced Netherlands QWERTY mappings for letters, punctuation, shift and introduced accents, with focused mapping/widget tests; commit when green.
- [x] 1.3: Dutch curriculum, lesson progression and tests -- replace the tracer with two introductory and one themed lesson mapped to the approved outline; validate keys, Dutch text, ordering and isolated unlocks; commit when green.
- [x] 1.4: word lists, Falling Words views and tests -- supply age-appropriate Dutch words at supported difficulties and translate reachable menu, score and end states; commit when green.
- [x] 1.5: story content, Free Practice views, provenance and tests -- finish one original Dutch story with difficulty metadata, progress, WPM and accuracy; commit when green.
- [x] 1.6: reachable screens, dialogs, tooltips, semantics and tests -- remove English UI from the milestone path while preserving English; commit when green.
- [ ] 1.7: recorded review findings -- perform only justified nonfunctional cleanup, regression test and commit separately.
- [ ] 1.8: closing widget/integration tests -- exercise the full Dutch route, restart, profile/locale isolation, accessibility and English regressions; run full analysis/tests, record evidence and commit.

**Acceptance Criteria:**
- Given documented Netherlands QWERTY mappings, when a Dutch child types the taught letters and introduced punctuation, then visible key and finger guidance match the mapping without changing English guidance.
- Given a new Dutch learner, when they complete both introductions and the themed lesson, then only taught keys are exercised and their profile's Dutch unlocks advance in order.
- Given Dutch mode, when the child finishes Falling Words and an original story, then all reachable content, feedback and statistics stay Dutch without English fallback.
- Given saved English progress, when the child switches profiles and languages and restarts, then both languages' progress and the selected locale persist without corruption.

## Implementation Notes

- 1.2: KBDNE mapping and Dutch-only guidance use the existing English keyboard as a separate unchanged path; focused keyboard/widget tests and the full Flutter suite pass.
- 1.3: The three lessons cover approved stages 1-5 in order; locked-route and completion tests pass, with English progress left untouched.
- 1.4: Expanded the Dutch pools for every Falling Words difficulty; the tracer already localized its menu and end state, and game-over scoring tests pass.
- 1.5: Expanded the original easy-level story, retained Free Practice's localized completion/stats path, and reconciled README provenance and review wording.
- 1.6: Corrected reachable Settings fallback text, live keyboard and difficulty labels, and Dutch semantics for the active key and game difficulty; the `/test` route remains intentionally unavailable in Dutch.

## Plan Change Log

## Review Triage Log

## Verification

**Commands:**
- `/Users/nico/develop/flutter/bin/flutter test test/features_test.dart test/widget_test.dart test/dutch_curriculum_plan_test.dart` -- touched behaviors pass after each entry.
- `/Users/nico/develop/flutter/bin/flutter analyze` and `/Users/nico/develop/flutter/bin/flutter test` -- clean after each entry and at closure.
- `uv run _bmad/method/scripts/tickets.py --project-root "$PWD" status _bmad-output/initiative-dutch-vertical-slice` -- each committed ticket is done and the next is ready; no drift or missing prerequisites.