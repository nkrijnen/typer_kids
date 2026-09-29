import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/main.dart' as startup;
import 'package:typer_kids/models/typing_stats.dart';
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/providers/profile_provider.dart';
import 'package:typer_kids/providers/progress_provider.dart';

const knownEnglishLabels = {
  'About',
  'Accuracy',
  'Back',
  'Choose Difficulty',
  'Defend the Temple',
  'Difficulty',
  'Duration',
  'English',
  'Falling Words',
  'Free Practice',
  'Key Critters',
  'Language',
  'Lessons',
  'Profile',
  'Lesson Complete!',
  'Next Lesson',
  'Results',
  'Settings',
  'Speed Chase',
  'Start Game',
  'Start Test',
  'Story Sprint',
  'Switch Profile',
  'Test Again',
  'Typing Games',
  'Typing Test',
  'Word Bubbles',
  'Words Per Minute',
};

Set<String> englishFallbacks(Iterable<String> visibleText) => visibleText
    .map((text) => text.trim())
    .where(knownEnglishLabels.contains)
    .toSet();

Iterable<String> renderedText(WidgetTester tester) sync* {
  yield* tester
      .widgetList<Text>(find.byType(Text))
      .map((widget) => widget.data ?? widget.textSpan?.toPlainText() ?? '');
  yield* tester
      .widgetList<RichText>(find.byType(RichText))
      .map((widget) => widget.text.toPlainText());
}

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  test('known English inventory detects an injected fallback exactly', () {
    expect(englishFallbacks(['Instellingen', 'Settings', 'WPM']), {'Settings'});
  });

  testWidgets('Dutch production route inventory has no known English labels', (
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

    await tester.pumpWidget(
      startup.TyperKidsApp(
        profileProvider: profile,
        progressProvider: progress,
        languageProvider: language,
      ),
    );
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.text('Typer Kids')));
    const routes = [
      '/',
      '/lessons',
      '/lesson/nl-letter-01',
      '/games',
      '/games/falling-words',
      '/games/defend-temple',
      '/games/word-bubbles',
      '/games/speed-chase',
      '/games/key-critters',
      '/games/story-sprint',
      '/sandbox',
      '/test',
      '/settings',
    ];

    for (final route in routes) {
      router.go(route);
      await tester.pumpAndSettle();
      expect(englishFallbacks(renderedText(tester)), isEmpty, reason: route);
      expect(tester.takeException(), isNull, reason: route);
    }

    final lesson = selected.LessonCurriculum.allLessons.first;
    final stats = TypingStats(
      totalCharacters: 20,
      correctCharacters: 20,
      incorrectCharacters: 0,
      elapsed: const Duration(seconds: 30),
      completedAt: DateTime(2026, 9, 29),
    );
    router.go('/lesson/${lesson.id}/results', extra: (lesson, stats));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(
      englishFallbacks(renderedText(tester)),
      isEmpty,
      reason: 'lesson results',
    );
    expect(tester.takeException(), isNull, reason: 'lesson results');

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });

  testWidgets('Dutch profile route has no known English labels', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final profile = ProfileProvider();
    await profile.init();
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'none', language: 'nl');

    await tester.pumpWidget(
      startup.TyperKidsApp(
        profileProvider: profile,
        progressProvider: progress,
        languageProvider: language,
      ),
    );
    await tester.pumpAndSettle();
    expect(englishFallbacks(renderedText(tester)), isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });
}
