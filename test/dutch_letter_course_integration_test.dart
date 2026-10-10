import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/data/dutch_curriculum.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/models/lesson_progress.dart';
import 'package:typer_kids/models/typing_stats.dart';
import 'package:typer_kids/providers/progress_provider.dart';

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  test('a migrated Dutch learner completes all 16 stages, survives restart, '
      'and switching profile/language leaves everything intact', () async {
    const profileId = 'learner-a';
    const otherProfileId = 'learner-b';
    final passingStats = TypingStats(
      totalCharacters: 20,
      correctCharacters: 20,
      incorrectCharacters: 0,
      elapsed: const Duration(seconds: 20),
      completedAt: DateTime(2026, 9, 28),
    );

    // Seed legacy vertical-slice completion for a milestone learner.
    final legacyLetters = LessonProgress(
      lessonId: 'nl-home-letters',
      completed: true,
      bestStarRating: 3,
      bestAccuracy: 96,
      bestWpm: 18,
      attempts: 2,
    );
    SharedPreferences.setMockInitialValues({
      'profile_${profileId}_nl_progress_nl-home-letters': legacyLetters
          .encode(),
      'profile_${profileId}_progress_en-lesson': LessonProgress(
        lessonId: 'en-lesson',
        completed: true,
        bestStarRating: 3,
        attempts: 1,
      ).encode(),
    });

    selected.LessonCurriculum.isDutch = true;
    final progress = ProgressProvider();
    await progress.init(profileId: profileId, language: 'nl');

    // Migration ran: nl-letter-01/02 carry the legacy completion.
    expect(progress.getProgress('nl-letter-01').completed, true);
    expect(progress.getProgress('nl-letter-02').completed, true);

    expect(progress.isLessonUnlocked('nl-shift-01'), false);

    // Complete every one of the 16 original stages through Y.
    for (final lesson in DutchCurriculum.allLessons.take(16)) {
      await progress.recordAttempt(lesson, passingStats);
    }
    for (final lesson in DutchCurriculum.allLessons.take(16)) {
      expect(
        progress.getProgress(lesson.id).completed,
        true,
        reason: lesson.id,
      );
    }
    expect(progress.isLessonUnlocked('nl-shift-01'), true);
    expect(progress.recommendedLesson.id, 'nl-shift-01');
    expect(progress.allCompleted, false);

    await progress.recordAttempt(DutchCurriculum.allLessons[16], passingStats);
    expect(progress.allCompleted, false);

    // Restart: fresh ProgressProvider re-reads persisted state.
    final restarted = ProgressProvider();
    await restarted.init(profileId: profileId, language: 'nl');
    expect(restarted.allCompleted, false);
    expect(restarted.getProgress('nl-shift-01').completed, true);
    expect(
      restarted.recommendedLesson.id,
      'nl-shift-02',
      reason: 'the next uppercase stage follows the first Shift lesson',
    );

    // Switch to a different profile: no completion leaks across profiles.
    await restarted.switchProfile(otherProfileId);
    expect(restarted.hasStarted, false);
    expect(restarted.getProgress('nl-letter-16').completed, false);
    expect(restarted.isLessonUnlocked('nl-shift-01'), false);

    // Switch to English and back: Dutch progress is untouched by the trip.
    await restarted.switchProfile(profileId);
    await restarted.switchLanguage('en');
    expect(restarted.getProgress('en-lesson').completed, true);
    await restarted.switchLanguage('nl');
    expect(restarted.allCompleted, false);
    for (final lesson in DutchCurriculum.allLessons.take(17)) {
      expect(
        restarted.getProgress(lesson.id).completed,
        true,
        reason: lesson.id,
      );
    }

    // English progress remains byte-identical throughout.
    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getString('profile_${profileId}_progress_en-lesson'),
      LessonProgress(
        lessonId: 'en-lesson',
        completed: true,
        bestStarRating: 3,
        attempts: 1,
      ).encode(),
    );
  });
}
