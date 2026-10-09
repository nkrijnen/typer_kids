# Dutch Full-Keyboard Curriculum Outline

The 16 existing `nl-letter-01` through `nl-letter-16` lessons, their content,
IDs, category, order, and saved completion are unchanged. They teach all 26
lowercase letters and space in the approved F/J-first movement order. The
following stable IDs continue that sequence; the `nl-shift-01` lesson is the
first implementation tracer. English lessons and their progress are unaffected.

## Course contract

- Stages 17-40 form the required **core** course. Stages 41-46 are a separate
  **optional** advanced path; `isOptional: false` for the foundation and core,
  `isOptional: true` for advanced lessons once the lesson model supports it.
  Core completion counts only the first 40 lessons; optional lessons have their
  own count and never block core recommendations or completion.
- For the core path, `available` means all lowercase letters, space, and every
  introduced character in this row or any preceding **core** row. A row with
  `none` adds no new character. Exercises use only `available` and may include
  any already taught character, but introductions emphasize their `New` column.
  A new category never resets this global prerequisite order.
- The first optional lesson unlocks once `nl-letter-16` is complete, without
  requiring core completion. Subsequent optional lessons unlock in optional
  order. Optional exercise scope is lowercase letters, space, and optional
  characters introduced so far; it does **not** presume later core skills.
  Shift is introduced again on the optional path; euro introduces AltGr+2.
- Category order: `homeRow` (foundation), `uppercase`, `numbers`,
  `punctuation`, `commonWords`, `sentences`, then `advancedSymbols` (optional).
  A review/checkpoint is a lesson with a stable ID and no new character.
  Each stage includes short instruction, a key drill or Dutch retrieval,
  mixed practice, and a review after each cluster. Stage examples are authored
  in natural Netherlands Dutch for ages 10-12, with no English fallback.
- Modifiers and physical fingers follow the canonical
  [Dutch ISO QWERTY layout matrix](../../specs/spec-dutch-iso-qwerty-keyboard/layout-matrix.md).
  An uppercase letter uses its lowercase physical key and the opposite Shift;
  Shift punctuation uses the documented base key and the opposite Shift; euro
  uses AltGr+2. Dead keys and accented characters remain out of scope.

## Required course

Every row's cumulative key scope is `available` as defined above. `Base` is
the physical key(s) for newly introduced output; the row introducing Shift
or a Shift punctuation combination explicitly says so. The ID, grouping, and
checkpoint text are the implementation contract for stories 5.1-5.5.

