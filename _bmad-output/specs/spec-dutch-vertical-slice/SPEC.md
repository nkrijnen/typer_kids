---
id: SPEC-dutch-vertical-slice
companions:
  - milestone-content.md
sources: []
---

# Dutch Vertical Slice

## Why

Typer Kids teaches from English-only content and assumes an English keyboard. Before producing a complete Dutch course, Dutch children and maintainers need one end-to-end learning path that proves language switching, Dutch content, typing guidance, and independent progress work together without breaking English.

## Capabilities

- **CAP-1**
  - **intent:** A player can select English or Nederlands independently of their profile and resume that language after restarting.
  - **success:** English remains the default; switching languages in Settings updates the milestone path immediately and the chosen language survives restart and profile changes.
- **CAP-2**
  - **intent:** A Dutch learner can see accurate finger and key guidance for a Netherlands QWERTY keyboard.
  - **success:** Visual keys and guidance match documented Netherlands QWERTY mappings for letters, uppercase, punctuation, shifted input, and deliberately introduced accented characters, with automated mapping and widget checks.
- **CAP-3**
  - **intent:** A Dutch learner can complete two introductory lessons and one themed lesson in a coherent key progression.
  - **success:** Each lesson is accessible in order, has Dutch instructions and age-appropriate exercises, and uses learned keys only except for clearly introduced new keys and purposeful drills.
- **CAP-4**
  - **intent:** A Dutch learner can play one existing typing game with Dutch content.
  - **success:** The game runs with suitable Dutch words and Dutch instructions, preserving its mechanics and scoring without English fallback.
- **CAP-5**
  - **intent:** A Dutch learner can choose and type one original Dutch story in Free Practice.
  - **success:** Story selection and typing show Dutch content, progress, WPM, and accuracy without English fallback.
- **CAP-6**
  - **intent:** A player can track lesson progress independently for English and Dutch within each profile.
  - **success:** Completing a Dutch lesson does not unlock English lessons or vice versa; existing English progress and scores remain intact after switching languages and restarting.
- **CAP-7**
  - **intent:** A Dutch learner can navigate the entire milestone path in Dutch while English players keep their existing experience.
  - **success:** Settings, home, lesson selection and completion, the chosen game, story practice, progress, feedback, and accessibility labels on that path have natural Dutch text; the English path still works.
- **CAP-8**
  - **intent:** Maintainers can detect regressions and invalid Dutch milestone content before extending the course.
  - **success:** Automated checks cover language persistence, progression and content keys, keyboard mapping and display, game and story content, progress isolation, and English regression; original Dutch material has documented licensing.

## Constraints

- Preserve existing Flutter lesson mechanics, game mechanics, and WPM/accuracy scoring; choose language-aware content boundaries over scattered language conditionals. Prefer Flutter localization facilities for UI text.
- Preserve current English profile/progress storage and scores when adding language-specific progress. A language change must not erase either language's data.
- Dutch content must be child-friendly Netherlands Dutch, originally written or redistribution-safe with documented provenance. No English fallback on the Dutch path.
- Assume Netherlands QWERTY for the Dutch layout. Check punctuation and dead-key mappings against a documented Netherlands QWERTY reference and automated tests; do not copy US shift mappings without checking. Fix any mapping errors discovered later.
- Early key-limited lessons may contain useful drills where natural Dutch words are impossible; later exercises use natural Dutch words and phrases.

## Non-goals

- Completing all 262 lessons, every themed pack, six games, all stories, typing-test durations, badges, and full-app translation in this milestone. These remain in the broader roadmap.
- Changing scoring algorithms, replacing profile data, adding AZERTY, or shipping a full Dutch content corpus in this slice.

## Success signal

A child selects Nederlands, sees accurate key guidance, completes Dutch lessons 1 and 2 plus a themed lesson, plays one Dutch game, types one Dutch story, sees Dutch progress, then switches back to English with the original English progress intact after restart.

## Assumptions

- Falling Words is the candidate game because its word mechanic appears suitable; confirm against its implementation before committing to that choice.
- The initiative may complete on automated verification without human Dutch-language review. Review Dutch wording after completion; retain original-content provenance as an acceptance requirement. No physical-keyboard review is required.
