import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/main.dart' as startup;
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/providers/profile_provider.dart';
import 'package:typer_kids/providers/progress_provider.dart';
import 'package:typer_kids/data/dutch_curriculum.dart';
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/screens/games/falling_words_screen.dart';
import 'package:typer_kids/screens/games/widgets/falling_words_views.dart';
import 'package:typer_kids/screens/sandbox/sandbox_screen.dart';
import 'package:typer_kids/widgets/home/activity_card.dart';
import 'package:typer_kids/widgets/home/stat_card.dart';
import 'package:typer_kids/widgets/profile/profile_card.dart';
import 'package:typer_kids/models/typing_stats.dart';
import 'package:typer_kids/models/lesson_progress.dart';
import 'package:typer_kids/data/lesson_curriculum.dart';
import 'package:typer_kids/models/lesson.dart';

void main() {
  testWidgets(
    'Settings switches to Dutch and a completed lesson persists on restart',
    (tester) async {
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final profile = ProfileProvider();
      await profile.init();
      final child = await profile.createProfile(name: 'Noor', emoji: '🌱');
      final language = LanguageProvider();
      await language.init();
      final progress = ProgressProvider();
      await progress.init(profileId: child.id);
      await tester.pumpWidget(
        startup.TyperKidsApp(
          profileProvider: profile,
          progressProvider: progress,
          languageProvider: language,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'English home');
      await tester.ensureVisible(find.text('Settings').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nederlands'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Dutch Settings');
      expect(language.isDutch, true);
      expect(progress.language, 'nl');
      expect(find.text('Instellingen'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Dutch home');
      expect(find.textContaining('Noor'), findsWidgets);
      expect(find.text('🐵'), findsOneWidget);
      expect(find.byType(ActivityCard), findsNWidgets(2));
      expect(find.byType(StatCard), findsNWidgets(4));
      expect(find.text('Vallende woorden'), findsOneWidget);
      expect(find.text('Vrij oefenen'), findsOneWidget);
      await tester.ensureVisible(find.byType(ActionChip));
      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileCard), findsOneWidget);
      expect(find.text('🐵'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Letters oefenen'));
      await tester.tap(find.text('Letters oefenen'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Dutch lesson intro');
      expect(find.text('Begin!'), findsOneWidget);
      await tester.tap(find.text('Begin!'));
      await tester.pump();
      final exercises = DutchCurriculum.allLessons.single.exercises;
      for (final exercise in exercises) {
        for (final character in exercise.split('')) {
          await tester.sendKeyEvent(
            character == ' '
                ? LogicalKeyboardKey.space
                : LogicalKeyboardKey.findKeyByKeyId(character.codeUnitAt(0))!,
            character: character,
          );
          await tester.pump();
        }
        await tester.pump(const Duration(milliseconds: 600));
      }
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(seconds: 4));
      expect(progress.getProgress('nl-home-letters').completed, true);
      expect(find.text('Goed gedaan!'), findsOneWidget);
      final restarted = LanguageProvider();
      await restarted.init();
      final loaded = ProgressProvider();
      await loaded.init(profileId: child.id, language: restarted.language);
      expect(loaded.getProgress('nl-home-letters').completed, true);
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      selected.LessonCurriculum.isDutch = false;
    },
  );
  testWidgets('Cold startup restores the Dutch home and lesson progress', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final profile = ProfileProvider();
    await profile.init();
    final child = await profile.createProfile(name: 'Noor', emoji: '🌱');
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: child.id, language: 'nl');
    await progress.recordAttempt(
      DutchCurriculum.allLessons.single,
      TypingStats(
        totalCharacters: 10,
        correctCharacters: 10,
        incorrectCharacters: 0,
        elapsed: const Duration(seconds: 30),
        completedAt: DateTime(2026, 9, 27),
      ),
    );

    await startup.main();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Leer typen met plezier! 🎮'), findsOneWidget);
    expect(find.text('1/1'), findsOneWidget);
    expect(find.text('🐵'), findsOneWidget);
    expect(find.text('Mijn badges'), findsOneWidget);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch story completes with the original accuracy and results', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: language,
        child: const MaterialApp(home: SandboxScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('De jas in de boom'), findsOneWidget);
    expect(find.text('The Little Red Hen'), findsNothing);
    expect(find.text('Kies een niveau'), findsNothing);
    await tester.ensureVisible(find.text('Begin'));
    await tester.tap(find.text('Begin'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('De jas in de boom'), findsOneWidget);
    for (final character in StoryContent.dutch.text.split('')) {
      await tester.sendKeyEvent(
        character == ' ' ? LogicalKeyboardKey.space : LogicalKeyboardKey.keyA,
        character: character,
      );
      await tester.pump();
    }
    expect(find.text('Goed gedaan!'), findsOneWidget);
    expect(find.text('100.0%'), findsOneWidget);
    expect(find.text('Nauwkeurigheid'), findsOneWidget);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Falling Words records a separate score on game over', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'game-child', language: language.language);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: language),
          ChangeNotifierProvider.value(value: progress),
        ],
        child: const MaterialApp(home: FallingWordsScreen()),
      ),
    );
    await tester.tap(find.text('Start spel'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    for (var frame = 0; frame < 20; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    final word = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .firstWhere((text) => WordLists.dutchEasy.contains(text));
    for (final character in word!.split('')) {
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA, character: character);
      await tester.pump();
    }
    expect(find.text('${word.length * 10}'), findsOneWidget);
    for (
      var frame = 0;
      frame < 4000 && find.byType(FallingWordsGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(FallingWordsGameOver), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('Spel afgelopen!'), findsOneWidget);
    expect(find.text('punten'), findsOneWidget);
    expect(progress.getHighScore('falling_words'), word.length * 10);
    await progress.switchLanguage('en');
    expect(progress.getHighScore('falling_words'), 0);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(milliseconds: 600));
    selected.LessonCurriculum.isDutch = false;
  });
  group('TypingStats', () {
    test('calculates accuracy correctly', () {
      final stats = TypingStats(
        totalCharacters: 100,
        correctCharacters: 85,
        incorrectCharacters: 15,
        elapsed: Duration(minutes: 1),
        completedAt: DateTime(2025, 1, 1),
      );
      expect(stats.accuracy, 85.0);
    });

    test('calculates WPM correctly', () {
      final stats = TypingStats(
        totalCharacters: 50,
        correctCharacters: 50,
        incorrectCharacters: 0,
        elapsed: const Duration(minutes: 1),
        completedAt: DateTime.now(),
      );
      expect(stats.wpm, 10.0); // 50 chars / 5 = 10 words / 1 min
    });

    test('star rating based on accuracy', () {
      TypingStats makeStats(int correct, int total) => TypingStats(
        totalCharacters: total,
        correctCharacters: correct,
        incorrectCharacters: total - correct,
        elapsed: const Duration(minutes: 1),
        completedAt: DateTime.now(),
      );

      expect(makeStats(100, 100).starRating, 5); // 100%
      expect(makeStats(96, 100).starRating, 4); // 96%
      expect(makeStats(91, 100).starRating, 3); // 91%
      expect(makeStats(82, 100).starRating, 2); // 82%
      expect(makeStats(65, 100).starRating, 1); // 65%
    });
  });

  group('LessonProgress', () {
    test('records new attempt and updates bests', () {
      var progress = const LessonProgress(lessonId: 'test-01');
      expect(progress.completed, false);
      expect(progress.attempts, 0);

      final stats = TypingStats(
        totalCharacters: 50,
        correctCharacters: 48,
        incorrectCharacters: 2,
        elapsed: const Duration(seconds: 30),
        completedAt: DateTime.now(),
      );

      progress = progress.withNewAttempt(stats, passed: true);
      expect(progress.completed, true);
      expect(progress.attempts, 1);
      expect(progress.bestAccuracy, stats.accuracy);
      expect(progress.bestWpm, stats.wpm);
    });

    test('failed attempt does not complete the lesson', () {
      var progress = const LessonProgress(lessonId: 'test-02');

      final stats = TypingStats(
        totalCharacters: 50,
        correctCharacters: 30,
        incorrectCharacters: 20,
        elapsed: const Duration(seconds: 30),
        completedAt: DateTime.now(),
      );

      progress = progress.withNewAttempt(stats, passed: false);
      expect(progress.completed, false);
      expect(progress.attempts, 1);

      // A later passing attempt completes it
      progress = progress.withNewAttempt(stats, passed: true);
      expect(progress.completed, true);
      expect(progress.attempts, 2);
    });

    test('serializes and deserializes correctly', () {
      final original = LessonProgress(
        lessonId: 'hr-01',
        completed: true,
        bestStarRating: 4,
        bestAccuracy: 95.5,
        bestWpm: 25.0,
        attempts: 3,
      );

      final encoded = original.encode();
      final decoded = LessonProgress.decode(encoded);

      expect(decoded.lessonId, original.lessonId);
      expect(decoded.completed, original.completed);
      expect(decoded.bestStarRating, original.bestStarRating);
      expect(decoded.bestAccuracy, original.bestAccuracy);
      expect(decoded.bestWpm, original.bestWpm);
      expect(decoded.attempts, original.attempts);
    });
  });

  group('LessonCurriculum', () {
    test('has lessons in all categories', () {
      for (final category in LessonCategory.values) {
        final lessons = LessonCurriculum.byCategory(category);
        expect(
          lessons.isNotEmpty,
          true,
          reason: '${category.displayName} should have lessons',
        );
      }
    });

    test('all lessons have unique IDs', () {
      final ids = LessonCurriculum.allLessons.map((l) => l.id).toSet();
      expect(ids.length, LessonCurriculum.allLessons.length);
    });

    test('all lessons have exercises', () {
      for (final lesson in LessonCurriculum.allLessons) {
        expect(
          lesson.exercises.isNotEmpty,
          true,
          reason: '${lesson.title} should have exercises',
        );
      }
    });

    test('finds lesson by ID', () {
      final lesson = LessonCurriculum.byId('hr-01');
      expect(lesson, isNotNull);
      expect(lesson!.title, 'Meet F and J');
    });
  });
}
