import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';
import 'package:typer_kids/main.dart' as startup;
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/providers/profile_provider.dart';
import 'package:typer_kids/providers/progress_provider.dart';
import 'package:typer_kids/widgets/passage_typing_display.dart';

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  test('all 54 Dutch passages are unique and assigned to their tier', () {
    selected.LessonCurriculum.isDutch = true;
    final allPassages = <StoryPassage>[];
    for (final difficulty in ContentDifficulty.values) {
      final passages = StoryContent.forDifficulty(difficulty);
      expect(passages, hasLength(18), reason: difficulty.name);
      expect(
        passages.every((passage) => passage.difficulty == difficulty),
        isTrue,
      );
      allPassages.addAll(passages);
    }
    expect(allPassages, hasLength(54));
    expect(allPassages.map((passage) => passage.title).toSet(), hasLength(54));
    expect(allPassages.map((passage) => passage.text).toSet(), hasLength(54));
  });

  testWidgets('Dutch Typing Test routes every difficulty to its story tier', (
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

    for (final difficulty in ContentDifficulty.values) {
      router.go('/');
      await tester.pumpAndSettle();
      router.go('/test');
      await tester.pumpAndSettle();
      expect(find.text('Typetest'), findsOneWidget);
      expect(find.text('Niveau'), findsOneWidget);
      expect(find.text('Duur'), findsOneWidget);
      expect(find.text('Start test'), findsOneWidget);
      expect(find.text('Typing Test'), findsNothing);

      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.tap(find.text('30 s'));
      await tester.ensureVisible(find.text('Start test'));
      await tester.tap(find.text('Start test'));
      await tester.pump();

      expect(find.text('Typetest — 30 s'), findsOneWidget);
      expect(
        find.text('${difficulty.emoji} ${difficulty.dutchLabel}'),
        findsOneWidget,
      );
      expect(find.text('Resterend'), findsOneWidget);
      expect(find.text('Nauwkeurig'), findsOneWidget);
      expect(find.text('Tekens'), findsOneWidget);
      expect(
        find.text('De timer start zodra je begint te typen!'),
        findsOneWidget,
      );

      final rendered = tester
          .widgetList<Text>(find.byType(Text))
          .map((widget) => widget.textSpan?.toPlainText() ?? '')
          .join();
      expect(
        StoryContent.forDifficulty(
          difficulty,
        ).any((passage) => rendered.contains(passage.text)),
        isTrue,
        reason: difficulty.name,
      );

      final passageText = tester
          .widget<PassageTypingDisplay>(find.byType(PassageTypingDisplay))
          .text;
      await tester.sendKeyEvent(
        LogicalKeyboardKey.keyA,
        character: passageText[0],
      );
      for (var second = 0; second < 30; second++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Blijf oefenen!'), findsOneWidget);
      expect(find.text('Woorden per minuut'), findsOneWidget);
      expect(find.text('Nauwkeurigheid'), findsOneWidget);
      expect(find.text('Verhalen'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });

  testWidgets('Dutch Free Practice completes one passage from every tier', (
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

    for (final difficulty in ContentDifficulty.values) {
      final passage = StoryContent.forDifficulty(difficulty).first;
      router.go('/');
      await tester.pumpAndSettle();
      router.go('/sandbox');
      await tester.pumpAndSettle();

      expect(find.text('Vrij oefenen'), findsOneWidget);
      expect(find.text('Niveau'), findsOneWidget);
      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('🎲 Verras mij!'));
      await tester.tap(find.text('🎲 Verras mij!'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining(passage.title).last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Begin'));
      await tester.tap(find.text('Begin'));
      await tester.pump();

      for (final (index, character) in passage.text.split('').indexed) {
        await tester.sendKeyEvent(
          character == ' ' ? LogicalKeyboardKey.space : LogicalKeyboardKey.keyA,
          character: character,
        );
        await tester.pump();
        if (index == 0) await tester.pump(const Duration(seconds: 2));
      }

      expect(find.text('Goed gedaan!'), findsOneWidget);
      expect(find.text('100.0%'), findsOneWidget);
      expect(find.text('Nauwkeurigheid'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });

  testWidgets('English story routes keep tier selection and statistics', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final profile = ProfileProvider();
    await profile.init();
    final child = await profile.createProfile(name: 'Sam', emoji: '🚀');
    final language = LanguageProvider();
    await language.init();
    final progress = ProgressProvider();
    await progress.init(profileId: child.id, language: 'en');

    await tester.pumpWidget(
      startup.TyperKidsApp(
        profileProvider: profile,
        progressProvider: progress,
        languageProvider: language,
      ),
    );
    await tester.pumpAndSettle();
    final router = GoRouter.of(tester.element(find.text('Typer Kids')));

    for (final difficulty in ContentDifficulty.values) {
      router.go('/test');
      await tester.pumpAndSettle();
      expect(find.text('Typing Test'), findsOneWidget);
      await tester.tap(find.text(difficulty.label));
      await tester.ensureVisible(find.text('30 s'));
      await tester.tap(find.text('30 s'));
      await tester.ensureVisible(find.text('Start Test'));
      await tester.tap(find.text('Start Test'));
      await tester.pump();

      final passageText = tester
          .widget<PassageTypingDisplay>(find.byType(PassageTypingDisplay))
          .text;
      expect(
        StoryContent.forDifficulty(
          difficulty,
        ).any((passage) => passageText.contains(passage.text)),
        isTrue,
        reason: difficulty.name,
      );
      await tester.sendKeyEvent(
        LogicalKeyboardKey.keyA,
        character: passageText[0],
      );
      for (var second = 0; second < 30; second++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Keep Practicing!'), findsOneWidget);
      expect(find.text('Words Per Minute'), findsOneWidget);
      expect(find.text('Accuracy'), findsOneWidget);

      router.go('/sandbox');
      await tester.pumpAndSettle();
      expect(find.text('Free Practice'), findsOneWidget);
      expect(find.text('Choose Difficulty'), findsOneWidget);
      expect(find.text('🎲 Surprise me!'), findsOneWidget);
    }

    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });
}
