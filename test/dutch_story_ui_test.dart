import 'package:flutter/material.dart';
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

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

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
      await tester.ensureVisible(find.text('Start test'));
      await tester.tap(find.text('Start test'));
      await tester.pump();

      expect(find.text('Typetest — 1 min'), findsOneWidget);
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
      expect(tester.takeException(), isNull);
    }

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });
}
