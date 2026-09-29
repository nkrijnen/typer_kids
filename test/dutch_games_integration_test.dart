import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/data/sentence_lists.dart';
import 'package:typer_kids/data/word_lists.dart';
import 'package:typer_kids/main.dart' as startup;
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/providers/profile_provider.dart';
import 'package:typer_kids/providers/progress_provider.dart';

void main() {
  tearDown(() => selected.LessonCurriculum.isDutch = false);

  testWidgets(
    'all six routed games use every Dutch difficulty and remain reachable in English',
    (tester) async {
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

      const games = [
        (
          route: '/games/falling-words',
          dutchTitle: 'Vallende woorden',
          englishTitle: 'Falling Words',
          dutchStart: 'Start spel',
          englishStart: 'Start Game',
          content: 'words',
        ),
        (
          route: '/games/defend-temple',
          dutchTitle: 'Verdedig de Tempel',
          englishTitle: 'Defend the Temple',
          dutchStart: 'Verdedig!',
          englishStart: 'Defend!',
          content: 'words',
        ),
        (
          route: '/games/word-bubbles',
          dutchTitle: 'Woordbubbels',
          englishTitle: 'Word Bubbles',
          dutchStart: 'Start spel',
          englishStart: 'Start Game',
          content: 'words',
        ),
        (
          route: '/games/speed-chase',
          dutchTitle: 'Snelheidsrace',
          englishTitle: 'Speed Chase',
          dutchStart: 'Start race',
          englishStart: 'Start Race',
          content: 'words',
        ),
        (
          route: '/games/key-critters',
          dutchTitle: 'Toetsbeestjes',
          englishTitle: 'Key Critters',
          dutchStart: 'Begin met bonken',
          englishStart: 'Start Bonking',
          content: 'keys',
        ),
        (
          route: '/games/story-sprint',
          dutchTitle: 'Verhaalsprint',
          englishTitle: 'Story Sprint',
          dutchStart: 'Begin met rennen',
          englishStart: 'Start Running',
          content: 'sentences',
        ),
      ];

      Iterable<String> renderedText() sync* {
        yield* tester
            .widgetList<Text>(find.byType(Text))
            .map((widget) => widget.data)
            .whereType<String>();
        yield* tester
            .widgetList<RichText>(find.byType(RichText))
            .map((widget) => widget.text.toPlainText());
      }

      Future<void> verifyRoutes({required bool dutch}) async {
        final wordUniverse = {
          ...WordLists.easy,
          ...WordLists.medium,
          ...WordLists.hard,
          ...WordLists.dutchEasy,
          ...WordLists.dutchMedium,
          ...WordLists.dutchHard,
        };
        final sentenceUniverse = {
          ...SentenceLists.easy,
          ...SentenceLists.medium,
          ...SentenceLists.hard,
          ...SentenceLists.dutchEasy,
          ...SentenceLists.dutchMedium,
          ...SentenceLists.dutchHard,
        };

        for (final game in games) {
          for (final difficulty in ContentDifficulty.values) {
            router.go('/games');
            await tester.pumpAndSettle();
            router.go(game.route);
            await tester.pumpAndSettle();
            expect(
              find.text(dutch ? game.dutchTitle : game.englishTitle),
              findsOneWidget,
            );
            await tester.tap(
              find.text(dutch ? difficulty.dutchLabel : difficulty.label),
            );
            await tester.tap(
              find.text(dutch ? game.dutchStart : game.englishStart),
            );
            await tester.pump();
            for (var frame = 0; frame < 20; frame++) {
              await tester.pump(const Duration(milliseconds: 100));
            }

            final text = renderedText().toList();
            final difficultyLabel = dutch
                ? difficulty.dutchLabel
                : difficulty.label;
            expect(
              find.text('${difficulty.emoji} $difficultyLabel'),
              findsOneWidget,
              reason: '${game.route} ${difficulty.name} HUD',
            );
            switch (game.content) {
              case 'words':
                final renderedWords = text.where(wordUniverse.contains);
                expect(renderedWords, isNotEmpty);
                expect(
                  renderedWords.every(
                    WordLists.forDifficulty(difficulty).contains,
                  ),
                  isTrue,
                  reason: '${game.route} ${difficulty.name} word tier',
                );
              case 'sentences':
                final renderedSentences = text.where(sentenceUniverse.contains);
                expect(renderedSentences, isNotEmpty);
                expect(
                  renderedSentences.every(
                    SentenceLists.forDifficulty(difficulty).contains,
                  ),
                  isTrue,
                  reason: '${game.route} ${difficulty.name} sentence tier',
                );
              case 'keys':
                final keys = switch (difficulty) {
                  ContentDifficulty.easy => 'asdfghjkl',
                  ContentDifficulty.medium => 'abcdefghijklmnopqrstuvwxyz',
                  ContentDifficulty.hard =>
                    'abcdefghijklmnopqrstuvwxyz0123456789',
                };
                expect(
                  text.any(
                    (value) =>
                        value.length == 1 && keys.contains(value.toLowerCase()),
                  ),
                  isTrue,
                  reason: '${game.route} ${difficulty.name} key pool',
                );
            }
          }
        }
      }

      await verifyRoutes(dutch: true);
      await language.select('en');
      await progress.switchLanguage('en');
      await tester.pump();
      await verifyRoutes(dutch: false);

      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    },
  );

  test(
    'all six game scores survive restart and remain language-isolated',
    () async {
      SharedPreferences.setMockInitialValues({});
      const gameIds = [
        'falling_words',
        'defend_temple',
        'word_bubbles',
        'speed_chase',
        'key_critters',
        'story_sprint',
      ];
      final dutchScores = {
        for (final (index, gameId) in gameIds.indexed) gameId: 100 + index,
      };
      final englishScores = {
        for (final (index, gameId) in gameIds.indexed) gameId: 10 + index,
      };

      final progress = ProgressProvider();
      await progress.init(profileId: 'game-child', language: 'nl');
      for (final MapEntry(key: gameId, value: score) in dutchScores.entries) {
        await progress.recordScore(gameId, score);
      }

      final dutchRestart = ProgressProvider();
      await dutchRestart.init(profileId: 'game-child', language: 'nl');
      expect(dutchRestart.allHighScores, dutchScores);
      await dutchRestart.switchLanguage('en');
      expect(dutchRestart.allHighScores, isEmpty);
      for (final MapEntry(key: gameId, value: score) in englishScores.entries) {
        await dutchRestart.recordScore(gameId, score);
      }

      final englishRestart = ProgressProvider();
      await englishRestart.init(profileId: 'game-child', language: 'en');
      expect(englishRestart.allHighScores, englishScores);
      await englishRestart.switchLanguage('nl');
      expect(englishRestart.allHighScores, dutchScores);
    },
  );

  test(
    'all game scores survive profile and language switches plus restart',
    () async {
      SharedPreferences.setMockInitialValues({});
      const gameIds = [
        'falling_words',
        'defend_temple',
        'word_bubbles',
        'speed_chase',
        'key_critters',
        'story_sprint',
      ];
      final profileADutchScores = {
        for (final (index, gameId) in gameIds.indexed) gameId: 200 + index,
      };
      final profileBEnglishScores = {
        for (final (index, gameId) in gameIds.indexed) gameId: 50 + index,
      };

      final progress = ProgressProvider();
      await progress.init(profileId: 'profile-a', language: 'nl');
      for (final MapEntry(key: gameId, value: score)
          in profileADutchScores.entries) {
        await progress.recordScore(gameId, score);
      }
      await progress.switchProfile('profile-b');
      await progress.switchLanguage('en');
      expect(progress.allHighScores, isEmpty);
      for (final MapEntry(key: gameId, value: score)
          in profileBEnglishScores.entries) {
        await progress.recordScore(gameId, score);
      }

      final restarted = ProgressProvider();
      await restarted.init(profileId: 'profile-b', language: 'en');
      expect(restarted.allHighScores, profileBEnglishScores);
      await restarted.switchProfile('profile-a');
      expect(restarted.allHighScores, isEmpty);
      await restarted.switchLanguage('nl');
      expect(restarted.allHighScores, profileADutchScores);
      await restarted.switchProfile('profile-b');
      expect(restarted.allHighScores, isEmpty);
      await restarted.switchLanguage('en');
      expect(restarted.allHighScores, profileBEnglishScores);
    },
  );
}
