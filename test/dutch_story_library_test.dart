import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  test('Dutch easy has eighteen unique original, typeable passages', () {
    selected.LessonCurriculum.isDutch = true;

    final passages = StoryContent.forDifficulty(ContentDifficulty.easy);
    expect(passages, hasLength(18));
    expect(passages, StoryContent.dutchEasy);
    expect(passages, contains(StoryContent.dutch));
    expect(passages.map((passage) => passage.title).toSet(), hasLength(18));
    expect(passages.map((passage) => passage.text).toSet(), hasLength(18));
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

  test(
    'Dutch medium has eighteen unique original passages with mixed punctuation',
    () {
      selected.LessonCurriculum.isDutch = true;

      final passages = StoryContent.forDifficulty(ContentDifficulty.medium);
      expect(passages, hasLength(18));
      expect(passages, StoryContent.dutchMedium);
      expect(passages.map((passage) => passage.title).toSet(), hasLength(18));
      expect(passages.map((passage) => passage.text).toSet(), hasLength(18));
      expect(
        passages.every(
          (passage) =>
              passage.source == 'Origineel verhaal van Typer Kids' &&
              passage.difficulty == ContentDifficulty.medium &&
              passage.text.isNotEmpty &&
              RegExp(r"^[A-Za-z0-9 .,!?:'-]+$").hasMatch(passage.title) &&
              RegExp(r"^[A-Za-z0-9 .,!?:'-]+$").hasMatch(passage.text) &&
              passage.text.contains(',') &&
              RegExp(r'[?!]').hasMatch(passage.text),
        ),
        isTrue,
      );
      expect(passages.any(StoryContent.dutchEasy.contains), isFalse);
    },
  );

  test('Dutch hard has eighteen unique originals with broad punctuation', () {
    selected.LessonCurriculum.isDutch = true;

    final passages = StoryContent.forDifficulty(ContentDifficulty.hard);
    expect(passages, hasLength(18));
    expect(passages, StoryContent.dutchHard);
    expect(passages.map((passage) => passage.title).toSet(), hasLength(18));
    expect(passages.map((passage) => passage.text).toSet(), hasLength(18));
    expect(
      passages.every(
        (passage) =>
            passage.source == 'Origineel verhaal van Typer Kids' &&
            passage.difficulty == ContentDifficulty.hard &&
            passage.text.isNotEmpty &&
            RegExp(
              r'''^[A-Za-z0-9 .,!?:;'"()/-]+$''',
            ).hasMatch(passage.title) &&
            RegExp(r'''^[A-Za-z0-9 .,!?:;'"()/-]+$''').hasMatch(passage.text),
      ),
      isTrue,
    );
    final allText = passages.map((passage) => passage.text).join();
    for (final punctuation in [',', ';', ':', "'", '(', ')', '?', '!']) {
      expect(allText, contains(punctuation), reason: punctuation);
    }
    expect(passages.any(StoryContent.dutchEasy.contains), isFalse);
    expect(passages.any(StoryContent.dutchMedium.contains), isFalse);
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

  test('Dutch random medium selection stays within the medium library', () {
    selected.LessonCurriculum.isDutch = true;

    for (var attempt = 0; attempt < 30; attempt++) {
      expect(
        StoryContent.dutchMedium,
        contains(StoryContent.randomPassage(ContentDifficulty.medium)),
      );
    }
  });

  test('Dutch random hard selection stays within the hard library', () {
    selected.LessonCurriculum.isDutch = true;

    for (var attempt = 0; attempt < 30; attempt++) {
      expect(
        StoryContent.dutchHard,
        contains(StoryContent.randomPassage(ContentDifficulty.hard)),
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
