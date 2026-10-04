import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/typing_provider.dart';
import 'space_cue_text.dart';

/// Book-style typing surface for long passages (Free Practice, Typing Test).
///
/// Improvements over the plain per-character Wrap:
/// - Words never break across lines (text wraps at word boundaries).
/// - The view automatically scrolls to keep the cursor in sight.
/// - Higher-contrast colors and a fixed-width font so text never shifts.
/// - Spaces always render as a real space; the ␣ cue for the current or
///   mistyped space is painted over it, so feedback never changes its width.
class PassageTypingDisplay extends StatefulWidget {
  final String text;
  final List<CharState> charStates;
  final int cursorPosition;
  final Color accentColor;
  final double fontSize;

  const PassageTypingDisplay({
    super.key,
    required this.text,
    required this.charStates,
    required this.cursorPosition,
    required this.accentColor,
    this.fontSize = 22,
  });

  @override
  State<PassageTypingDisplay> createState() => _PassageTypingDisplayState();
}

class _PassageTypingDisplayState extends State<PassageTypingDisplay> {
  final _cursorKey = GlobalKey();

  /// Only render a window of words around the cursor on very long texts
  /// (the 5-minute test chains passages into thousands of characters).
  static const _windowBehind = 400;
  static const _windowAhead = 700;

  @override
  void didUpdateWidget(PassageTypingDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cursorPosition != widget.cursorPosition) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _followCursor());
    }
  }

  void _followCursor() {
    final ctx = _cursorKey.currentContext;
    if (ctx == null || !mounted) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.4,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    );
  }

  /// Split the text into word chunks (word + trailing spaces) so the Wrap
  /// breaks lines between words, never inside them.
  List<(int, int)> _chunkRanges() {
    final ranges = <(int, int)>[];
    final text = widget.text;
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
    final char = widget.text[index];
    final state = index < widget.charStates.length
        ? widget.charStates[index]
        : CharState.pending;
    // Spaces keep one weight in every state so no font can give them a
    // different advance width than the space beside them.
    final isSpace = char == ' ';

    return switch (state) {
      CharState.correct => TextSpan(
        text: char,
        style: AppTheme.typingTextStyle(
          fontSize: widget.fontSize,
          color: AppColors.correct,
        ),
      ),
      CharState.incorrect => TextSpan(
        text: char,
        style: AppTheme.typingTextStyle(
          fontSize: widget.fontSize,
          fontWeight: isSpace ? FontWeight.w500 : FontWeight.w600,
          color: AppColors.incorrect,
        ).copyWith(
          backgroundColor: AppColors.incorrect.withValues(alpha: 0.15),
        ),
      ),
      CharState.current => TextSpan(
        text: char,
        style: AppTheme.typingTextStyle(
          fontSize: widget.fontSize,
          fontWeight: isSpace ? FontWeight.w500 : FontWeight.w700,
          color: AppColors.textPrimary,
          decoration: TextDecoration.underline,
          decorationColor: widget.accentColor,
        ).copyWith(
          backgroundColor: widget.accentColor.withValues(alpha: 0.22),
          decorationThickness: 3,
        ),
      ),
      CharState.pending => TextSpan(
        text: char,
        style: AppTheme.typingTextStyle(
          fontSize: widget.fontSize,
          color: Colors.grey.shade600,
        ),
      ),
    };
  }

  Widget _chunk(int start, int end) {
    final cues = <(int, CharState)>[];
    for (var i = start; i < end; i++) {
      if (widget.text[i] == ' ' && i < widget.charStates.length) {
        final state = widget.charStates[i];
        if (state == CharState.current || state == CharState.incorrect) {
          cues.add((i - start, state));
        }
      }
    }
    return SpaceCueText(
      span: TextSpan(
        children: [for (var i = start; i < end; i++) _charSpan(i)],
      ),
      cues: cues,
      fontSize: widget.fontSize,
      height: 1.6,
      currentHighlight: widget.accentColor.withValues(alpha: 0.22),
      incorrectHighlight: AppColors.incorrect.withValues(alpha: 0.15),
      cueKey: cues.isEmpty
          ? null
          : ValueKey('space-cue-${cues.first.$2.name}-$start'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chunks = _chunkRanges();

    // Window very long texts to keep per-keystroke rebuilds cheap.
    final windowStart = widget.cursorPosition - _windowBehind;
    final windowEnd = widget.cursorPosition + _windowAhead;
    final visible = widget.text.length <= _windowBehind + _windowAhead
        ? chunks
        : chunks.where((r) => r.$2 > windowStart && r.$1 < windowEnd).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.accentColor.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.accentColor.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            for (final (start, end) in visible)
              KeyedSubtree(
                key:
                    start <= widget.cursorPosition &&
                        widget.cursorPosition < end
                    ? _cursorKey
                    : null,
                child: _chunk(start, end),
              ),
          ],
        ),
      ),
    );
  }
}
