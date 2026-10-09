import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/data/dutch_curriculum.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/data/sentence_lists.dart';
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';
import 'package:typer_kids/main.dart' as startup;
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/providers/profile_provider.dart';
import 'package:typer_kids/providers/progress_provider.dart';

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  test('complete Dutch product has every exact content contract', () {
    selected.LessonCurriculum.isDutch = true;

    expect(DutchCurriculum.allLessons, hasLength(17));
    expect(
      DutchCurriculum.allLessons.map((lesson) => lesson.id).toSet(),
      hasLength(17),
    );
    expect(DutchCurriculum.allLessons[16].id, 'nl-shift-01');
    expect(WordLists.dutchEasy, hasLength(302));
    expect(WordLists.dutchMedium, hasLength(309));
    expect(WordLists.dutchHard, hasLength(279));
    expect(SentenceLists.dutchEasy, hasLength(20));
    expect(SentenceLists.dutchMedium, hasLength(20));
    expect(SentenceLists.dutchHard, hasLength(20));
    expect(StoryContent.dutchEasy, hasLength(18));
    expect(StoryContent.dutchMedium, hasLength(18));
    expect(StoryContent.dutchHard, hasLength(18));
  });

  testWidgets('Dutch top-level routes render on phone and desktop', (
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
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      startup.TyperKidsApp(
        profileProvider: profile,
        progressProvider: progress,
        languageProvider: language,
      ),
    );
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.text('Typer Kids')));
    const routes = {
      '/': 'Leer typen met plezier! 🎮',
      '/lessons': 'Kies een les',
      '/games': 'Typspellen',
      '/sandbox': 'Vrij oefenen',
      '/test': 'Typetest',
      '/settings': 'Instellingen',
    };

    for (final size in [const Size(390, 844), const Size(1440, 900)]) {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      for (final MapEntry(key: route, value: label) in routes.entries) {
        router.go(route);
        await tester.pumpAndSettle();
        expect(find.text(label), findsOneWidget, reason: '$size $route');
        expect(tester.takeException(), isNull, reason: '$size $route');
      }
    }

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });
}
