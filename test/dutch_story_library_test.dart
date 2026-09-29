import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  test('Dutch easy has twelve unique original, typeable passages', () {
    selected.LessonCurriculum.isDutch = true;

    final passages = StoryContent.forDifficulty(ContentDifficulty.easy);
    expect(passages, hasLength(12));
    expect(passages, StoryContent.dutchEasy);
    expect(passages, contains(StoryContent.dutch));
    expect(passages.map((passage) => passage.title).toSet(), hasLength(12));
    expect(passages.map((passage) => passage.text).toSet(), hasLength(12));
    expect(
      passages.every(
        (passage) =>
            passage.source == 'Origineel verhaal van Typer Kids' &&
            passage.difficulty == ContentDifficulty.easy &&
            passage.text.isNotEmpty &&
            RegExp(r"^[A-Za-z0-9 .,!?'-]+$").hasMatch(passage.title) &&
            RegExp(r"^[A-Za-z0-9 .,!?'-]+$").hasMatch(passage.text),
      ),
      isTrue,
    );
    expect(StoryContent.dutch.title, 'De jas in de boom');
    expect(StoryContent.dutch.source, 'Origineel verhaal van Typer Kids');
    expect(StoryContent.dutch.difficulty, ContentDifficulty.easy);
  });

  test('empty Dutch tiers never fall back to English passages', () {
    selected.LessonCurriculum.isDutch = true;

    expect(StoryContent.forDifficulty(ContentDifficulty.medium), isEmpty);
    expect(StoryContent.forDifficulty(ContentDifficulty.hard), isEmpty);
    expect(
      () => StoryContent.randomPassage(ContentDifficulty.medium),
      throwsRangeError,
    );
    expect(
      () => StoryContent.randomPassage(ContentDifficulty.hard),
      throwsRangeError,
    );
  });

  test('Dutch random easy selection stays within the easy library', () {
    selected.LessonCurriculum.isDutch = true;

    for (var attempt = 0; attempt < 30; attempt++) {
      expect(
        StoryContent.dutchEasy,
        contains(StoryContent.randomPassage(ContentDifficulty.easy)),
      );
    }
  });

  test('English list counts and random selection remain unchanged', () {
    selected.LessonCurriculum.isDutch = false;

    for (final difficulty in ContentDifficulty.values) {
      final passages = StoryContent.forDifficulty(difficulty);
      expect(passages, hasLength(18), reason: difficulty.name);
      expect(
        passages.every((passage) => passage != StoryContent.dutch),
        isTrue,
      );
      for (var attempt = 0; attempt < 20; attempt++) {
        expect(
          passages,
          contains(StoryContent.randomPassage(difficulty)),
          reason: difficulty.name,
        );
      }
    }
  });
}
