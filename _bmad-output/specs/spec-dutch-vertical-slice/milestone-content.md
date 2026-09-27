# Milestone Content and Checks

## Source and boundary

Derived from [the roadmap](../../../specs/plan.md), especially section 25. This milestone tests language-aware architecture; remaining roadmap phases are deferred, not cancelled. Do not turn this slice into a promise of complete Dutch coverage.

## Brownfield contracts

- `LessonCurriculum` currently exposes static English lessons through a comprehensive/classic selector. Keep existing English IDs and behavior stable; add a language-aware choice at the owning content boundary.
- `ProgressProvider` stores progress using profile-prefixed SharedPreferences keys and a last-lesson ID. Keep English keys readable; Dutch progress needs separate per-profile storage, recommendation, and unlock state. Check streaks, tricky-key errors, and scores for language leakage before deciding how each is scoped.
- `KeyboardData` hard-codes US-QWERTY rows, shifted punctuation, and English finger names. Model Netherlands QWERTY with physically verified apostrophes, `? ! , . : ; -`, capitals, dead keys, and deliberately introduced accents. Do not place accents in beginner lessons merely because they exist.
- `WordLists` and `StoryContent` supply English game and Free Practice material. Route the selected game and story through language-aware content, preserving the English default and avoiding Dutch-to-English fallback.
- User-facing strings are currently embedded in widgets. Localize every reachable screen, dialog, feedback message, label, tooltip, and semantics string on the milestone route. Keep the Dutch voice short, natural, and encouraging (e.g., "Goed gedaan!", "Probeer het nog eens.").

## Content to author

- Lessons 1 and 2: specify focus keys and prior-key set for each; use purposeful key drills when no natural Dutch word can be formed. Add a short Dutch phrase when learned keys allow it. Do not use English filler or pretend new letters were taught.
- One themed lesson: use a child-familiar theme already in the app (e.g., animals, ocean, space), review every Dutch word for spelling, length, age suitability, and available keys.
- One game: choose an existing game whose word lengths and input handling fit Dutch; Falling Words is provisional. Provide Dutch words and all reachable game UI text.
- One original Dutch Free Practice story: child-friendly sentences, sensible capitalization and punctuation, difficulty metadata, and enough text to exercise progress/WPM/accuracy. Document original material's GPL-3.0-compatible license; never borrow modern children's books.

## Verification and deferrals

- Baseline (user-reported, 2026-09-27): `flutter doctor` and `flutter pub get` succeeded; `flutter test` passed all 37 existing tests. This does not verify any Dutch feature. The agent sandbox terminal does not currently resolve `flutter` on PATH; check its executable path before a build.
- Check content is nonempty, IDs unique and stable, no unexpected English, correct key availability per lesson, valid Unicode, and no unintended English fallback. Test letter-to-finger mapping, visible key guidance, punctuation, uppercase, shifted characters, and accented input for the chosen layout.
- Test the Dutch route through settings, lessons, one game, one story, and profile progress; test English unchanged, profile switching, restart persistence, and language-switch isolation. Run existing `flutter analyze` and `flutter test` plus focused new tests. Human-review Dutch spelling and layout behavior on a real keyboard before release.
- Later roadmap work: complete lesson progression and vocabulary corpus; all themes, stories, typing tests, Free Practice library, games, mascot text, badges, full UI and accessibility audit, content validator across the corpus, cross-platform testing, CI, documentation, and release. Keep this plan available at `specs/plan.md` for future specs; none are acceptance gates for this milestone except where explicitly named above.