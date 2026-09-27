# Curriculum Outline

## What to retain from the English packs

| Pack | Useful | Change for Dutch |
| --- | --- | --- |
| Classic (`lib/data/lesson_curriculum.dart`) | Starts at the tactile F/J anchors; adds adjacent fingers, reviews the home row, then reaches outward. | Replace English words with Dutch, and defer semicolon until the Netherlands-QWERTY punctuation stage. |
| Comprehensive (`lib/data/lesson_curriculum_comprehensive.dart`) | Short introduction, mixing, and review formats can supply varied practice. | Its A-Z introduction is unrelated to finger placement; alphabet-range runs and generated key strings must not drive the learning sequence. |
| Dutch starter (`lib/data/dutch_curriculum.dart`) | Already uses Dutch instructions and some Dutch words. | Splits the seven-letter first lesson into a cumulative sequence; do not ask for `a s d f j k l` all at once. |

The progression therefore keeps the classic pack's F/J anchors, paired finger
guidance, reach-and-return cues, short drills, and cumulative reviews. It keeps
the comprehensive pack's alternation between introduction, mixing, words, and
checkpoints, but rejects its alphabetical key order, generated alphabet ranges,
and English word banks. Alphabetical introduction is unsuitable because letter
names do not reflect finger position, travel distance, or the vocabulary a
Dutch child can type from the keys already learned.

## First-version letter-key progression

All examples use lowercase letters and spaces. Review tasks reuse only keys taught up to that stage. Finger guidance follows the home-row position on Netherlands QWERTY; return to the anchors after each reach.

Examples are explicitly labelled `drill` or `Dutch`. Difficulty describes the
movement load, not a speed target.

| Order | ID | New keys | Previously taught | Movement | Practice type | Difficulty | Examples | Review checkpoint |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | nl-letter-01 | f j | none | Index fingers find the F/J bumps and remain on the anchors. | anchor introduction | beginner | drill: ff jj fj jf | Find both anchors without looking and alternate accurately. |
| 2 | nl-letter-02 | d k | f j | Middle fingers settle beside F/J, then all fingers return home. | paired introduction | beginner | drill: fd jk df kj | Mix F/J with D/K without following one fixed pattern. |
| 3 | nl-letter-03 | s l | f j d k | Ring fingers settle beside D/K while index fingers keep the anchors. | mixed retrieval | beginner | drill: sdf jkl dsf lkj | Retrieve all six keys in mixed order. |
| 4 | nl-letter-04 | a | f j d k s l | Left little finger rests on A while the other fingers remain on their home keys. | word introduction | beginner | Dutch: jas als das kaas | Alternate A with words using all learned fingers without shifting the hand. |
| 5 | nl-letter-05 | g h | f j d k s l a | Index fingers reach inward to G/H and return to F/J. | inward reach and words | beginner | drill: fg jh gf hj<br>Dutch: dag had hals | Mix inward reaches with earlier keys and confirm the return to F/J. |
| 6 | nl-letter-06 | e i | f j d k s l a g h | Middle fingers reach upward from D/K to E/I and return home. | upper-row introduction | beginner | Dutch: de die ik is | Mix common words with earlier drills and keep accuracy steady. |
| 7 | nl-letter-07 | r u | f j d k s l a g h e i | Index fingers reach upward from F/J to R/U and return. | paired upper reach | beginner | drill: fr ju rf uj<br>Dutch: reis deur kleur | Retrieve E/I and R/U together without lifting the other fingers. |
| 8 | nl-letter-08 | t n | f j d k s l a g h e i r u | Left index reaches up and inward to T; right index reaches down to N; both return to F/J. | alternating index reaches | intermediate | Dutch: tuin trein neus hand | Alternate upper and lower index reaches, then type the words in mixed order. |
| 9 | nl-letter-09 | o w | f j d k s l a g h e i r u t n | Ring fingers reach upward from S/L to W/O and return home. | paired ring reach | intermediate | drill: sw lo ws ol<br>Dutch: hond woord stoel water | Review index reaches before mixing in both ring-finger reaches. |
| 10 | nl-letter-10 | m c | f j d k s l a g h e i r u t n o w | Right index reaches down to M; left middle finger reaches down to C; both return home. | lower-row introduction | intermediate | Dutch: muis room school cirkel | Mix upper- and lower-row movement while preserving the F/J reset. |
| 11 | nl-letter-11 | v b | f j d k s l a g h e i r u t n o w m c | Left index reaches down to V/B and returns to F after each press. | same-finger discrimination | intermediate | drill: fv fb vf bf<br>Dutch: vis vijf boom brief | Distinguish V from B without sliding the whole left hand. |
| 12 | nl-letter-12 | p | f j d k s l a g h e i r u t n o w m c v b | Right little finger reaches upward from its home position to P and returns. | outer-finger introduction | intermediate | Dutch: pen poes appel soep | Mix P with the earlier O/W ring reaches and return the little finger home. |
| 13 | nl-letter-13 | z | f j d k s l a g h e i r u t n o w m c v b p | Left little finger reaches down from A to Z and returns. | lower outer reach | intermediate | Dutch: zon zes zee zout | Alternate A and Z in words, then review both little-finger reaches. |
| 14 | nl-letter-14 | x | f j d k s l a g h e i r u t n o w m c v b p z | Left ring finger reaches down from S to X and returns. | rare-letter reach | advanced | drill: sx xs sax<br>Dutch: taxi extra mix | Type X only in short patterns and familiar Dutch words, then review C/V/B. |
| 15 | nl-letter-15 | q | f j d k s l a g h e i r u t n o w m c v b p z x | Left little finger reaches upward from A to Q and returns. | rare-letter reach | advanced | drill: aq qa<br>Dutch: quiz aqua | Contrast the upper Q reach with the lower Z reach without moving the wrist. |
| 16 | nl-letter-16 | y | f j d k s l a g h e i r u t n o w m c v b p z x q | Right index finger reaches up and inward from J to Y and returns. | final-letter integration | advanced | Dutch: yoga baby pony | Mix Y with recent rare letters, then revisit earlier checkpoints for all-letter retrieval. |

The first four stages deliberately postpone a right-pinky punctuation key;
home-row letters do not require it. After E/I, upper index reaches come first,
then lower and outer-finger reaches. Rare X, Q, and Y wait until familiar words
such as `taxi`, `quiz`, `aqua`, `yoga`, `baby`, and `pony` are available.

This first version ends when all letters are covered. Punctuation, shift, dead keys, and accents remain outside the progression until their Netherlands-QWERTY mappings are established.

## Content checks for the first version

- Every lesson records focus keys, previously taught keys, movement, exercise type, and difficulty; IDs and order are unique and stable.
- Every letter key is introduced exactly once, and the cumulative prior-key set matches all preceding stages.
- Every character in every sample is a taught letter, current focus letter, or space. Later punctuation or capitals require an explicit introduction and mapped keyboard behavior.
- Words labelled Dutch are natural age-appropriate Netherlands Dutch, not English filler or pseudo-words; label otherwise useful key patterns as drills.
- Early practice is short and cumulative, mixes hands and fingers, and includes review before advancing. Evaluate lesson quality from content and automated checks now; adjust from usage feedback later.