| Order | ID | Category | New | Base / modifier | Practice | Checkpoint |
| --- | --- | --- | --- | --- | --- | --- |
| 17 | nl-shift-01 | uppercase | F J | f j + opposite Shift (introduction) | F/J drill, short Dutch names and words | Both home anchors with opposite Shift |
| 18 | nl-shift-02 | uppercase | D K | d k + opposite Shift | short reach drill, mixed F/J | Home-row middle fingers |
| 19 | nl-shift-03 | uppercase | S L A | s l a + opposite Shift | ring/pinky drill, short Dutch words | All home-row capitals mixed |
| 20 | nl-shift-04 | uppercase | G H E I | g h e i + opposite Shift | inward and upper reaches, Dutch words | Mixed home and top reaches |
| 21 | nl-shift-05 | uppercase | R U T N | r u t n + opposite Shift | mixed top/bottom reaches, Dutch words | Opposite Shift during long reaches |
| 22 | nl-shift-06 | uppercase | O W M C | o w m c + opposite Shift | ring/bottom reaches, Dutch names | Mixed upper and lower rows |
| 23 | nl-shift-07 | uppercase | V B P Z | v b p z + opposite Shift | pinky and lower-row drills | All frequent capitals retrieved |
| 24 | nl-shift-08 | uppercase | X Q Y | x q y + opposite Shift | rare-letter drills, Dutch names | All 26 capitals introduced exactly once |
| 25 | nl-shift-09 | uppercase | none | previously taught Shift keys | mixed capitals and Dutch words | Uppercase review without new keys |
| 26 | nl-digit-01 | numbers | 1 2 3 | 1 2 3, no modifier | left-hand number-row introduction | Accurate reaches and home return |
| 27 | nl-digit-02 | numbers | 4 5 6 | 4 5 6, no modifier | mixed left and middle number-row retrieval | Digits 1-6 mixed |
| 28 | nl-digit-03 | numbers | 7 8 9 0 | 7 8 9 0, no modifier | right-hand number-row introduction | All ten digits available |
| 29 | nl-digit-04 | numbers | none | previously taught number keys | short Dutch number contexts and mixed drills | Number-row review |
| 30 | nl-punct-01 | punctuation | . , | . , base keys, no modifier | commas and full stops in short phrases | Sentence-ending punctuation |
| 31 | nl-punct-02 | punctuation | ? ! | / + Shift; 1 + Shift | questions and exclamations | Opposite-hand Shift for both |
| 32 | nl-punct-03 | punctuation | : ; ' " | ; + Shift; ; base; ' base; ' + Shift | quotation and lists | Colon/semicolon, quote/apostrophe contrast |
| 33 | nl-punct-04 | punctuation | - ( ) | - base; 9 + Shift; 0 + Shift | short compound words and parentheses | Hyphen and paired brackets |
| 34 | nl-punct-05 | punctuation | none | previously taught punctuation | mixed everyday Dutch sentences | Punctuation retrieval review |
| 35 | nl-punct-06 | punctuation | none | previously taught punctuation | timed mixed punctuation in Dutch text | Everyday punctuation checkpoint |
| 36 | nl-text-01 | commonWords | none | core keys only | uppercase Dutch names and familiar words | Words and capitals |
| 37 | nl-text-02 | commonWords | none | core keys only | words with dates and numbers | Digits in context |
| 38 | nl-text-03 | sentences | none | core keys only | short original Dutch sentences | Capitals, commas, full stops |
| 39 | nl-text-04 | sentences | none | core keys only | longer question/quotation/number sentences | Everyday punctuation mixed |
| 40 | nl-text-05 | sentences | none | core keys only | practical Dutch text, cumulative review | Required core completion |

## Optional advanced path

The following rows introduce **every other printable output** in the matrix.
For these rows, cumulative scope is lowercase letters and space plus optional
rows introduced to date, not unfinished core lessons. Grouping by physical
key and modifier keeps the advanced path independently teachable. The table
uses the word `pipe` for the shifted output of backslash.

| Order | ID | Category | New | Base / modifier | Practice | Checkpoint |
| --- | --- | --- | --- | --- | --- | --- |
| 41 | nl-symbol-01 | advancedSymbols | § ± ` ~ | § base; § + Shift; ` base; ` + Shift | leftmost key reaches and Shift | ISO outer keys |
| 42 | nl-symbol-02 | advancedSymbols | = _ + [ { ] } | = base; - + Shift; = + Shift; [ base/Shift; ] base/Shift | upper-right bracket and number-row drills | Pairs and shifted equivalents |
| 43 | nl-symbol-03 | advancedSymbols | backslash, pipe | backslash base; backslash + Shift | ISO home-row edge key drill | Pipe uses the backslash key |
| 44 | nl-symbol-04 | advancedSymbols | @ # $ % ^ & * | 2 3 4 5 6 7 8 + Shift | number-row Shift drills | All shifted number symbols |
| 45 | nl-symbol-05 | advancedSymbols | / < > | / base; , + Shift; . + Shift | slash and comparison signs | Bottom-row shifted keys |
| 46 | nl-symbol-06 | advancedSymbols | € | 2 + AltGr (introduction) | euro in simple Dutch price contexts | AltGr+2; optional completion |

Base `-`, `;`, apostrophe, comma, and full stop and shifted `!`, `?`, `:`,
double quote, `(`, and `)` belong to the required punctuation stages. All
letters (both cases) and digits belong to the foundation/core stages. No
remaining mapped output is omitted or repeated as a *new* character.