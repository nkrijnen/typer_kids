# Dutch language support for Typer Kids

## Goal

Fork [Typer Kids](https://github.com/lohanidamodar/typer_kids) and add **complete Dutch language support**.

Dutch should not be treated as a simple UI translation. The goal is a first-class Dutch typing course in which:

* all user-facing UI is available in Dutch;
* all lessons use natural Dutch words and sentences;
* themed word packs contain Dutch vocabulary;
* stories and free-practice content are suitable for Dutch children;
* typing tests use Dutch texts;
* punctuation and character progression are appropriate for a Dutch keyboard;
* instructions, tips, achievements and game text are Dutch;
* the existing learning mechanics and games continue to work unchanged;
* English remains available as the default language.

The result should be a **language-aware typing tutor**, rather than a Dutch-specific fork with English assumptions scattered throughout the code.

---

## 1. Understand the existing application

Before changing code, map all language-dependent content.

The current repository already separates much of the relevant content under:

```text
lib/
├── core/
├── data/
├── models/
├── providers/
├── screens/
└── widgets/
```

The README specifically identifies `lib/data/` as containing lessons, word lists, story content and keyboard data. ([GitHub](https://github.com/lohanidamodar/typer_kids))

### Tasks

* [ ] Clone the upstream repository.
* [ ] Build and run the unmodified application.
* [ ] Run the existing test suite.
* [ ] Inspect every file under `lib/data/`.
* [ ] Identify all hard-coded English strings under `lib/`.
* [ ] Identify all English text embedded in:

  * lessons
  * word lists
  * themed packs
  * stories
  * typing tests
  * game content
  * tips
  * achievements
  * error messages
  * onboarding
  * settings
  * profile screens
  * navigation
  * accessibility labels
* [ ] Identify all assumptions about the English QWERTY keyboard.
* [ ] Identify whether lesson generation/progression depends on specific English letters or words.
* [ ] Document the existing content model before refactoring it.

Do not translate anything yet.

---

# 2. Introduce a language/content model

Avoid creating a large collection of:

```dart
if (language == 'nl') ...
```

Instead, introduce a proper content abstraction.

For example:

```text
LanguagePack
├── metadata
├── uiStrings
├── lessons
├── wordLists
├── themes
├── stories
├── typingTests
├── tips
├── achievements
└── keyboardLayout
```

Possible model:

```dart
class LanguagePack {
  final String id;
  final String name;
  final UiStrings ui;
  final KeyboardLayout keyboard;
  final List<Lesson> lessons;
  final List<ThemePack> themes;
  final List<Story> stories;
  final List<TypingTest> typingTests;
}
```

The exact model should follow the existing architecture rather than introducing unnecessary abstraction.

### Requirements

* [ ] English becomes the first `LanguagePack`.
* [ ] Dutch becomes the second.
* [ ] Existing English behaviour must remain unchanged.
* [ ] Language selection must not affect profile/progress data incorrectly.
* [ ] Content IDs must be stable and language-independent where possible.

---

# 3. Internationalise the UI

Move all user-facing strings out of Dart widgets.

Use Flutter’s normal localisation mechanisms where practical.

Prefer:

```text
AppLocalizations
```

over a custom translation system unless the existing project architecture makes that unnecessarily complicated.

### Translate all UI

Search systematically for English strings and cover:

* [ ] Home screen
* [ ] Lesson selection
* [ ] Lesson instructions
* [ ] Lesson completion
* [ ] Star ratings
* [ ] Progress
* [ ] Tricky Keys
* [ ] Daily streak
* [ ] Badges
* [ ] Games
* [ ] Game instructions
* [ ] Game-over screens
* [ ] High scores
* [ ] Typing test
* [ ] Free Practice
* [ ] Stories
* [ ] Profiles
* [ ] Settings
* [ ] Sound settings
* [ ] Keyboard shortcuts
* [ ] Error states
* [ ] Empty states
* [ ] Dialogues
* [ ] Accessibility labels
* [ ] Tooltips
* [ ] Mascot messages

Do not translate literally where that produces unnatural Dutch.

Example:

```text
"Keep going!"
```

might become:

```text
"Ga zo door!"
```

rather than:

```text
"Blijf gaan!"
```

---

# 4. Add Dutch keyboard support

This is one of the most important parts.

The Dutch language should use an appropriate Dutch keyboard configuration.

Determine which physical keyboard layout the application currently assumes and explicitly model:

* [ ] Dutch QWERTY layout
* [ ] Dutch AZERTY, not needed yet
* [ ] US/English QWERTY, not needed yet

At minimum, support the Dutch QWERTY layout used on normal Dutch PCs/Macs.

Investigate special characters:

```text
é
è
ë
ï
ö
ü
á
à
```

Do **not** introduce these into beginner lessons merely because they exist in Dutch.

They should be introduced deliberately at an appropriate point.

Also test:

```text
'
"
?
!
,
.
:
;
-
```

and the Dutch use of apostrophes in words such as:

```text
's
```

### Tests

Create automated tests for:

* [ ] key → finger mapping
* [ ] keyboard visualisation
* [ ] lesson validation
* [ ] punctuation
* [ ] uppercase
* [ ] shifted characters
* [ ] Dutch special characters

---

# 5. Design the Dutch lesson progression

Do not simply translate the existing English word lists.

English and Dutch have different letter frequencies and word patterns.

Create a Dutch-specific progression.

Start with the existing finger/keyboard teaching model, but generate Dutch practice material appropriate to the keys already introduced.

Example progression:

```text
Home row
    f j
    d k
    s l
    a ;

Top row
    g h
    r u
    e i
    w o
    q p

Bottom row
    v m
    c ,
    x .
    z /
    b n
```

The exact progression must follow the physical keyboard and existing Typer Kids lesson mechanics.

### For every lesson

Provide:

* [ ] target keys
* [ ] Dutch words containing only learned keys
* [ ] short Dutch phrases
* [ ] appropriate difficulty
* [ ] sensible repetition
* [ ] no unnecessary English words
* [ ] no unnatural nonsense words unless they are explicitly useful for key training

---

# 6. Build a Dutch vocabulary corpus

Create a source dataset rather than manually scattering Dutch words throughout Dart files.

For example:

```text
content/
└── nl/
    ├── words/
    │   ├── beginner.json
    │   ├── intermediate.json
    │   └── advanced.json
    ├── themes/
    ├── lessons/
    ├── stories/
    └── tests/
```

Each word should have metadata where useful:

```json
{
  "word": "huis",
  "difficulty": "beginner",
  "categories": ["home", "common"],
  "age": "6-9"
}
```

### Vocabulary requirements

Prioritise:

* common Dutch words;
* words children actually know;
* short words for beginners;
* high-frequency words;
* phonetic variety;
* progressively more difficult spelling;
* words relevant to the themes already present in Typer Kids.

Avoid:

* obscure dictionary words;
* archaic Dutch;
* adult vocabulary;
* English loanwords unless genuinely common in Dutch;
* unnecessarily difficult words early in the course.

---

# 7. Translate/rebuild themed packs

The current application has themed packs including space, ocean, animals, dinosaurs, robots, sports, music and story time. ([GitHub](https://github.com/lohanidamodar/typer_kids))

Create Dutch versions of all of them.

Example:

```text
space
    maan
    ster
    raket
    planeet
    ruimte
    astronaut

ocean
    zee
    vis
    haai
    boot
    golf
    eiland

animals
    hond
    kat
    paard
    muis
    konijn
    tijger
```

Do not merely translate individual words.

Review the complete vocabulary of each pack for:

* age suitability;
* natural Dutch;
* difficulty;
* spelling;
* repetition;
* cultural appropriateness.

---

# 8. Dutch stories

This deserves special attention.

The current project uses classic literature for some typing-test/free-practice content. ([GitHub](https://github.com/lohanidamodar/typer_kids))

For Dutch, do not automatically translate English public-domain stories.

Instead, create a Dutch story corpus.

Possible sources:

* public-domain Dutch literature;
* public-domain children’s stories;
* newly written original stories;
* short original stories specifically written for typing practice.

For children, prefer **short original stories** over literary translations.

Requirements:

* [ ] 100% Dutch
* [ ] natural sentences
* [ ] age-appropriate vocabulary
* [ ] varied sentence lengths
* [ ] useful punctuation
* [ ] appropriate capitalisation
* [ ] progressively increasing difficulty

Suggested levels:

```text
Easy
    50–100 words

Medium
    100–250 words

Hard
    250–500 words
```

Avoid using copyrighted modern children’s books.

---

# 9. Dutch typing tests

The existing application supports:

* 30 seconds
* 1 minute
* 2 minutes
* 5 minutes

and uses literature passages. ([GitHub](https://github.com/lohanidamodar/typer_kids))

Create equivalent Dutch test content.

Each duration should have enough unique material that repeated testing does not immediately become memorisation.

Create difficulty levels:

```text
Easy
Medium
Hard
```

Measure:

* WPM
* accuracy
* errors
* completion
* consistency

Do not change the scoring algorithm merely because the language changes.

---

# 10. Dutch Free Practice

Create a Dutch story/content library for Free Practice.

Requirements:

* [ ] Dutch stories
* [ ] Easy/Medium/Hard
* [ ] child-friendly content
* [ ] random selection
* [ ] progress indicator
* [ ] WPM
* [ ] accuracy
* [ ] no English fallback when Dutch is selected

The existing Free Practice mode already supports story selection and difficulty levels. ([GitHub](https://github.com/lohanidamodar/typer_kids))

---

# 11. Dutch games

The games should not merely display English words.

The existing six games are:

* Defend the Temple
* Falling Words
* Word Bubbles
* Speed Chase
* Key Critters
* Story Sprint

and each currently uses typing content appropriate to its mechanics. ([GitHub](https://github.com/lohanidamodar/typer_kids))

For Dutch:

* [ ] Dutch words in Defend the Temple
* [ ] Dutch words in Falling Words
* [ ] Dutch words in Word Bubbles
* [ ] Dutch words in Speed Chase
* [ ] Dutch letters/content in Key Critters
* [ ] Dutch sentences in Story Sprint

Test that word lengths and difficulty work properly with Dutch.

Do not assume that English word length distributions apply to Dutch.

---

# 12. Dutch tips and mascot text

Translate/rewrite all encouragement.

Create a small Dutch style guide.

Preferred style:

* short;
* friendly;
* child-oriented;
* natural Dutch;
* encouraging without being cheesy.

Examples:

```text
"Goed gedaan!"
"Bijna!"
"Probeer het nog eens."
"Je vingers staan goed."
"Ga zo door!"
```

Avoid literal translations that sound unnatural.

---

# 13. Dutch achievements and badges

Translate all 11 achievement badges and their descriptions.

Where badge names are language-specific, allow the name to live in the language pack.

For example:

```text
First Steps
→ Eerste stappen

Getting Warmed Up
→ Goed op weg

Arcade Master
→ Arcadekampioen
```

Review every translation manually.

---

# 14. Content validation

Create automated validation tooling.

The build should be able to detect:

* English content accidentally present in Dutch lessons;
* words containing keys not yet introduced;
* duplicate lessons;
* empty lessons;
* invalid punctuation;
* invalid Unicode;
* missing translations;
* missing themes;
* missing stories;
* missing achievements.

Example:

```text
validate-content --language nl
```

Output:

```text
✓ 262 lessons
✓ 1,842 Dutch words
✓ 24 stories
✓ 18 typing tests
✓ 11 achievements
✓ 8 themed packs

✗ lesson 43 contains unknown key: é
✗ story 7 missing difficulty
```

---

# 15. Translation quality checks

Do not rely entirely on machine translation.

Use a native Dutch review pass.

Review specifically for:

* natural Dutch;
* child-friendly vocabulary;
* Dutch spelling;
* punctuation;
* compound words;
* diminutives;
* grammatical correctness;
* Belgian vs Netherlands Dutch.

Target:

**Dutch as spoken/written in the Netherlands.**

---

# 16. Content licensing

This is important because the project is GPL-3.0. The repository explicitly states that derivative work must remain GPL-3.0 and that its existing story passages are adapted from public-domain classic literature. ([GitHub](https://github.com/lohanidamodar/typer_kids))

For every new content source:

* [ ] record source;
* [ ] record licence;
* [ ] verify commercial redistribution rights;
* [ ] keep attribution where required;
* [ ] avoid copyrighted children’s books;
* [ ] preferably use original Dutch content;
* [ ] add a `CONTENT-LICENSES.md`.

For original Dutch stories created specifically for the project, explicitly document their licence.

---

# 17. Language selection

Add language selection to Settings.

Initial languages:

```text
English
Nederlands
```

Requirements:

* [ ] language persists between sessions;
* [ ] language is independent of player profile;
* [ ] changing language does not delete progress;
* [ ] lessons remain correctly unlocked;
* [ ] scores remain available;
* [ ] keyboard layout changes appropriately;
* [ ] all screens update immediately where practical.

Consider whether progress should be shared between languages or tracked separately.

Preferred:

```text
Profile
 ├── English progress
 └── Dutch progress
```

This avoids an English lesson unlocking an equivalent Dutch lesson accidentally.

---

# 18. Tests

Add automated tests before considering the Dutch implementation complete.

### Unit tests

* [ ] translations
* [ ] lesson loading
* [ ] Dutch content validation
* [ ] keyboard layout
* [ ] lesson progression
* [ ] tricky-key generation
* [ ] scoring
* [ ] language switching
* [ ] profile persistence

### Widget tests

At minimum test:

* [ ] home screen in Dutch
* [ ] lesson screen
* [ ] game screen
* [ ] typing test
* [ ] free practice
* [ ] settings
* [ ] profile screen

### Manual testing

Test on:

* [ ] macOS
* [ ] Windows
* [ ] Linux
* [ ] Web

The upstream project currently supports all four. ([GitHub](https://github.com/lohanidamodar/typer_kids))

---

# 19. Accessibility

Review Dutch UI for:

* [ ] screen-reader labels
* [ ] sufficient text size
* [ ] keyboard navigation
* [ ] focus order
* [ ] colour-independent feedback
* [ ] translated semantic labels

Do not assume that translated strings have the same length as English strings.

Test for:

* overflow;
* buttons becoming too narrow;
* text wrapping;
* clipped achievement names;
* game instructions overflowing.

---

# 20. CI

Extend CI so that every pull request runs:

```text
flutter analyze
flutter test
content validation
localisation validation
```

Optionally build:

```text
flutter build macos
flutter build windows
flutter build linux
flutter build web
```

Add a CI check that prevents untranslated English UI from being introduced.

---

# 21. Documentation

Update `README.md` with:

* Dutch language support;
* language selection;
* Dutch keyboard support;
* how to contribute Dutch content;
* content licensing;
* how to add another language.

Create:

```text
docs/
├── adding-a-language.md
├── adding-lessons.md
├── content-guidelines-nl.md
└── content-licenses.md
```

---

# 22. Repository structure

Target structure:

```text
lib/
├── core/
│   ├── localization/
│   ├── keyboard/
│   └── ...
├── data/
│   ├── languages/
│   │   ├── en/
│   │   │   ├── lessons/
│   │   │   ├── words/
│   │   │   ├── themes/
│   │   │   ├── stories/
│   │   │   └── tests/
│   │   └── nl/
│   │       ├── lessons/
│   │       ├── words/
│   │       ├── themes/
│   │       ├── stories/
│   │       └── tests/
│   └── ...
├── l10n/
├── models/
├── providers/
├── screens/
└── widgets/

test/
├── localization/
├── content/
├── keyboard/
└── ...
```

The exact layout should follow the existing repository where possible. Do not perform a large architectural rewrite solely to add Dutch.

---

# 23. Suggested implementation order

Do this incrementally.

### Phase 1 — Understand

* [ ] Fork repository
* [ ] Build existing project
* [ ] Run tests
* [ ] Map all content
* [ ] Document English assumptions

### Phase 2 — Language infrastructure

* [ ] Introduce language model
* [ ] Introduce localisation
* [ ] Move UI strings
* [ ] Add language selector
* [ ] Keep English fully functional

### Phase 3 — Dutch keyboard

* [ ] Add Dutch keyboard configuration
* [ ] Add keyboard tests
* [ ] Verify physical keyboard behaviour

### Phase 4 — Dutch lessons

* [ ] Design Dutch progression
* [ ] Create vocabulary corpus
* [ ] Generate lessons
* [ ] Validate lesson progression
* [ ] Add Dutch themes

### Phase 5 — Dutch experience

* [ ] Dutch games
* [ ] Dutch stories
* [ ] Dutch typing tests
* [ ] Dutch free practice
* [ ] Dutch tips
* [ ] Dutch achievements
* [ ] Dutch mascot messages

### Phase 6 — Quality

* [ ] Native Dutch review
* [ ] Content validation
* [ ] Accessibility review
* [ ] Cross-platform testing
* [ ] CI

### Phase 7 — Release

* [ ] Update README
* [ ] Add screenshots
* [ ] Document Dutch content
* [ ] Document licences
* [ ] Create release
* [ ] Consider contributing Dutch support upstream

---

# 24. Definition of done

Dutch support is complete when a Dutch child can:

1. Install the application.
2. Select **Nederlands**.
3. Select/create a profile.
4. Learn the Dutch keyboard layout.
5. Work through the complete structured lesson progression.
6. Encounter only appropriate Dutch content during Dutch lessons.
7. Play all games using Dutch content.
8. Practice Dutch stories.
9. Take Dutch typing tests.
10. See Dutch progress, scores, achievements and feedback.
11. Use the application without encountering unexplained English UI.
12. Switch back to English without losing progress.

The final product should feel like:

> **Typer Kids, designed for Dutch children**

rather than:

> **Typer Kids with the English words translated into Dutch.**

---

# 25. First milestone

Do not start by translating all 262 lessons.

First create a thin vertical slice:

```text
Nederlands
    ↓
Dutch keyboard
    ↓
Lesson 1
    ↓
Lesson 2
    ↓
one themed lesson
    ↓
one game
    ↓
one story
    ↓
progress
    ↓
language switching
```

If this works cleanly, scale the content out to the complete Dutch course.

This also gives us an early opportunity to discover whether the existing Typer Kids architecture is actually suitable for multiple languages before investing significant effort in creating hundreds of Dutch lessons.
