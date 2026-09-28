import '../models/lesson.dart';

class DutchCurriculum {
  DutchCurriculum._();

  static const allLessons = <Lesson>[
    Lesson(
      id: 'nl-letter-01',
      title: 'Vind de starttoetsen',
      description: 'Vind f en j en oefen tot je ze blind kunt vinden.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 0,
      focusKeys: ['f', 'j'],
      exercises: ['ff jj fj jf'],
      funTip:
          'Voel de streepjes op f en j. Dit zijn letteroefeningen, geen woorden.',
      emoji: '⌨️',
    ),
    Lesson(
      id: 'nl-letter-02',
      title: 'D en k erbij',
      description: 'Je middelvingers leren d en k, vlak naast f en j.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 1,
      focusKeys: ['f', 'j', 'd', 'k'],
      exercises: ['fd jk df kj'],
      funTip: 'Laat je vingers steeds terugkeren naar f en j.',
      emoji: '⌨️',
    ),
    Lesson(
      id: 'nl-letter-03',
      title: 'S en l ontdekken',
      description:
          'Je ringvingers leren s en l, terwijl de wijsvingers op f en j blijven.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 2,
      focusKeys: ['f', 'j', 'd', 'k', 's', 'l'],
      exercises: ['sdf jkl dsf lkj'],
      funTip: 'Zes toetsen door elkaar. Kun je ze zonder te kijken vinden?',
      emoji: '⌨️',
    ),
    Lesson(
      id: 'nl-letter-04',
      title: 'Woorden op de thuisrij',
      description: 'Leer a en typ je eerste Nederlandse woorden.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 3,
      focusKeys: ['f', 'j', 'd', 'k', 's', 'l', 'a'],
      exercises: ['jas als das kaas'],
      funTip: 'Eerst de letters, daarna echte woorden.',
      emoji: '⌨️',
    ),
  ];
}
