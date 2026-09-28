import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/models/lesson_progress.dart';
import 'package:typer_kids/providers/progress_provider.dart';

void main() {
  const profileId = 'kid';

  String dutchKey(String lessonId) =>
      'profile_${profileId}_nl_progress_$lessonId';
  String englishKey(String lessonId) =>
      'profile_${profileId}_progress_$lessonId';

  tearDown(() => selected.LessonCurriculum.isDutch = false);

  group('Dutch legacy lesson migration', () {
    test('fresh install performs no migration writes', () async {
      SharedPreferences.setMockInitialValues({});
      selected.LessonCurriculum.isDutch = true;
      final progress = ProgressProvider();
      await progress.init(profileId: profileId, language: 'nl');

      for (final id in [
        'nl-letter-01',
        'nl-letter-02',
        'nl-letter-03',
        'nl-letter-04',
      ]) {
        expect(progress.getProgress(id).attempts, 0);
      }
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getKeys().where((k) => k.contains('progress_nl-letter')),
        isEmpty,
      );
    });

    test(
      'legacy completion with no destination migrates onto every equivalent stage',
      () async {
        final legacy = LessonProgress(
          lessonId: 'nl-home-letters',
          completed: true,
          bestStarRating: 3,
          bestAccuracy: 95,
          bestWpm: 20,
          attempts: 2,
        );
        SharedPreferences.setMockInitialValues({
          dutchKey('nl-home-letters'): legacy.encode(),
        });
        selected.LessonCurriculum.isDutch = true;
        final progress = ProgressProvider();
        await progress.init(profileId: profileId, language: 'nl');

        for (final id in ['nl-letter-01', 'nl-letter-02']) {
          final migrated = progress.getProgress(id);
          expect(migrated.completed, true);
          expect(migrated.bestStarRating, 3);
          expect(migrated.bestAccuracy, 95);
        }
      },
    );

    test('destination with equal-or-better progress is preserved', () async {
      final legacy = LessonProgress(
        lessonId: 'nl-home-letters',
        bestStarRating: 1,
        bestAccuracy: 71,
        attempts: 1,
      );
      final destination = LessonProgress(
        lessonId: 'nl-letter-01',
        completed: true,
        bestStarRating: 3,
        bestAccuracy: 95,
        attempts: 4,
      );
      SharedPreferences.setMockInitialValues({
        dutchKey('nl-home-letters'): legacy.encode(),
        dutchKey('nl-letter-01'): destination.encode(),
      });
      selected.LessonCurriculum.isDutch = true;
      final progress = ProgressProvider();
      await progress.init(profileId: profileId, language: 'nl');

      final result = progress.getProgress('nl-letter-01');
      expect(result.bestStarRating, 3);
      expect(result.attempts, 4);
    });

    test('worse or absent destination is overwritten with legacy data', () async {
      final legacy = LessonProgress(
        lessonId: 'nl-home-letters',
        bestStarRating: 2,
        bestAccuracy: 80,
        attempts: 1,
      );
      SharedPreferences.setMockInitialValues({
        dutchKey('nl-home-letters'): legacy.encode(),
      });
      selected.LessonCurriculum.isDutch = true;
      final progress = ProgressProvider();
      await progress.init(profileId: profileId, language: 'nl');

      expect(progress.getProgress('nl-letter-01').bestStarRating, 2);
    });

    test('running migration twice makes no further writes', () async {
      final legacy = LessonProgress(
        lessonId: 'nl-home-words',
        bestStarRating: 2,
        bestAccuracy: 80,
        attempts: 1,
      );
      SharedPreferences.setMockInitialValues({
        dutchKey('nl-home-words'): legacy.encode(),
      });
      selected.LessonCurriculum.isDutch = true;
      final progress = ProgressProvider();
      await progress.init(profileId: profileId, language: 'nl');
      final prefs = await SharedPreferences.getInstance();
      final firstRun = prefs.getString(dutchKey('nl-letter-03'));

      await progress.switchProfile(profileId);
      final secondRun = prefs.getString(dutchKey('nl-letter-03'));

      expect(secondRun, firstRun);
    });

    test(
      'legacy nl-home-house migrates onto nl-letter-05 even though that lesson does not exist yet',
      () async {
        final legacy = LessonProgress(
          lessonId: 'nl-home-house',
          bestStarRating: 2,
          bestAccuracy: 80,
          attempts: 1,
        );
        SharedPreferences.setMockInitialValues({
          dutchKey('nl-home-house'): legacy.encode(),
        });
        selected.LessonCurriculum.isDutch = true;
        final progress = ProgressProvider();
        await progress.init(profileId: profileId, language: 'nl');

        expect(progress.getProgress('nl-letter-05').bestStarRating, 2);
        expect(selected.LessonCurriculum.byId('nl-letter-05'), isNull);
      },
    );

    test(
      'retained legacy and not-yet-real migration targets never leak into aggregate stats',
      () async {
        SharedPreferences.setMockInitialValues({
          dutchKey('nl-home-letters'): LessonProgress(
            lessonId: 'nl-home-letters',
            completed: true,
            bestStarRating: 3,
            bestAccuracy: 90,
            attempts: 1,
          ).encode(),
          dutchKey('nl-home-house'): LessonProgress(
            lessonId: 'nl-home-house',
            completed: true,
            bestStarRating: 3,
            bestAccuracy: 90,
            attempts: 1,
          ).encode(),
        });
        selected.LessonCurriculum.isDutch = true;
        final progress = ProgressProvider();
        await progress.init(profileId: profileId, language: 'nl');

        // Only nl-letter-01/02 are real curriculum lessons here; the retained
        // nl-home-letters legacy record and the nl-letter-05 migration target
        // (no lesson yet) must not be double- or phantom-counted.
        expect(progress.completedLessons, 2);
        expect(progress.totalStars, 6);
        expect(progress.averageAccuracy, 90);
      },
    );

    test('English progress is byte-identical after Dutch migration runs', () async {
      final englishProgress = LessonProgress(
        lessonId: 'en-lesson',
        bestStarRating: 3,
        attempts: 1,
      );
      SharedPreferences.setMockInitialValues({
        englishKey('en-lesson'): englishProgress.encode(),
        dutchKey('nl-home-letters'): LessonProgress(
          lessonId: 'nl-home-letters',
          bestStarRating: 2,
          attempts: 1,
        ).encode(),
      });
      selected.LessonCurriculum.isDutch = true;
      final progress = ProgressProvider();
      await progress.init(profileId: profileId, language: 'nl');

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getString(englishKey('en-lesson')),
        englishProgress.encode(),
      );
    });
  });
}
