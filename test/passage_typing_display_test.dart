import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typer_kids/providers/typing_provider.dart';
import 'package:typer_kids/widgets/passage_typing_display.dart';

const _accent = Color(0xFF4A6CF7);

void main() {
  testWidgets('passage spans keep the real space in every state', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    for (final state in CharState.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: PassageTypingDisplay(
            text: 'a b',
            charStates: [CharState.correct, state, CharState.pending],
            cursorPosition: 1,
            accentColor: _accent,
          ),
        ),
      );
      await tester.runAsync(GoogleFonts.pendingFonts);
      await tester.pumpAndSettle();

      final rendered = tester
          .widgetList<RichText>(find.byType(RichText))
          .map((widget) => widget.text.toPlainText())
          .join();
      expect(rendered, contains('a '), reason: state.name);
      expect(rendered, isNot(contains('␣')), reason: state.name);
    }
  });

  testWidgets('separate word chunks can show multiple cued spaces', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await tester.pumpWidget(
      MaterialApp(
        home: PassageTypingDisplay(
          text: 'a b c d',
          charStates: const [
            CharState.correct,
            CharState.incorrect,
            CharState.correct,
            CharState.incorrect,
            CharState.correct,
            CharState.current,
            CharState.pending,
          ],
          cursorPosition: 5,
          accentColor: _accent,
        ),
      ),
    );
    await tester.runAsync(GoogleFonts.pendingFonts);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('space-cue-incorrect-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('space-cue-incorrect-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('space-cue-current-4')), findsOneWidget);
  });

  testWidgets('windowed long passages still cue the right space', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final words = List.filled(800, 'word');
    final text = words.join(' ');
    // Longer than _windowBehind + _windowAhead, so the window actually slides.
    expect(text.length, greaterThan(1100));

    Future<void> pumpAt(int cursor) async {
      expect(text[cursor], ' ');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 400,
              child: PassageTypingDisplay(
                text: text,
                charStates: [
                  for (var i = 0; i < text.length; i++)
                    if (i < cursor)
                      CharState.correct
                    else if (i == cursor)
                      CharState.current
                    else
                      CharState.pending,
                ],
                cursorPosition: cursor,
                accentColor: _accent,
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(GoogleFonts.pendingFonts);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      // The chunk holding the cursor starts at that word's first letter.
      expect(
        find.byKey(ValueKey('space-cue-current-${cursor - 4}')),
        findsOneWidget,
      );
    }

    // Cursor sits on the space after the 200th word, then on one far enough
    // ahead that the rendered window no longer overlaps the first.
    await pumpAt(200 * 5 - 1);
    await pumpAt(600 * 5 - 1);
  });

  testWidgets('a cued space outside the first chunk is still painted', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;

    final boundaryKey = GlobalKey();
    Uint8List? pendingPixels;
    // The cued space is at index 3, inside the chunk starting at index 2 —
    // so a chunk-relative cue offset is the only one that finds it.
    for (final spaceState in [CharState.pending, CharState.current]) {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 400,
            child: RepaintBoundary(
              key: boundaryKey,
              child: PassageTypingDisplay(
                text: 'a b c',
                charStates: [
                  CharState.correct,
                  CharState.correct,
                  CharState.correct,
                  spaceState,
                  CharState.pending,
                ],
                cursorPosition: 3,
                accentColor: _accent,
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(GoogleFonts.pendingFonts);
      await tester.pumpAndSettle();

      final chunk = find.byType(RichText).at(1);
      final paragraph = tester.renderObject<RenderParagraph>(chunk);
      expect(paragraph.text.toPlainText(), 'b ');
      final box = paragraph
          .getBoxesForSelection(
            const TextSelection(baseOffset: 1, extentOffset: 2),
          )
          .single
          .toRect();
      final origin =
          tester.getTopLeft(chunk) - tester.getTopLeft(find.byKey(boundaryKey));
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;

      await tester.runAsync(() async {
        final image = await boundary.toImage();
        final pixels = await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        if (spaceState == CharState.pending) {
          pendingPixels = pixels!.buffer.asUint8List();
        } else {
          var changed = 0;
          for (
            var y = (origin.dy + box.top).ceil();
            y < (origin.dy + box.bottom).floor();
            y++
          ) {
            for (
              var x = (origin.dx + box.left).ceil();
              x < (origin.dx + box.right).floor();
              x++
            ) {
              final offset = (y * image.width + x) * 4;
              if (pixels!.getUint8(offset) != pendingPixels![offset]) changed++;
            }
          }
          expect(
            changed,
            greaterThan(4),
            reason: 'The cue must paint inside the second chunk\'s space',
          );
        }
        image.dispose();
      });
    }
  });

  for (final fontSize in [22.0, 28.0]) {
    testWidgets('space feedback keeps passage text in place at $fontSize', (
      tester,
    ) async {
      GoogleFonts.config.allowRuntimeFetching = false;

      final boundaryKey = GlobalKey();
      final positions = <double>[];
      final chunkBounds = <Rect>[];
      Uint8List? pendingPixels;
      for (final states in [
        [CharState.current, CharState.pending, CharState.pending],
        [CharState.pending, CharState.pending, CharState.pending],
        [CharState.correct, CharState.pending, CharState.pending],
        [CharState.correct, CharState.correct, CharState.pending],
        [CharState.correct, CharState.current, CharState.pending],
        [CharState.correct, CharState.incorrect, CharState.pending],
        [CharState.correct, CharState.correct, CharState.current],
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            home: SizedBox(
              width: 400,
              child: RepaintBoundary(
                key: boundaryKey,
                child: PassageTypingDisplay(
                  text: 'a b',
                  charStates: states,
                  cursorPosition: 1,
                  accentColor: _accent,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        );
        await tester.runAsync(GoogleFonts.pendingFonts);
        await tester.pumpAndSettle();

        final chunks = find.byType(RichText);
        chunkBounds.add(tester.getRect(chunks.first));
        // The second chunk is the trailing 'b'.
        positions.add(tester.getRect(chunks.at(1)).left);

        final spaceCue = find.byKey(ValueKey('space-cue-${states[1].name}-0'));
        if (states[1] == CharState.current ||
            states[1] == CharState.incorrect) {
          expect(spaceCue, findsOneWidget);
        } else {
          expect(
            find.byKey(const ValueKey('space-cue-current-0')),
            findsNothing,
          );
          expect(
            find.byKey(const ValueKey('space-cue-incorrect-0')),
            findsNothing,
          );
        }

        if (states[0] == CharState.correct &&
            (states[1] == CharState.pending ||
                states[1] == CharState.current ||
                states[1] == CharState.incorrect)) {
          final paragraph = tester.renderObject<RenderParagraph>(chunks.first);
          expect(paragraph.text.toPlainText(), 'a ');
          final box = paragraph
              .getBoxesForSelection(
                const TextSelection(baseOffset: 1, extentOffset: 2),
              )
              .single
              .toRect();
          final origin =
              tester.getTopLeft(chunks.first) -
              tester.getTopLeft(find.byKey(boundaryKey));
          final boundary =
              boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final cuePixels = await tester.runAsync(() async {
            final image = await boundary.toImage();
            final pixels = await image.toByteData(
              format: ui.ImageByteFormat.rawRgba,
            );
            expect(pixels, isNotNull);
            var count = 0;
            if (states[1] == CharState.pending) {
              pendingPixels = pixels!.buffer.asUint8List();
            } else {
              final row = (origin.dy + box.top).ceil() + 2;
              for (final column in [
                (origin.dx + box.left).ceil() + 1,
                (origin.dx + box.right).floor() - 2,
              ]) {
                final greenOffset = (row * image.width + column) * 4 + 1;
                expect(
                  pixels!.getUint8(greenOffset),
                  lessThan(pendingPixels![greenOffset]),
                  reason: 'Feedback highlight must fill the actual space',
                );
              }
            }
            for (
              var y = (origin.dy + box.top).ceil();
              y < (origin.dy + box.bottom).floor();
              y++
            ) {
              final left = (origin.dx + box.left).floor();
              final right = (origin.dx + box.right).ceil();
              for (var x = 0; x < image.width; x++) {
                final offset = (y * image.width + x) * 4;
                if (x < left || x >= right) {
                  for (var channel = 0; channel < 4; channel++) {
                    expect(
                      pixels!.getUint8(offset + channel),
                      pendingPixels![offset + channel],
                      reason: 'Space cue must not paint beyond the space',
                    );
                  }
                  continue;
                }
                if (states[1] == CharState.pending) continue;
                final red = pixels!.getUint8(offset);
                final green = pixels.getUint8(offset + 1);
                final blue = pixels.getUint8(offset + 2);
                if (states[1] == CharState.current
                    ? red < 125 && green < 125 && blue < 125
                    : red > 180 && green < 140 && blue < 140) {
                  expect(
                    x,
                    allOf(greaterThan(left), lessThan(right - 1)),
                    reason: 'Visible space cue needs room beside the letters',
                  );
                  count++;
                }
              }
            }
            image.dispose();
            return count;
          });
          if (states[1] != CharState.pending) {
            expect(cuePixels, greaterThan(4));
          }
        }
      }

      for (final position in positions.skip(1)) {
        expect(position, closeTo(positions.first, 0.001));
      }
      for (final bounds in chunkBounds.skip(1)) {
        expect(bounds.left, closeTo(chunkBounds.first.left, 0.001));
        expect(bounds.top, closeTo(chunkBounds.first.top, 0.001));
        expect(bounds.width, closeTo(chunkBounds.first.width, 0.001));
        expect(bounds.height, closeTo(chunkBounds.first.height, 0.001));
      }
    });
  }
}
