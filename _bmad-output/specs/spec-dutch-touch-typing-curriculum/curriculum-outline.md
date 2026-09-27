# Curriculum Outline

## What to retain from the English packs

| Pack | Useful | Change for Dutch |
| --- | --- | --- |
| Classic (`lib/data/lesson_curriculum.dart`) | Starts at the tactile F/J anchors; adds adjacent fingers, reviews the home row, then reaches outward. | Replace English words with Dutch, and defer semicolon until the Netherlands-QWERTY punctuation stage. |
| Comprehensive (`lib/data/lesson_curriculum_comprehensive.dart`) | Short introduction, mixing, and review formats can supply varied practice. | Its A-Z introduction is unrelated to finger placement; alphabet-range runs and generated key strings must not drive the learning sequence. |
| Dutch starter (`lib/data/dutch_curriculum.dart`) | Already uses Dutch instructions and some Dutch words. | Splits the seven-letter first lesson into a cumulative sequence; do not ask for `a s d f j k l` all at once. |

## First-version opening sequence

All examples use lowercase letters and spaces. Review tasks reuse only keys taught up to that stage. Finger guidance follows the home-row position on Netherlands QWERTY; return to the anchors after each reach.

| Stage | New keys | Previously taught | Movement and sample practice | Checkpoint |
| --- | --- | --- | --- | --- |
| 1 | f j | none | Index fingers find the F/J bumps; `ff jj fj jf` (key drill). | Find both anchors without looking; repeat short alternating runs accurately. |
| 2 | d k | f j | Middle fingers work beside the anchors; `fd jk df kj` (key drill). | Mix F/J with D/K before moving on. |
| 3 | s l | f j d k | Ring fingers join; `sdf jkl dsf lkj` (key drill). | Retrieve all six keys in mixed order, not just a fixed row pattern. |
| 4 | a | f j d k s l | Left little finger adds A; `jas`, `als`, `das`, `kaas` (Dutch words). | Alternate short drills and real words using only learned letters. |
| 5 | g h | f j d k s l a | Index fingers reach inward and return; `dag`, `had`, `hals` (Dutch words). | Mix new reaches with earlier words; check return to F/J. |
| 6 | e i | f j d k s l a g h | Middle fingers reach upward and return; `de`, `die`, `ik`, `is` (Dutch words). | Mix common words with earlier key drills; avoid speed targets until accuracy is steady. |

The first four stages deliberately postpone a right-pinky punctuation key; home-row letters do not require it.

## Complete progression required

Story 3 extends the table after stage 6 until every letter key has been introduced exactly once. It settles the post-E/I order using physical finger reach, Dutch word usefulness, and movements that need revisiting. Every added stage records new and prior keys, finger movement, practice type, examples, and a review checkpoint. Rotate introduction, mixed retrieval, useful words, and review; avoid alphabetic ordering, whole-alphabet drills, and long repeated single-key runs as the only practice.

This first version ends when all letters are covered. Punctuation, shift, dead keys, and accents remain outside the progression until their Netherlands-QWERTY mappings are established.

## Content checks for the first version

- Every lesson records focus keys, previously taught keys, movement, exercise type, and difficulty; IDs and order are unique and stable.
- Every letter key is introduced exactly once, and the cumulative prior-key set matches all preceding stages.
- Every character in every sample is a taught letter, current focus letter, or space. Later punctuation or capitals require an explicit introduction and mapped keyboard behavior.
- Words labelled Dutch are natural age-appropriate Netherlands Dutch, not English filler or pseudo-words; label otherwise useful key patterns as drills.
- Early practice is short and cumulative, mixes hands and fingers, and includes review before advancing. Evaluate lesson quality from content and automated checks now; adjust from usage feedback later.