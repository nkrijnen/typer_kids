import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/typing_provider.dart';

/// Displays the lesson text to type with color-coded feedback per character.
///
/// Text wraps at word boundaries (words never split across lines), uses the
/// shared fixed-width typing font, and keeps each character's position stable
/// across feedback states.
class TypingDisplay extends StatelessWidget {
  final String text;
  final List<CharState> charStates;
  final int cursorPosition;
  final double fontSize;

  const TypingDisplay({
    super.key,
    required this.text,
    required this.charStates,
    required this.cursorPosition,
    this.fontSize = 28,
  });

  /// Word chunks (word + trailing spaces) so lines break between words.
  List<(int, int)> _chunkRanges() {
    final ranges = <(int, int)>[];
    var start = 0;
    while (start < text.length) {
      var end = start;
      while (end < text.length && text[end] != ' ') {
        end++;
      }
      while (end < text.length && text[end] == ' ') {
        end++;
      }
      ranges.add((start, end));
      start = end;
    }
    return ranges;
  }

  TextSpan _charSpan(int index) {
    final char = text[index];
    final state = index < charStates.length
        ? charStates[index]
        : CharState.pending;
    final isSpace = char == ' ';

    return switch (state) {
      CharState.correct => TextSpan(
        text: char,
        style: AppTheme.typingTextStyle(
          fontSize: fontSize,
          color: AppColors.correct,
          height: 1.5,
        ),
      ),
      CharState.incorrect => TextSpan(
        text: char,
        style:
            AppTheme.typingTextStyle(
              fontSize: fontSize,
              fontWeight: isSpace ? FontWeight.w500 : FontWeight.w600,
              color: AppColors.incorrect,
              height: 1.5,
            ).copyWith(
              backgroundColor: AppColors.incorrect.withValues(alpha: 0.15),
            ),
      ),
      CharState.current => TextSpan(
        text: char,
        style:
            AppTheme.typingTextStyle(
              fontSize: fontSize,
              fontWeight: isSpace ? FontWeight.w500 : FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.5,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.secondary,
            ).copyWith(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.25),
              decorationThickness: 3,
            ),
      ),
      CharState.pending => TextSpan(
        text: char,
        style: AppTheme.typingTextStyle(
          fontSize: fontSize,
          color: Colors.grey.shade600,
          height: 1.5,
        ),
      ),
    };
  }

  Widget _chunk(BuildContext context, int start, int end) {
    final paragraphKey = GlobalKey();
    final cues = <(int, CharState)>[];
    for (var index = start; index < end; index++) {
      if (text[index] == ' ' && index < charStates.length) {
        final state = charStates[index];
        if (state == CharState.current || state == CharState.incorrect) {
          cues.add((index - start, state));
        }
      }
    }
    final paragraph = Text.rich(
      TextSpan(
        children: [
          for (var index = start; index < end; index++) _charSpan(index),
        ],
      ),
      key: paragraphKey,
    );
    if (cues.isEmpty) return paragraph;
    return CustomPaint(
      key: ValueKey('space-cue-${cues.first.$2.name}'),
      foregroundPainter: _SpaceCuePainter(
        paragraphKey: paragraphKey,
        cues: cues,
        fontSize: fontSize,
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      ),
      child: paragraph,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: (fontSize * 0.6).clamp(16, 32),
        vertical: (fontSize * 0.5).clamp(14, 28),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          for (final (start, end) in _chunkRanges())
            _chunk(context, start, end),
        ],
      ),
    );
  }
}

class _SpaceCuePainter extends CustomPainter {
  final GlobalKey paragraphKey;
  final List<(int, CharState)> cues;
  final double fontSize;
  final TextDirection textDirection;
  final TextScaler textScaler;

  _SpaceCuePainter({
    required this.paragraphKey,
    required this.cues,
    required this.fontSize,
    required this.textDirection,
    required this.textScaler,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paragraph =
        paragraphKey.currentContext!.findRenderObject()! as RenderParagraph;
    for (final (index, state) in cues) {
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: index, extentOffset: index + 1),
      );
      if (boxes.isEmpty) continue;
      final style =
          AppTheme.typingTextStyle(
            fontSize: fontSize,
            fontWeight: state == CharState.current
                ? FontWeight.w700
                : FontWeight.w600,
            color: state == CharState.current
                ? AppColors.textPrimary
                : AppColors.incorrect,
            height: 1.5,
            decoration: state == CharState.current
                ? TextDecoration.underline
                : null,
            decorationColor: AppColors.secondary,
          ).copyWith(
            backgroundColor:
                (state == CharState.current
                        ? AppColors.secondary
                        : AppColors.incorrect)
                    .withValues(
                      alpha: state == CharState.current ? 0.25 : 0.15,
                    ),
            decorationThickness: state == CharState.current ? 3 : null,
          );
      final cue = TextPainter(
        text: TextSpan(text: '␣', style: style),
        textDirection: textDirection,
        textScaler: textScaler,
      )..layout();
      final box = boxes.first.toRect();
      cue.paint(
        canvas,
        Offset(
          box.left + (box.width - cue.width) / 2,
          box.top + (box.height - cue.height) / 2,
        ),
      );
      cue.dispose();
    }
  }

  @override
  bool shouldRepaint(_SpaceCuePainter oldDelegate) => true;
}
