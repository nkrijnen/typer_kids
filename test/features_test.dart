import 'package:flutter_test/flutter_test.dart';
import 'package:typer_kids/data/badges.dart';
import 'package:typer_kids/data/lesson_curriculum_comprehensive.dart';
import 'package:typer_kids/data/practice_generator.dart';
import 'package:typer_kids/data/sentence_lists.dart';
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/models/lesson.dart';
import 'package:typer_kids/models/typing_stats.dart';
import 'package:typer_kids/providers/progress_provider.dart';
import 'package:typer_kids/providers/typing_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Dutch path storage and content', () {
    tearDown(() => selected.LessonCurriculum.isDutch = false);

    test(
      'unknown language starts English, switch persists across profiles and restart',
      () async {
        SharedPreferences.setMockInitialValues({
          LanguageProvider.prefsKey: 'unknown',
        });
        final language = LanguageProvider();
        await language.init();
        expect(language.language, 'en');
        await language.select('nl');
        final restarted = LanguageProvider();
        await restarted.init();
        expect(restarted.language, 'nl');
        final progress = ProgressProvider();
        await progress.init(profileId: 'second', language: restarted.language);
        expect(progress.recommendedLesson.id, 'nl-letter-01');
      },
    );

    test(
      'English lesson save remains intact through Dutch completion, profile change and corruption',
      () async {
        SharedPreferences.setMockInitialValues({});
        selected.LessonCurriculum.isDutch = false;
        final progress = ProgressProvider();
        await progress.init(profileId: 'one');
        final english = ComprehensiveLessonCurriculum.allLessons.first;
        final stats = TypingStats(
          totalCharacters: 10,
          correctCharacters: 10,
          incorrectCharacters: 0,
          elapsed: const Duration(seconds: 30),
          completedAt: DateTime.now(),
        );
        await progress.recordAttempt(english, stats);
        final prefs = await SharedPreferences.getInstance();
        final englishSave = prefs.getString(
          'profile_one_progress_${english.id}',
        );
        selected.LessonCurriculum.isDutch = true;
        await progress.switchLanguage('nl');
        final dutch = selected.LessonCurriculum.allLessons.first;
        expect(progress.getProgress(dutch.id).completed, false);
        expect(progress.isLessonUnlocked(dutch.id), true);
        expect(progress.isLessonUnlocked('nl-letter-02'), false);
        await progress.recordAttempt(dutch, stats);
        expect(progress.getProgress(dutch.id).completed, true);
        expect(progress.isLessonUnlocked('nl-letter-02'), true);
        expect(progress.isLessonUnlocked('nl-letter-03'), false);
        expect(progress.recommendedLesson.id, 'nl-letter-02');
        await progress.recordAttempt(selected.LessonCurriculum.allLessons[1], stats);
        expect(progress.isLessonUnlocked('nl-letter-03'), true);
        await progress.switchProfile('two');
        expect(progress.getProgress(dutch.id).completed, false);
        expect(progress.isLessonUnlocked('nl-letter-02'), false);
        await progress.switchProfile('one');
        expect(progress.getProgress(dutch.id).completed, true);
        await prefs.setString('profile_two_nl_progress_${dutch.id}', 'broken');
        await progress.switchProfile('two');
        expect(progress.getProgress(dutch.id).completed, false);
        selected.LessonCurriculum.isDutch = false;
        await progress.switchProfile('one');
        await progress.switchLanguage('en');
        expect(progress.getProgress(english.id).completed, true);
        expect(selected.LessonCurriculum.byId(english.id), isNotNull);
        expect(
          prefs.getString('profile_one_progress_${english.id}'),
          englishSave,
        );
      },
    );

    test(
      'Dutch game and story use authored content and keep English scores',
      () async {
        SharedPreferences.setMockInitialValues({});
        final progress = ProgressProvider();
        await progress.init(profileId: 'one');
        await progress.recordScore('falling_words', 200);
        selected.LessonCurriculum.isDutch = true;
        await progress.switchLanguage('nl');
        for (final difficulty in ContentDifficulty.values) {
          final words = WordLists.forDifficulty(difficulty);
          expect(words.length, greaterThanOrEqualTo(12));
          expect(words.toSet(), hasLength(words.length));
          expect(words.every((word) => RegExp(r'^[a-z]+$').hasMatch(word)), true);
          expect(words.every((word) => switch (difficulty) {
            ContentDifficulty.easy => word.length <= 3,
            ContentDifficulty.medium => word.length >= 4 && word.length <= 6,
            ContentDifficulty.hard => word.length >= 7,
          }), true);
          expect(
            StoryContent.forDifficulty(difficulty),
            difficulty == ContentDifficulty.easy
                ? [StoryContent.dutch]
                : isEmpty,
          );
          expect(words, isNot(contains('the')));
        }
        expect(StoryContent.dutch.difficulty, ContentDifficulty.easy);
        expect(StoryContent.dutch.text.length, greaterThan(250));
        await progress.recordScore('falling_words', 30);
        expect(progress.getHighScore('falling_words'), 30);
        await progress.resetAll();
        expect(progress.getHighScore('falling_words'), 0);
        await progress.switchLanguage('en');
        expect(progress.getHighScore('falling_words'), 200);
      },
    );
  });
  group('ComprehensiveLessonCurriculum', () {
    test('all lessons have unique IDs and non-empty exercises', () {
      final lessons = ComprehensiveLessonCurriculum.allLessons;
      final ids = lessons.map((l) => l.id).toSet();
      expect(ids.length, lessons.length);
      for (final lesson in lessons) {
        expect(lesson.exercises, isNotEmpty, reason: lesson.title);
        for (final exercise in lesson.exercises) {
          expect(exercise.trim(), isNotEmpty, reason: lesson.title);
        }
      }
    });

    test('includes the new punctuation, fun theme, and story lessons', () {
      final titles = ComprehensiveLessonCurriculum.allLessons
          .map((l) => l.title)
          .toSet();
      expect(titles, contains('Question Marks'));
      expect(titles, contains('Excited Lines'));
      expect(titles, contains('Apostrophes'));
      expect(titles, contains('Punctuation Mix'));
      expect(titles, contains('Fun: Dinosaurs'));
      expect(titles, contains('Fun: Robots'));
      expect(titles, contains('Story: The Lost Kite'));
      expect(titles, contains('Story: The Moon Trip'));
    });

    test('no exercise repeats the same word back to back', () {
      for (final lesson in ComprehensiveLessonCurriculum.allLessons) {
        // Drills intentionally repeat short tokens and 6-letter alphabet
        // runs; only flag repeated long words, which indicate copy/paste
        // mistakes (e.g. "encyclopedia encyclopedia").
        for (final exercise in lesson.exercises) {
          final words = exercise.split(' ');
          for (var i = 1; i < words.length; i++) {
            if (words[i].length >= 8) {
              expect(
                words[i] == words[i - 1],
                isFalse,
                reason: '"${lesson.title}" repeats "${words[i]}"',
              );
            }
          }
        }
      }
    });
  });

  group('TypingProvider', () {
    Lesson makeLesson(List<String> exercises) => Lesson(
      id: 'test',
      title: 'Test',
      description: '',
      category: LessonCategory.homeRow,
      difficulty: LessonDifficulty.beginner,
      orderIndex: 1,
      focusKeys: const [],
      exercises: exercises,
    );

    test('tracks errors per expected key', () {
      final provider = TypingProvider();
      provider.startLesson(makeLesson(['ab a']));

      expect(provider.onKeyPressed('a'), true);
      expect(provider.onKeyPressed('x'), false); // expected 'b'
      expect(provider.onKeyPressed('x'), false); // expected ' ' (not counted)
      expect(provider.onKeyPressed('b'), false); // expected 'a'

      final stats = provider.stats;
      expect(stats.errorsByKey, {'b': 1, 'a': 1});
      expect(stats.correctCharacters, 1);
      expect(stats.incorrectCharacters, 3);
      provider.dispose();
    });

    test('ignores input while paused', () {
      final provider = TypingProvider();
      provider.startLesson(makeLesson(['abc']));
      provider.pause();
      expect(provider.onKeyPressed('a'), isNull);
      provider.resume();
      expect(provider.onKeyPressed('a'), true);
      provider.dispose();
    });
  });

  group('TypingStats errorsByKey serialization', () {
    test('round-trips through JSON', () {
      final stats = TypingStats(
        totalCharacters: 10,
        correctCharacters: 8,
        incorrectCharacters: 2,
        elapsed: const Duration(seconds: 20),
        completedAt: DateTime(2026, 1, 1),
        errorsByKey: const {'r': 2, 'q': 1},
      );
      final decoded = TypingStats.fromJson(stats.toJson());
      expect(decoded.errorsByKey, {'r': 2, 'q': 1});
    });

    test('handles missing errorsByKey for old saved data', () {
      final decoded = TypingStats.fromJson({
        'totalCharacters': 5,
        'correctCharacters': 5,
        'incorrectCharacters': 0,
        'elapsedMs': 1000,
        'completedAt': '2026-01-01T00:00:00.000',
      });
      expect(decoded.errorsByKey, isEmpty);
    });
  });

  group('PracticeGenerator', () {
    test('builds a tricky keys lesson with drills and real words', () {
      final lesson = PracticeGenerator.buildTrickyKeysLesson(['r', 'u', 'b']);
      expect(lesson.id, PracticeGenerator.trickyKeysLessonId);
      expect(lesson.focusKeys, ['r', 'u', 'b']);
      expect(lesson.exercises, isNotEmpty);
      // Every exercise should involve at least one of the tricky keys
      for (final exercise in lesson.exercises) {
        expect(
          exercise.contains('r') ||
              exercise.contains('u') ||
              exercise.contains('b'),
          isTrue,
          reason: exercise,
        );
      }
    });

    test('caps the focus keys at the maximum', () {
      final lesson = PracticeGenerator.buildTrickyKeysLesson([
        'a',
        'b',
        'c',
        'd',
        'e',
        'f',
        'g',
      ]);
      expect(lesson.focusKeys.length, PracticeGenerator.maxFocusKeys);
    });

    test('handles punctuation-only tricky keys', () {
      final lesson = PracticeGenerator.buildTrickyKeysLesson([';', '.']);
      expect(lesson.exercises, isNotEmpty);
      for (final exercise in lesson.exercises) {
        expect(exercise.trim(), isNotEmpty);
      }
    });
  });

  group('Streak computation', () {
    String day(int y, int m, int d) =>
        '${y.toString().padLeft(4, '0')}-'
        '${m.toString().padLeft(2, '0')}-'
        '${d.toString().padLeft(2, '0')}';

    test('counts consecutive days ending today', () {
      final days = {day(2026, 6, 8), day(2026, 6, 9), day(2026, 6, 10)};
      expect(ProgressProvider.computeStreak(days, DateTime(2026, 6, 10)), 3);
    });

    test('streak ending yesterday still counts', () {
      final days = {day(2026, 6, 8), day(2026, 6, 9)};
      expect(ProgressProvider.computeStreak(days, DateTime(2026, 6, 10)), 2);
    });

    test('gap of more than one day breaks the streak', () {
      final days = {day(2026, 6, 5), day(2026, 6, 6), day(2026, 6, 10)};
      expect(ProgressProvider.computeStreak(days, DateTime(2026, 6, 10)), 1);
    });

    test('no practice days means no streak', () {
      expect(ProgressProvider.computeStreak({}, DateTime(2026, 6, 10)), 0);
    });

    test('spans month boundaries', () {
      final days = {day(2026, 5, 30), day(2026, 5, 31), day(2026, 6, 1)};
      expect(ProgressProvider.computeStreak(days, DateTime(2026, 6, 1)), 3);
    });
  });

  group('ProgressProvider', () {
    TypingStats statsWith({
      required int correct,
      required int total,
      Map<String, int> errors = const {},
    }) => TypingStats(
      totalCharacters: total,
      correctCharacters: correct,
      incorrectCharacters: total - correct,
      elapsed: const Duration(seconds: 30),
      completedAt: DateTime.now(),
      errorsByKey: errors,
    );

    test('only passing attempts complete a lesson', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();

      final lesson = ComprehensiveLessonCurriculum.allLessons.first;
      expect(lesson.difficulty, LessonDifficulty.beginner);

      // 50% accuracy — below the 70% beginner threshold
      await provider.recordAttempt(lesson, statsWith(correct: 10, total: 20));
      expect(provider.getProgress(lesson.id).completed, false);
      expect(provider.getProgress(lesson.id).attempts, 1);

      // 90% accuracy — passes
      await provider.recordAttempt(lesson, statsWith(correct: 18, total: 20));
      expect(provider.getProgress(lesson.id).completed, true);
    });

    test('aggregates tricky keys across attempts', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();

      final lesson = ComprehensiveLessonCurriculum.allLessons.first;
      await provider.recordAttempt(
        lesson,
        statsWith(correct: 15, total: 20, errors: {'r': 2, 'q': 1}),
      );
      await provider.recordAttempt(
        lesson,
        statsWith(correct: 15, total: 20, errors: {'r': 1, 'b': 4}),
      );

      expect(provider.keyErrorCounts, {'r': 3, 'q': 1, 'b': 4});
      // Only keys with >= minErrorsToQualify misses, most-missed first
      expect(provider.trickyKeys, ['b', 'r']);
      expect(provider.trickyKeysLesson, isNotNull);
      expect(provider.trickyKeysLesson!.focusKeys, ['b', 'r']);
    });

    test('passing the tricky keys lesson clears practiced keys', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();

      final lesson = ComprehensiveLessonCurriculum.allLessons.first;
      await provider.recordAttempt(
        lesson,
        statsWith(correct: 15, total: 20, errors: {'r': 5}),
      );
      expect(provider.trickyKeys, ['r']);

      final tricky = provider.trickyKeysLesson!;
      await provider.recordAttempt(
        tricky,
        statsWith(correct: 19, total: 20), // 95% — clears the keys
      );
      expect(provider.trickyKeys, isEmpty);
      // The dynamic lesson never appears in lesson progress
      expect(provider.getProgress(tricky.id).attempts, 0);
    });

    test('records practice days and computes a streak', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();
      expect(provider.currentStreak, 0);

      final lesson = ComprehensiveLessonCurriculum.allLessons.first;
      await provider.recordAttempt(lesson, statsWith(correct: 18, total: 20));
      expect(provider.currentStreak, 1);
    });

    test('resetAll clears streak and tricky keys', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();

      final lesson = ComprehensiveLessonCurriculum.allLessons.first;
      await provider.recordAttempt(
        lesson,
        statsWith(correct: 15, total: 20, errors: {'z': 9}),
      );
      expect(provider.currentStreak, 1);
      expect(provider.trickyKeys, isNotEmpty);

      await provider.resetAll();
      expect(provider.currentStreak, 0);
      expect(provider.trickyKeys, isEmpty);
      expect(provider.completedLessons, 0);
    });
  });

  group('Badges', () {
    test('no badges on a fresh profile', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();
      expect(Badges.earned(provider), isEmpty);
    });

    test('earns first lesson and gamer badges', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();

      final lesson = ComprehensiveLessonCurriculum.allLessons.first;
      await provider.recordAttempt(
        lesson,
        TypingStats(
          totalCharacters: 20,
          correctCharacters: 20,
          incorrectCharacters: 0,
          elapsed: const Duration(seconds: 30),
          completedAt: DateTime.now(),
        ),
      );
      await provider.recordScore('falling_words', 150);

      final earned = Badges.earned(provider).map((b) => b.id).toList();
      expect(earned, contains('first_lesson'));
      expect(earned, contains('gamer'));
      expect(earned, isNot(contains('arcade_master')));
    });

    test('arcade master requires a score in every game', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ProgressProvider();
      await provider.init();

      for (final gameId in Badges.gameIds) {
        expect(
          Badges.earned(provider).map((b) => b.id),
          isNot(contains('arcade_master')),
        );
        await provider.recordScore(gameId, 100);
      }
      expect(
        Badges.earned(provider).map((b) => b.id),
        contains('arcade_master'),
      );
    });
  });

  group('SentenceLists', () {
    test('every pool has plenty of non-empty sentences', () {
      for (final d in ContentDifficulty.values) {
        final pool = SentenceLists.forDifficulty(d);
        expect(pool.length, greaterThanOrEqualTo(15), reason: d.label);
        for (final sentence in pool) {
          expect(sentence.trim(), isNotEmpty);
          // No double spaces — they'd be invisible but block progress
          expect(sentence.contains('  '), isFalse, reason: sentence);
        }
      }
    });

    test('easy sentences avoid shifted characters', () {
      for (final sentence in SentenceLists.easy) {
        expect(
          RegExp(r'^[a-z0-9 .,]+$').hasMatch(sentence),
          isTrue,
          reason: sentence,
        );
      }
    });

    test('shuffledFor returns the whole pool', () {
      final shuffled = SentenceLists.shuffledFor(ContentDifficulty.medium);
      expect(shuffled.toSet(), SentenceLists.medium.toSet());
    });

    test('Dutch pools each have exactly 20 unique, well-formed sentences', () {
      selected.LessonCurriculum.isDutch = true;
      addTearDown(() => selected.LessonCurriculum.isDutch = false);
      final pools = {
        ContentDifficulty.easy: SentenceLists.dutchEasy,
        ContentDifficulty.medium: SentenceLists.dutchMedium,
        ContentDifficulty.hard: SentenceLists.dutchHard,
      };
      for (final entry in pools.entries) {
        expect(entry.value, hasLength(20), reason: entry.key.label);
        expect(entry.value.toSet(), hasLength(20), reason: entry.key.label);
        expect(
          SentenceLists.forDifficulty(entry.key),
          same(entry.value),
          reason: entry.key.label,
        );
        for (final sentence in entry.value) {
          expect(sentence.trim(), isNotEmpty);
          expect(sentence.contains('  '), isFalse, reason: sentence);
          expect(
            sentence.codeUnits.every((c) => c < 128),
            isTrue,
            reason: sentence,
          );
        }
      }
      for (final sentence in SentenceLists.dutchEasy) {
        expect(
          RegExp(r'^[a-z0-9 .,]+$').hasMatch(sentence),
          isTrue,
          reason: sentence,
        );
      }
    });
  });

  group('StoryContent', () {
    test('every passage is well-formed', () {
      for (final d in ContentDifficulty.values) {
        final pool = StoryContent.forDifficulty(d);
        expect(pool.length, greaterThanOrEqualTo(10), reason: d.label);
        for (final passage in pool) {
          expect(passage.title.trim(), isNotEmpty);
          expect(passage.source.trim(), isNotEmpty);
          expect(passage.text.trim(), isNotEmpty, reason: passage.title);
          // Double spaces are invisible on screen but block typing progress
          expect(
            passage.text.contains('  '),
            isFalse,
            reason: '${passage.title} contains a double space',
          );
          // Only characters a kid can actually type on a US keyboard
          // (curly quotes or em-dashes would block progress forever)
          expect(
            RegExp(r'''^[a-zA-Z0-9 .,;:!?'"\-()]+$''').hasMatch(passage.text),
            isTrue,
            reason: '${passage.title} contains untypable characters',
          );
        }
      }
    });
  });
}
