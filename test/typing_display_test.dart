import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typer_kids/providers/typing_provider.dart';
import 'package:typer_kids/widgets/typing_display.dart';

void main() {
  testWidgets('space feedback keeps following lesson text in place', (
    tester,
  ) async {
    GoogleFonts.config.allowRuntimeFetching = false;

    final positions = <double>[];
    for (final states in [
      [CharState.pending, CharState.pending, CharState.pending],
      [CharState.correct, CharState.correct, CharState.pending],
      [CharState.correct, CharState.current, CharState.pending],
      [CharState.correct, CharState.incorrect, CharState.pending],
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 400,
            child: TypingDisplay(
              text: 'a b',
              charStates: states,
              cursorPosition: 1,
              fontSize: 28,
            ),
          ),
        ),
      );
      await tester.pump();

      final followingCharacter = find.byWidgetPredicate(
        (widget) => widget is RichText && widget.text.toPlainText() == 'b',
      );
      positions.add(tester.getRect(followingCharacter).left);

      final spaceCue = find.byKey(ValueKey('space-cue-${states[1].name}'));
      if (states[1] == CharState.current || states[1] == CharState.incorrect) {
        expect(spaceCue, findsOneWidget);
      } else {
        expect(find.byKey(const ValueKey('space-cue-current')), findsNothing);
        expect(find.byKey(const ValueKey('space-cue-incorrect')), findsNothing);
      }
    }

    for (final position in positions.skip(1)) {
      expect(position, closeTo(positions.first, 0.001));
    }
  });
}
