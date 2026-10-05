import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typer_kids/main.dart' as startup;
import 'package:typer_kids/providers/language_provider.dart';
import 'package:typer_kids/providers/profile_provider.dart';
import 'package:typer_kids/providers/progress_provider.dart';
import 'package:typer_kids/data/dutch_curriculum.dart';
import 'package:typer_kids/data/keyboard_data.dart';
import 'package:typer_kids/widgets/keyboard_widget.dart';
import 'package:typer_kids/widgets/typing_display.dart';
import 'package:typer_kids/widgets/finger_guide.dart';
import 'package:typer_kids/widgets/stat_tiles.dart';
import 'package:typer_kids/data/story_content.dart';
import 'package:typer_kids/data/word_lists.dart';
import 'package:typer_kids/data/lesson_curriculum_selector.dart' as selected;
import 'package:typer_kids/screens/games/falling_words_screen.dart';
import 'package:typer_kids/screens/games/widgets/falling_words_views.dart';
import 'package:typer_kids/screens/games/defend_temple_screen.dart';
import 'package:typer_kids/screens/games/widgets/defend_temple_views.dart';
import 'package:typer_kids/screens/games/word_bubbles_screen.dart';
import 'package:typer_kids/screens/games/widgets/word_bubbles_views.dart';
import 'package:typer_kids/screens/games/speed_chase_screen.dart';
import 'package:typer_kids/screens/games/widgets/speed_chase_views.dart';
import 'package:typer_kids/screens/games/key_critters_screen.dart';
import 'package:typer_kids/screens/games/widgets/key_critters_views.dart';
import 'package:typer_kids/screens/games/story_sprint_screen.dart';
import 'package:typer_kids/screens/games/widgets/story_sprint_views.dart';
import 'package:typer_kids/screens/games/game_menu_screen.dart';
import 'package:typer_kids/data/sentence_lists.dart';
import 'package:typer_kids/screens/sandbox/sandbox_screen.dart';
import 'package:typer_kids/screens/test/typing_test_screen.dart';
import 'package:typer_kids/widgets/passage_typing_display.dart';
import 'package:typer_kids/screens/typing_screen.dart';
import 'package:typer_kids/widgets/home/activity_card.dart';
import 'package:typer_kids/widgets/home/stat_card.dart';
import 'package:typer_kids/widgets/profile/profile_card.dart';
import 'package:typer_kids/models/typing_stats.dart';
import 'package:typer_kids/models/lesson_progress.dart';
import 'package:typer_kids/data/lesson_curriculum.dart';
import 'package:typer_kids/models/lesson.dart';

