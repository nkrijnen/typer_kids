---
title: 'Verify all six Dutch games'
type: 'feature'
ticket: '11'
created: '2026-09-29'
status: done
route: 'oneshot'
route_source: 'pinned'
review: 'quick'
review_source: 'pinned'
lenses_ran: ['quick', 'quick']
review_loop_iteration: 2
context: []
baseline_revision: 'a0652742eaef68135e38f55f339d4bb57ddbc2d5'
---

<frozen-after-approval reason="human-owned intent — do not modify unless human renegotiates">

## Intent

**Problem:** Per-game widget tests cover Dutch content, play, game-over, and isolated scores, but they pump screens directly and do not prove the completed six-game surface works as one routed, persistent Dutch experience.

**Approach:** Add a closing integration tracer that enters every game through the real app router, verifies all three Dutch difficulty setups select the correct content contract, checks equivalent English routes, and proves all six language-scoped scores survive provider restart and language switches. Keep detailed gameplay/game-over mechanics in the existing focused tests.

</frozen-after-approval>

## Implementation Notes

Create `test/dutch_games_integration_test.dart`. One parameterized widget test owns route reachability and setup-to-play coverage for six games across easy, medium, and hard. It uses authored pool membership rather than exact randomized values, reads `RichText.toPlainText()` for Speed Chase and Story Sprint, and checks Key Critters against its language-independent key pools. A provider integration test records all six game IDs in Dutch and English, recreates `ProgressProvider`, and verifies both score maps remain isolated and intact.

Existing tests in `test/widget_test.dart` remain the owners of each game's game-over state, UI labels, and score recording through actual gameplay. Exact pool counts, uniqueness, character contracts, and English preservation remain owned by `test/dutch_word_game_test.dart` and Story Sprint tests. The full suite is the aggregate acceptance proof.

## Plan Change Log

- 2026-09-29: First review requested stronger English and mixed-tier evidence. Expanded the route matrix to all three difficulties in both languages, exact HUD assertions, and rejection of any rendered word or sentence from another authored tier.

## Review Triage Log

- `false`: router extraction, gameplay-start timing, sentence rendering, score persistence, and difficulty-tap concerns were disproven by the passing runtime tracer.
- `medium` / patch: English routes initially checked only setup labels; expanded them to the full three-difficulty content matrix.
- `medium` / patch: word and sentence assertions initially required one correct item but did not reject mixed tiers; now every rendered authored item must belong to the selected tier.
- `low` / patch: replaced substring HUD matching with exact emoji-and-label text.
- `false`: Key Critters has no exported pool source and its focused mechanic tests own exact behavior; the tracer correctly checks a live key belongs to the selected contract.
- Second quick review: no findings.

## Verification

**Commands:**
- `flutter test test/dutch_games_integration_test.dart` -- passed: 2 tests
- `flutter test` -- passed: 93 tests
- `flutter analyze` -- passed: no issues found
- macOS hot reload and runtime-error check -- passed: reload succeeded with no runtime errors
