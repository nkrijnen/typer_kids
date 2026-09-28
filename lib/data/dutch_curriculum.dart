import '../models/lesson.dart';

class DutchCurriculum {
  DutchCurriculum._();

  static const allLessons = <Lesson>[
    Lesson(
      id: 'nl-home-letters',
      title: 'Vind de starttoetsen',
      description: 'Vind f en j, en oefen daarna d en k.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 0,
      focusKeys: ['f', 'j', 'd', 'k'],
      exercises: ['ff jj fj jf', 'fd jk df kj'],
      funTip: 'Voel de streepjes op f en j. Dit zijn letteroefeningen, geen woorden.',
      emoji: '⌨️',
    ),
    Lesson(
      id: 'nl-home-words',
      title: 'Woorden op de thuisrij',
      description: 'Leer s, l en a en typ je eerste woorden.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 1,
      focusKeys: ['s', 'l', 'a'],
      exercises: ['sdf jkl dsf lkj', 'jas als das kaas'],
      funTip: 'Eerst de letters, daarna echte woorden.',
      emoji: '⌨️',
    ),
    Lesson(
      id: 'nl-home-house',
      title: 'In huis',
      description: 'Reik naar g en h en typ woorden voor in huis.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 2,
      focusKeys: ['g', 'h'],
      exercises: ['fg jh gf hj', 'dag had hals', 'glas jas hal'],
      funTip: 'Reik naar g en h en keer terug naar f en j.',
      emoji: '⌨️',
    ),
  ];
}