void main() {
  testWidgets('Typing Test passage stays centered when start hint disappears', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 900);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: language,
        child: const MaterialApp(home: TypingTestScreen()),
      ),
    );
    await tester.tap(find.text('Start Test'));
    await tester.pump();
    await tester.pump();

    final passage = find.byType(PassageTypingDisplay);
    final startHint = find.ancestor(
      of: find.text('Timer starts when you begin typing!'),
      matching: find.byType(Visibility),
    );
    expect(tester.widget<Visibility>(startHint).visible, true);
    final before = tester.getCenter(passage).dy;
    final first = tester.widget<PassageTypingDisplay>(passage).text[0];
    await tester.sendKeyEvent(
      first == ' '
          ? LogicalKeyboardKey.space
          : LogicalKeyboardKey.findKeyByKeyId(first.toLowerCase().codeUnitAt(0))!,
      character: first,
    );
    await tester.pump();

    expect((tester.getCenter(passage).dy - before).abs(), lessThanOrEqualTo(1));
    expect(tester.widget<Visibility>(startHint).visible, false);
  });

  testWidgets('Free Practice passage stays centered when focus hint disappears', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1000, 900);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: language,
        child: const MaterialApp(home: SandboxScreen()),
      ),
    );
    await tester.tap(find.text('Start'));
    await tester.pump();
    await tester.pump();

    final passage = find.byType(PassageTypingDisplay);
    final typingFocus = tester
        .widget<KeyboardListener>(find.byType(KeyboardListener))
        .focusNode;
    typingFocus.unfocus();
    await tester.pump();
    final focusHint = find.ancestor(
      of: find.text('Click here and start typing!'),
      matching: find.byType(Visibility),
    );
    expect(tester.widget<Visibility>(focusHint).visible, true);
    final before = tester.getCenter(passage).dy;
    typingFocus.requestFocus();
    await tester.pump();
    final first = tester.widget<PassageTypingDisplay>(passage).text[0];
    await tester.sendKeyEvent(
      first == ' '
          ? LogicalKeyboardKey.space
          : LogicalKeyboardKey.findKeyByKeyId(first.toLowerCase().codeUnitAt(0))!,
      character: first,
    );
    await tester.pump();

    expect((tester.getCenter(passage).dy - before).abs(), lessThanOrEqualTo(1));
    expect(tester.widget<Visibility>(focusHint).visible, false);
  });

  testWidgets('Dutch finger guide fits lesson slot', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');

    for (final (key, label) in [
      (' ', 'Duim 👍'),
      ('€', 'Linkerringvinger 💍 + AltGr'),
    ]) {
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: language,
          child: MaterialApp(
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.2),
              ),
              child: child!,
            ),
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  key: const ValueKey('lesson-guide-slot'),
                  height: 114,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: FingerGuide(currentKey: key),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(FingerGuide),
          matching: find.byType(CustomPaint),
        ),
        findsNWidgets(2),
      );
      expect(find.text(label), findsOneWidget);
      expect(
        tester.getBottomRight(find.text(label)).dy,
        lessThanOrEqualTo(
          tester
              .getBottomRight(find.byKey(const ValueKey('lesson-guide-slot')))
              .dy,
        ),
      );
    }
    selected.LessonCurriculum.isDutch = false;
  });

  testWidgets('Unlisted Dutch accents do not map to a physical key', (
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
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                KeyboardWidget(activeKey: 'É', keySize: 26),
                FingerGuide(currentKey: 'É'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('´'), findsNothing);
    expect(find.text('⇧'), findsNWidgets(2));
    expect(find.text('SPATIE'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await language.select('en');
    await tester.pump();
    expect(find.text('´'), findsNothing);
    expect(find.text('SPACE'), findsOneWidget);
    selected.LessonCurriculum.isDutch = false;
  });

  testWidgets('Dutch euro guidance shows the physical 2 key and AltGr', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: language,
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                KeyboardWidget(activeKey: '€', keySize: 26),
                FingerGuide(currentKey: '€'),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('2 €'), findsOneWidget);
    expect(
      find.bySemanticsLabel('Volgende toets: 2 voor € met AltGr'),
      findsOneWidget,
    );
    expect(find.textContaining('AltGr'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
    selected.LessonCurriculum.isDutch = false;
  });

  testWidgets('Dutch punctuation highlights the mapped key and left Shift', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: language,
        child: const MaterialApp(
          home: Scaffold(body: KeyboardWidget(activeKey: ':', keySize: 26)),
        ),
      ),
    );
    expect(
      find.bySemanticsLabel('Volgende toets: ; voor : met Shift'),
      findsOneWidget,
    );
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('Linker Shift'))
          .getSemanticsData()
          .flagsCollection
          .isSelected
          .toBoolOrNull(),
      isTrue,
    );
    expect(
      tester
          .getSemantics(find.bySemanticsLabel('Rechter Shift'))
          .getSemanticsData()
          .flagsCollection
          .isSelected
          .toBoolOrNull(),
      isFalse,
    );
    semantics.dispose();
    selected.LessonCurriculum.isDutch = false;
  });

  testWidgets(
    'lesson prompt stays positioned through finger guide transitions',
    (tester) async {
      GoogleFonts.config.allowRuntimeFetching = false;
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 900);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      SharedPreferences.setMockInitialValues({});

      final language = LanguageProvider();
      await language.init();
      final progress = ProgressProvider();
      await progress.init();
      const lesson = Lesson(
        id: 'prompt-position-test',
        title: 'Prompt position',
        description: '',
        category: LessonCategory.homeRow,
        difficulty: LessonDifficulty.beginner,
        orderIndex: 1,
        focusKeys: ['f'],
        exercises: ['f é', 'f'],
      );

      Future<void> startLesson() async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: language),
              ChangeNotifierProvider.value(value: progress),
            ],
            child: MaterialApp(home: TypingScreen(lesson: lesson)),
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text("Let's Go!"));
        await tester.tap(find.text("Let's Go!"));
        await tester.pumpAndSettle();
      }

      Future<void> typeCharacter(String character) async {
        await tester.sendKeyEvent(
          character == ' ' ? LogicalKeyboardKey.space : LogicalKeyboardKey.keyF,
          character: character,
        );
        await tester.pump();
      }

      final prompt = find.byType(TypingDisplay);
      void expectPromptAt(double y) {
        expect(tester.getCenter(prompt).dy, closeTo(y, 0.1));
      }

      await startLesson();
      expect(find.byType(FingerGuide), findsOneWidget);
      final tallPromptY = tester.getCenter(prompt).dy;
      await typeCharacter('f');
      expectPromptAt(tallPromptY);
      expect(
        tester.widget<FingerGuide>(find.byType(FingerGuide)).currentKey,
        ' ',
      );
      await typeCharacter(' ');
      expectPromptAt(tallPromptY);
      expect(
        tester.widget<FingerGuide>(find.byType(FingerGuide)).currentKey,
        'é',
      );
      expect(KeyboardData.keyToFinger['é'], isNull);
      await typeCharacter('é');
      expectPromptAt(tallPromptY);
      expect(
        tester.widget<TypingDisplay>(prompt).charStates.last.name,
        'correct',
      );
      await tester.pump(const Duration(milliseconds: 499));
      expectPromptAt(tallPromptY);
      await tester.pump(const Duration(milliseconds: 1));
      expectPromptAt(tallPromptY);
      await typeCharacter('f');
      expectPromptAt(tallPromptY);
      expect(
        tester.widget<TypingDisplay>(prompt).charStates.last.name,
        'correct',
      );
      await tester.pump(const Duration(milliseconds: 299));
      expectPromptAt(tallPromptY);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));

      tester.view.physicalSize = const Size(640, 480);
      await startLesson();
      expect(find.byType(FingerGuide), findsNothing);
      final shortPromptY = tester.getCenter(prompt).dy;
      await typeCharacter('f');
      expectPromptAt(shortPromptY);
      await typeCharacter(' ');
      expectPromptAt(shortPromptY);
      await typeCharacter('é');
      expectPromptAt(shortPromptY);
      await tester.pump(const Duration(milliseconds: 499));
      expectPromptAt(shortPromptY);
      await tester.pump(const Duration(milliseconds: 1));
      expectPromptAt(shortPromptY);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
      progress.dispose();
      language.dispose();
    },
  );

  testWidgets('Dutch lesson keyboard fits a narrow typing viewport', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      selected.LessonCurriculum.isDutch = false;
    });
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
    expect(tester.takeException(), isNull, reason: 'Dutch home');
    await tester.ensureVisible(find.text('Letters oefenen'));
    await tester.tap(find.text('Letters oefenen'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Dutch lesson intro');
    await tester.tap(find.text('Begin!'));
    await tester.pumpAndSettle();
    expect(find.byType(KeyboardWidget), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'Dutch typing');
    final focusNode = tester
        .widget<KeyboardListener>(
          find
              .ancestor(
                of: find.byType(TypingDisplay),
                matching: find.byType(KeyboardListener),
              )
              .first,
        )
        .focusNode;
    final promptVisibility = find
        .ancestor(
          of: find.text('Klik hier en begin met typen!'),
          matching: find.byType(Visibility),
        )
        .first;
    expect(tester.widget<Visibility>(promptVisibility).visible, isTrue);
    focusNode.unfocus();
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isFalse, reason: 'typing area loses focus');
    expect(tester.widget<Visibility>(promptVisibility).visible, isTrue);
    final textBounds = tester.getRect(find.byType(TypingDisplay));
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(tester.widget<Visibility>(promptVisibility).visible, isTrue);
    expect(tester.getRect(find.byType(TypingDisplay)), textBounds);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyF);
    await tester.pumpAndSettle();
    expect(tester.widget<Visibility>(promptVisibility).visible, isFalse);
    expect(tester.getRect(find.byType(TypingDisplay)), textBounds);
    focusNode.unfocus();
    await tester.pumpAndSettle();
    expect(tester.widget<Visibility>(promptVisibility).visible, isTrue);
    expect(tester.getRect(find.byType(TypingDisplay)), textBounds);
    await tester.tap(find.byType(TypingDisplay));
    await tester.pumpAndSettle();
    expect(tester.widget<Visibility>(promptVisibility).visible, isFalse);
    expect(tester.getRect(find.byType(TypingDisplay)), textBounds);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
  });

  testWidgets('Dutch locked lesson URL opens only after prior lessons', (
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
    GoRouter.of(
      tester.element(find.text('Typer Kids')),
    ).go('/lesson/nl-letter-03');
    await tester.pumpAndSettle();
    expect(find.text('Begin!'), findsNothing);
    final stats = TypingStats(
      totalCharacters: 10,
      correctCharacters: 10,
      incorrectCharacters: 0,
      elapsed: const Duration(seconds: 30),
      completedAt: DateTime(2026, 9, 28),
    );
    await progress.recordAttempt(DutchCurriculum.allLessons[0], stats);
    await progress.recordAttempt(DutchCurriculum.allLessons[1], stats);
    final router = GoRouter.of(tester.element(find.text('Typer Kids')));
    router.go('/');
    await tester.pumpAndSettle();
    router.go('/lesson/nl-letter-03');
    await tester.pumpAndSettle();
    expect(find.text('Begin!'), findsOneWidget);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    selected.LessonCurriculum.isDutch = false;
  });

  testWidgets(
    'Dutch lesson list shows the localized Letters category in stage order',
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
      GoRouter.of(tester.element(find.text('Typer Kids'))).go('/lessons');
      await tester.pumpAndSettle();
      expect(find.text('Letters'), findsOneWidget);
      expect(find.text('Thuisrij'), findsNothing);
      final titles = DutchCurriculum.allLessons.map((l) => l.title).toList();
      for (final title in titles) {
        expect(find.text(title), findsOneWidget);
      }
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      selected.LessonCurriculum.isDutch = false;
    },
  );

  test('Dutch ISO mappings differ from English and reject unknown keys', () {
    expect(KeyboardData.dutchBaseKey('!'), '1');
    expect(KeyboardData.dutchBaseKey('?'), '/');
    expect(KeyboardData.dutchBaseKey('"'), "'");
    expect(KeyboardData.dutchBaseKey(':'), ';');
    expect(KeyboardData.dutchBaseKey('|'), '\\');
    expect(KeyboardData.dutchBaseKey('~'), '`');
    expect(KeyboardData.dutchBaseKey('é'), isNull);
    expect(KeyboardData.dutchBaseKey('€'), '2');
    expect(KeyboardData.dutchNeedsAltGr('€'), true);
    expect(KeyboardData.baseKey('?'), '/');
    expect(KeyboardData.keyboardRows[0].first, '`');
    expect(KeyboardData.dutchRows[0].first, '§');
  });

  testWidgets('Every bundled font face is present and readable offline', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    const weightNames = {
      400: 'Regular',
      500: 'Medium',
      600: 'SemiBold',
      700: 'Bold',
      800: 'ExtraBold',
    };
    Future<void> verifyTtfFace({
      required String family,
      required String filePrefix,
      required int weight,
      FontStyle fontStyle = FontStyle.normal,
    }) async {
      final styleName = fontStyle == FontStyle.italic
          ? 'Italic'
          : weightNames[weight]!;
      final path = 'assets/fonts/$filePrefix-$styleName.ttf';
      final diagnostic = '$family weight $weight $fontStyle at $path';
      expect(manifest.listAssets(), contains(path), reason: diagnostic);
      final bytes = await rootBundle.load(path);
      expect(bytes.lengthInBytes, greaterThan(12), reason: diagnostic);
      expect(bytes.getUint32(0), 0x00010000, reason: diagnostic);
      final tableCount = bytes.getUint16(4);
      expect(tableCount, greaterThan(0), reason: diagnostic);
      expect(
        bytes.lengthInBytes,
        greaterThanOrEqualTo(12 + tableCount * 16),
        reason: diagnostic,
      );
      var foundWeight = false;
      for (var table = 0; table < tableCount; table++) {
        final record = 12 + table * 16;
        final offset = bytes.getUint32(record + 8);
        final length = bytes.getUint32(record + 12);
        expect(
          offset + length,
          lessThanOrEqualTo(bytes.lengthInBytes),
          reason: diagnostic,
        );
        if (bytes.getUint32(record) == 0x4f532f32) {
          expect(length, greaterThanOrEqualTo(6), reason: diagnostic);
          expect(bytes.getUint16(offset + 4), weight, reason: diagnostic);
          foundWeight = true;
        }
      }
      expect(
        foundWeight,
        true,
        reason: 'Missing OS/2 weight table for $diagnostic',
      );
      GoogleFonts.getFont(
        family,
        fontWeight: FontWeight.values[weight ~/ 100 - 1],
        fontStyle: fontStyle,
      );
    }

    final faces = {
      ('Fredoka', 'Fredoka'): [400, 500, 600, 700],
      ('Nunito', 'Nunito'): [400, 500, 600, 700, 800],
      ('JetBrains Mono', 'JetBrainsMono'): [400, 500, 600, 700],
      ('Roboto Mono', 'RobotoMono'): [400, 500, 600, 700],
    };
    for (final entry in faces.entries) {
      for (final weight in entry.value) {
        await verifyTtfFace(
          family: entry.key.$1,
          filePrefix: entry.key.$2,
          weight: weight,
        );
      }
    }
    await verifyTtfFace(
      family: 'Nunito',
      filePrefix: 'Nunito',
      weight: 400,
      fontStyle: FontStyle.italic,
    );
    final fallbackPaths = [
      for (var subset = 0; subset < 12; subset++)
        'assets/fonts/fallback/notocoloremoji/v32/'
            'Yq6P-KqIXTD0t4D9z1ESnKM3-HpFabsE4tq3luCC7p-aXxcn.$subset.woff2',
      ...const [
        'I_uyMoGduATTei9eI8daxVHDyfisHr71-jrBWXPM4Q.woff2',
        'I_uyMoGduATTei9eI8daxVHDyfisHr71-ujgfE71.woff2',
        'I_uyMoGduATTei9eI8daxVHDyfisHr71-gTBWXPM4Q.woff2',
        'I_uyMoGduATTei9eI8daxVHDyfisHr71-vrgfE71.woff2',
        'I_uyMoGduATTei9eI8daxVHDyfisHr71-prgfE71.woff2',
        'I_uyMoGduATTei9eI8daxVHDyfisHr71-pTgfA.woff2',
      ].map((file) => 'assets/fonts/fallback/notosanssymbols2/v24/$file'),
    ];
    for (final path in fallbackPaths) {
      final diagnostic = 'Flutter fallback font at $path';
      expect(manifest.listAssets(), contains(path), reason: diagnostic);
      final bytes = await rootBundle.load(path);
      expect(bytes.lengthInBytes, greaterThan(48), reason: diagnostic);
      expect(bytes.getUint32(0), 0x774f4632, reason: diagnostic);
    }
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Text('Fredoka', style: GoogleFonts.fredoka()),
            Text('Nunito', style: GoogleFonts.nunito()),
            Text(
              'Nunito Italic',
              style: GoogleFonts.nunito(fontStyle: FontStyle.italic),
            ),
            Text('JetBrains Mono', style: GoogleFonts.jetBrainsMono()),
            Text('Roboto Mono', style: GoogleFonts.robotoMono()),
          ],
        ),
      ),
    );
    await tester.runAsync(GoogleFonts.pendingFonts);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(GoogleFonts.config.allowRuntimeFetching, false);
  });

  for (final languageCode in ['en', 'nl']) {
    for (final viewport in [const Size(390, 844), const Size(1280, 900)]) {
      testWidgets('Offline $languageCode screens at $viewport', (tester) async {
        GoogleFonts.config.allowRuntimeFetching = false;
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = viewport;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
          selected.LessonCurriculum.isDutch = false;
        });
        SharedPreferences.setMockInitialValues({});
        final profile = ProfileProvider();
        await profile.init();
        final child = await profile.createProfile(name: 'Noor', emoji: '🌱');
        final language = LanguageProvider();
        await language.init();
        await language.select(languageCode);
        final progress = ProgressProvider();
        await progress.init(profileId: child.id, language: languageCode);
        await tester.pumpWidget(
          startup.TyperKidsApp(
            profileProvider: profile,
            progressProvider: progress,
            languageProvider: language,
          ),
        );
        await tester.pumpAndSettle();
        await tester.runAsync(GoogleFonts.pendingFonts);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '$languageCode home at $viewport',
        );
        expect(find.text('Typer Kids'), findsOneWidget);
        expect(
          tester.widget<Text>(find.text('Typer Kids')).style?.fontFamily,
          'Fredoka_700',
        );

        await tester.ensureVisible(find.byType(ActionChip));
        await tester.tap(find.byType(ActionChip));
        await tester.pumpAndSettle();
        await tester.runAsync(GoogleFonts.pendingFonts);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '$languageCode profile at $viewport',
        );
        expect(find.byType(ProfileCard), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.text(
            languageCode == 'nl' ? 'Letters oefenen' : 'Start Learning!',
          ),
        );
        await tester.tap(
          find.text(
            languageCode == 'nl' ? 'Letters oefenen' : 'Start Learning!',
          ),
        );
        await tester.pumpAndSettle();
        await tester.runAsync(GoogleFonts.pendingFonts);
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '$languageCode lesson at $viewport',
        );
        expect(
          find.text(languageCode == 'nl' ? 'Begin!' : "Let's Go!"),
          findsOneWidget,
        );
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      });
    }
  }

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
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Dutch'), findsOneWidget);
      await tester.tap(find.text('Dutch'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Dutch Settings');
      expect(language.isDutch, true);
      expect(progress.language, 'nl');
      expect(find.text('Instellingen'), findsOneWidget);
      expect(find.text('Engels'), findsOneWidget);
      expect(find.text('Nederlands'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Dutch home');
      expect(find.textContaining('Noor'), findsWidgets);
      expect(find.text('🐵'), findsOneWidget);
      expect(find.byType(ActivityCard), findsNWidgets(3));
      expect(find.byType(StatCard), findsNWidgets(4));
      expect(find.text('Typspellen'), findsOneWidget);
      expect(find.text('Vrij oefenen'), findsOneWidget);
      expect(find.text('Typetest'), findsOneWidget);
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
      final exercises = DutchCurriculum.allLessons.first.exercises;
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
      expect(progress.getProgress('nl-letter-01').completed, true);
      expect(find.text('Goed gedaan!'), findsOneWidget);
      for (final lesson in DutchCurriculum.allLessons.skip(1)) {
        expect(find.textContaining('Volgende:'), findsOneWidget);
        await tester.ensureVisible(find.textContaining('Volgende:'));
        await tester.tap(find.textContaining('Volgende:'));
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Begin!'), findsOneWidget);
        await tester.tap(find.text('Begin!'));
        await tester.pump();
        for (final exercise in lesson.exercises) {
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
        expect(progress.getProgress(lesson.id).completed, true);
        expect(find.text('Goed gedaan!'), findsOneWidget);
      }
      expect(find.textContaining('Volgende:'), findsNothing);
      final restarted = LanguageProvider();
      await restarted.init();
      final loaded = ProgressProvider();
      await loaded.init(profileId: child.id, language: restarted.language);
      expect(loaded.getProgress('nl-letter-01').completed, true);
      expect(loaded.completedLessons, 16);
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      selected.LessonCurriculum.isDutch = false;
    },
  );
  testWidgets('Cold startup restores the Dutch home and lesson progress', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = true;
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
      DutchCurriculum.allLessons.first,
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
    expect(GoogleFonts.config.allowRuntimeFetching, false);
    final licensedFamilies = <String>{};
    await for (final license in LicenseRegistry.licenses) {
      licensedFamilies.addAll(license.packages);
    }
    expect(
      licensedFamilies,
      containsAll([
        'Fredoka',
        'Nunito',
        'JetBrains Mono',
        'Roboto Mono',
        'Noto Color Emoji',
        'Noto Sans Symbols 2',
      ]),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Leer typen met plezier! 🎮'), findsOneWidget);
    expect(find.text('1/16'), findsOneWidget);
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
    await tester.ensureVisible(find.text('🎲 Verras mij!'));
    await tester.tap(find.text('🎲 Verras mij!'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('De jas in de boom').last);
    await tester.pumpAndSettle();
    expect(find.text('The Little Red Hen'), findsNothing);
    expect(find.text('Kies een niveau'), findsNothing);
    await tester.ensureVisible(find.text('Begin'));
    await tester.tap(find.text('Begin'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('De jas in de boom'), findsOneWidget);
    expect(find.text('Voortgang'), findsOneWidget);
    for (final (index, character)
        in StoryContent.dutch.text.split('').indexed) {
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
    expect(find.text('WPM'), findsOneWidget);
    final wpmTile = find.ancestor(
      of: find.text('WPM'),
      matching: find.byType(EmojiStatTile),
    );
    expect(
      double.parse(tester.widget<EmojiStatTile>(wpmTile).value),
      greaterThan(0),
    );
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
    final semantics = tester.ensureSemantics();
    expect(
      find.bySemanticsLabel('Makkelijk niveau. Korte woorden. Toets 1'),
      findsOneWidget,
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
    semantics.dispose();
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Falling Words uses medium and hard selections', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'game-child', language: 'nl');
    for (final difficulty in [
      ContentDifficulty.medium,
      ContentDifficulty.hard,
    ]) {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: language),
            ChangeNotifierProvider.value(value: progress),
          ],
          child: const MaterialApp(home: FallingWordsScreen()),
        ),
      );
      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.tap(find.text('Start spel'));
      await tester.pump();
      for (var frame = 0; frame < 20; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final words = WordLists.forDifficulty(difficulty);
      expect(
        tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data)
            .any((text) => words.contains(text)),
        isTrue,
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pump(const Duration(milliseconds: 600));
    }
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Defend the Temple records a separate score on game over', (
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
        child: const MaterialApp(home: DefendTempleScreen()),
      ),
    );
    expect(find.text('Verdedig de Tempel'), findsOneWidget);
    expect(find.text('Kies een niveau'), findsOneWidget);
    await tester.tap(find.text('Verdedig!'));
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
    for (
      var frame = 0;
      frame < 4000 && find.byType(DefendTempleGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(DefendTempleGameOver), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('Tempel gevallen!'), findsOneWidget);
    expect(find.text('punten'), findsOneWidget);
    expect(progress.getHighScore('defend_temple'), word.length * 10);
    await progress.switchLanguage('en');
    expect(progress.getHighScore('defend_temple'), 0);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(milliseconds: 600));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Defend the Temple uses medium and hard selections', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'game-child', language: 'nl');
    for (final difficulty in [
      ContentDifficulty.medium,
      ContentDifficulty.hard,
    ]) {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: language),
            ChangeNotifierProvider.value(value: progress),
          ],
          child: const MaterialApp(home: DefendTempleScreen()),
        ),
      );
      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.tap(find.text('Verdedig!'));
      await tester.pump();
      for (var frame = 0; frame < 20; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final words = WordLists.forDifficulty(difficulty);
      expect(
        tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data)
            .any((text) => words.contains(text)),
        isTrue,
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pump(const Duration(milliseconds: 600));
    }
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Word Bubbles records a separate score on game over', (
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
        child: const MaterialApp(home: WordBubblesScreen()),
      ),
    );
    expect(find.text('Woordbubbels'), findsOneWidget);
    expect(find.text('Kies een niveau'), findsOneWidget);
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
    expect(find.text('✓ Gepakt!'), findsOneWidget);
    for (
      var frame = 0;
      frame < 4000 && find.byType(WordBubblesGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(WordBubblesGameOver), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('Tijd voorbij!'), findsOneWidget);
    expect(find.text('punten'), findsOneWidget);
    expect(progress.getHighScore('word_bubbles'), greaterThan(0));
    await progress.switchLanguage('en');
    expect(progress.getHighScore('word_bubbles'), 0);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(milliseconds: 600));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Word Bubbles uses medium and hard selections', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'game-child', language: 'nl');
    for (final difficulty in [
      ContentDifficulty.medium,
      ContentDifficulty.hard,
    ]) {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: language),
            ChangeNotifierProvider.value(value: progress),
          ],
          child: const MaterialApp(home: WordBubblesScreen()),
        ),
      );
      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.tap(find.text('Start spel'));
      await tester.pump();
      for (var frame = 0; frame < 20; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      final words = WordLists.forDifficulty(difficulty);
      expect(
        tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data)
            .any((text) => words.contains(text)),
        isTrue,
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pump(const Duration(milliseconds: 600));
    }
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Speed Chase records a separate score on game over', (
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
        child: const MaterialApp(home: SpeedChaseScreen()),
      ),
    );
    expect(find.text('Snelheidsrace'), findsOneWidget);
    expect(find.text('Kies een niveau'), findsOneWidget);
    await tester.tap(find.text('Start race'));
    await tester.pump();
    expect(tester.takeException(), isNull);

    String currentWord() {
      return tester
          .widgetList<RichText>(find.byType(RichText))
          .map((w) => w.text.toPlainText())
          .firstWhere((text) => WordLists.dutchEasy.contains(text));
    }

    for (var i = 0; i < 15; i++) {
      final word = currentWord();
      for (final character in word.split('')) {
        await tester.sendKeyEvent(
          LogicalKeyboardKey.keyA,
          character: character,
        );
        await tester.pump();
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
    }
    for (
      var frame = 0;
      frame < 4000 && find.byType(SpeedChaseGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(SpeedChaseGameOver), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('Je hebt gewonnen!'), findsOneWidget);
    expect(find.text('punten'), findsOneWidget);
    expect(progress.getHighScore('speed_chase'), greaterThan(0));
    await progress.switchLanguage('en');
    expect(progress.getHighScore('speed_chase'), 0);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(milliseconds: 600));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Speed Chase uses medium and hard selections', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'game-child', language: 'nl');
    for (final difficulty in [
      ContentDifficulty.medium,
      ContentDifficulty.hard,
    ]) {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: language),
            ChangeNotifierProvider.value(value: progress),
          ],
          child: const MaterialApp(home: SpeedChaseScreen()),
        ),
      );
      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.tap(find.text('Start race'));
      await tester.pump();
      final words = WordLists.forDifficulty(difficulty);
      expect(
        tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data)
            .any((text) => text != null && words.contains(text)),
        isTrue,
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pump(const Duration(milliseconds: 600));
    }
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Key Critters records a separate score on game over', (
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
        child: const MaterialApp(home: KeyCrittersScreen()),
      ),
    );
    expect(find.text('Toetsbeestjes'), findsOneWidget);
    expect(find.text('Kies een niveau'), findsOneWidget);
    await tester.tap(find.text('Begin met bonken'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    for (var frame = 0; frame < 10; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    const easyKeys = 'asdfghjkl';
    final letter = tester
        .widgetList<Text>(find.byType(Text))
        .map((text) => text.data)
        .firstWhere(
          (text) =>
              text != null &&
              text.length == 1 &&
              easyKeys.contains(text.toLowerCase()),
        )!;
    await tester.sendKeyEvent(
      LogicalKeyboardKey.keyA,
      character: letter.toLowerCase(),
    );
    await tester.pump();
    for (
      var frame = 0;
      frame < 700 && find.byType(KeyCrittersGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(KeyCrittersGameOver), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('Tuin gesloten!'), findsOneWidget);
    expect(find.text('punten'), findsOneWidget);
    expect(progress.getHighScore('key_critters'), greaterThan(0));
    await progress.switchLanguage('en');
    expect(progress.getHighScore('key_critters'), 0);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(milliseconds: 600));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Story Sprint records a separate score on game over', (
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
        child: const MaterialApp(home: StorySprintScreen()),
      ),
    );
    expect(find.text('Verhaalsprint'), findsOneWidget);
    expect(find.text('Kies een niveau'), findsOneWidget);
    await tester.tap(find.text('Begin met rennen'));
    await tester.pump();
    expect(tester.takeException(), isNull);

    final sentence = tester
        .widgetList<RichText>(find.byType(RichText))
        .map((w) => w.text.toPlainText())
        .firstWhere((text) => SentenceLists.dutchEasy.contains(text));
    for (final character in sentence.split('')) {
      await tester.sendKeyEvent(LogicalKeyboardKey.keyA, character: character);
      await tester.pump();
    }
    for (
      var frame = 0;
      frame < 1000 && find.byType(StorySprintGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(StorySprintGameOver), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('Race afgelopen!'), findsOneWidget);
    expect(find.text('punten'), findsOneWidget);
    expect(progress.getHighScore('story_sprint'), greaterThan(0));
    await progress.switchLanguage('en');
    expect(progress.getHighScore('story_sprint'), 0);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pump(const Duration(milliseconds: 600));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch Story Sprint uses medium and hard selections', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    final language = LanguageProvider();
    await language.init();
    await language.select('nl');
    final progress = ProgressProvider();
    await progress.init(profileId: 'game-child', language: 'nl');
    for (final difficulty in [
      ContentDifficulty.medium,
      ContentDifficulty.hard,
    ]) {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: language),
            ChangeNotifierProvider.value(value: progress),
          ],
          child: const MaterialApp(home: StorySprintScreen()),
        ),
      );
      await tester.tap(find.text(difficulty.dutchLabel));
      await tester.tap(find.text('Begin met rennen'));
      await tester.pump();
      final sentences = SentenceLists.forDifficulty(difficulty);
      expect(
        tester
            .widgetList<RichText>(find.byType(RichText))
            .map((w) => w.text.toPlainText())
            .any((text) => sentences.contains(text)),
        isTrue,
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pump(const Duration(milliseconds: 600));
    }
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch game menu shows all six localized games', (tester) async {
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
        child: const MaterialApp(home: GameMenuScreen()),
      ),
    );
    expect(find.text('Typspellen'), findsOneWidget);
    expect(find.text('Veel plezier tijdens het oefenen!'), findsOneWidget);
    expect(find.text('Verdedig de Tempel'), findsOneWidget);
    expect(find.text('Vallende woorden'), findsOneWidget);
    expect(find.text('Woordbubbels'), findsOneWidget);
    expect(find.text('Snelheidsrace'), findsOneWidget);
    expect(find.text('Toetsbeestjes'), findsOneWidget);
    expect(find.text('Verhaalsprint'), findsOneWidget);
    expect(find.text('Terug'), findsOneWidget);
    for (final english in [
      'Defend the Temple',
      'Falling Words',
      'Word Bubbles',
      'Speed Chase',
      'Key Critters',
      'Story Sprint',
      'Typing Games',
      'Back',
    ]) {
      expect(find.text(english), findsNothing, reason: english);
    }
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    selected.LessonCurriculum.isDutch = false;
  });
  testWidgets('Dutch game and story route returns to saved English progress', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    addTearDown(() => selected.LessonCurriculum.isDutch = false);
    final profile = ProfileProvider();
    await profile.init();
    final child = await profile.createProfile(name: 'Noor', emoji: '🌱');
    final language = LanguageProvider();
    await language.init();
    final progress = ProgressProvider();
    await progress.init(profileId: child.id);
    final english = selected.LessonCurriculum.allLessons.first;
    await progress.recordAttempt(
      english,
      TypingStats(
        totalCharacters: 10,
        correctCharacters: 10,
        incorrectCharacters: 0,
        elapsed: const Duration(seconds: 30),
        completedAt: DateTime(2026, 9, 28),
      ),
    );
    await language.select('nl');
    await progress.switchLanguage('nl');
    await tester.pumpWidget(
      startup.TyperKidsApp(
        profileProvider: profile,
        progressProvider: progress,
        languageProvider: language,
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Typspellen'));
    await tester.tap(find.text('Typspellen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vallende woorden'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start spel'));
    await tester.pump();
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
    for (
      var frame = 0;
      frame < 4000 && find.byType(FallingWordsGameOver).evaluate().isEmpty;
      frame++
    ) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Spel afgelopen!'), findsOneWidget);
    expect(progress.getHighScore('falling_words'), word.length * 10);
    final router = GoRouter.of(
      tester.element(find.byType(FallingWordsGameOver)),
    );
    router.go('/');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Vrij oefenen'));
    await tester.tap(find.text('Vrij oefenen'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('🎲 Verras mij!'));
    await tester.tap(find.text('🎲 Verras mij!'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('De jas in de boom').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Begin'));
    await tester.tap(find.text('Begin'));
    await tester.pump();
    for (final character in StoryContent.dutch.text.split('')) {
      await tester.sendKeyEvent(
        character == ' ' ? LogicalKeyboardKey.space : LogicalKeyboardKey.keyA,
        character: character,
      );
      await tester.pump();
    }
    expect(find.text('Goed gedaan!'), findsOneWidget);
    expect(find.text('Nauwkeurigheid'), findsOneWidget);
    expect(find.text('100.0%'), findsOneWidget);
    router.go('/settings');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Engels'));
    await tester.pumpAndSettle();
    expect(language.isDutch, isFalse);
    expect(progress.getProgress(english.id).completed, isTrue);
    router.go('/lesson/${english.id}');
    await tester.pumpAndSettle();
    expect(find.text("Let's Go!"), findsOneWidget);
    final restarted = LanguageProvider();
    await restarted.init();
    expect(restarted.language, 'en');
    final loaded = ProgressProvider();
    await loaded.init(profileId: child.id, language: restarted.language);
    expect(loaded.getProgress(english.id).completed, isTrue);
    await loaded.switchLanguage('nl');
    expect(loaded.getProgress(english.id).completed, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
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
