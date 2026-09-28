import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as curriculum;
import 'package:typer_kids/data/word_lists.dart';

void main() {
  tearDown(() => curriculum.LessonCurriculum.isDutch = false);

  test('Falling Words has distinct Dutch words at every difficulty', () {
    curriculum.LessonCurriculum.isDutch = true;
    for (final difficulty in ContentDifficulty.values) {
      final words = WordLists.forDifficulty(difficulty);
      expect(words.length, greaterThanOrEqualTo(12));
      expect(words.toSet(), hasLength(words.length));
      expect(words.every((word) => RegExp(r'^[a-z]+$').hasMatch(word)), isTrue);
      expect(words.every((word) => switch (difficulty) {
        ContentDifficulty.easy => word.length <= 3,
        ContentDifficulty.medium => word.length >= 4 && word.length <= 6,
        ContentDifficulty.hard => word.length >= 7,
      }), isTrue);
      expect(words, isNot(contains('the')));
    }
  });

  test('English word pools are unchanged', () {
    curriculum.LessonCurriculum.isDutch = false;
    expect(WordLists.forDifficulty(ContentDifficulty.easy), contains('the'));
  });
}