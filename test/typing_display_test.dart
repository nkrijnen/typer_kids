import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typer_kids/providers/typing_provider.dart';
import 'package:typer_kids/widgets/typing_display.dart';

void main() {
  for (final fontSize in [22.0, 28.0, 31.0, 48.0]) {
    testWidgets('space feedback keeps lesson text in place at $fontSize', (
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
                child: TypingDisplay(
                  text: 'a b',
                  charStates: states,
                  cursorPosition: 1,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        );
        await tester.runAsync(GoogleFonts.pendingFonts);
        await tester.pumpAndSettle();

        final followingCharacter = find.byWidgetPredicate(
          (widget) => widget is RichText && widget.text.toPlainText() == 'b',
        );
        positions.add(tester.getRect(followingCharacter).left);
        chunkBounds.add(tester.getRect(find.byType(RichText).first));

        final spaceCue = find.byKey(ValueKey('space-cue-${states[1].name}'));
        if (states[1] == CharState.current ||
            states[1] == CharState.incorrect) {
          expect(spaceCue, findsOneWidget);
        } else {
          expect(find.byKey(const ValueKey('space-cue-current')), findsNothing);
          expect(
            find.byKey(const ValueKey('space-cue-incorrect')),
            findsNothing,
          );
        }
        if (states[0] == CharState.correct &&
            (states[1] == CharState.pending ||
                states[1] == CharState.current ||
                states[1] == CharState.incorrect)) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.byType(RichText).first,
          );
          expect(paragraph.text.toPlainText(), 'a ');
          final box = paragraph
              .getBoxesForSelection(
                const TextSelection(baseOffset: 1, extentOffset: 2),
              )
              .single
              .toRect();
          final origin =
              tester.getTopLeft(find.byType(RichText).first) -
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
