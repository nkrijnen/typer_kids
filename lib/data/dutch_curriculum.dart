import '../models/lesson.dart';

class DutchCurriculum {
  DutchCurriculum._();

  static const allLessons = <Lesson>[
    Lesson(
      id: 'nl-home-letters',
      title: 'Letters op de thuisrij',
      description: 'Oefen de letters a, s, d, f, j, k en l.',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 0,
      focusKeys: ['a', 's', 'd', 'f', 'j', 'k', 'l'],
      exercises: ['as df jk l', 'jas als das', 'sla kaas'],
      funTip: 'Leg je vingers op de thuisrij en typ rustig de letters.',
      emoji: '⌨️',
    ),
  ];
}