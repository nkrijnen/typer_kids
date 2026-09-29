import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typer_kids/providers/typing_provider.dart';
import 'package:typer_kids/widgets/typing_display.dart';

void main() {
  for (final fontSize in [22.0, 28.0, 48.0]) {
    testWidgets('space feedback keeps lesson text in place at $fontSize', (
      tester,
    ) async {
      GoogleFonts.config.allowRuntimeFetching = false;

      final boundaryKey = GlobalKey();
      final positions = <double>[];
      final chunkBounds = <Rect>[];
      for (final states in [
        [CharState.current, CharState.pending, CharState.pending],
        [CharState.pending, CharState.pending, CharState.pending],
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
        if (states[1] == CharState.current ||
            states[1] == CharState.incorrect) {
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
                final red = pixels!.getUint8(offset);
                final green = pixels.getUint8(offset + 1);
                final blue = pixels.getUint8(offset + 2);
                if (states[1] == CharState.current
                    ? red < 125 && green < 125 && blue < 125
                    : red > 180 && green < 140 && blue < 140) {
                  count++;
                }
              }
            }
            image.dispose();
            return count;
          });
          expect(cuePixels, greaterThan(4));
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
