import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/typing_provider.dart';

/// A chunk of typing text that draws the ␣ cue for current/incorrect spaces
/// as a paint-time overlay.
///
/// The span always keeps the real `' '` character, so feedback state never
/// changes a character's advance width and the text cannot shift sideways.
class SpaceCueText extends StatefulWidget {
  /// The chunk's text, with real spaces in every feedback state.
  final TextSpan span;

  /// `(offset within the chunk, state)` for each space needing a cue.
  final List<(int, CharState)> cues;
  final double fontSize;
  final double height;
  final Color currentHighlight;
  final Color incorrectHighlight;

  /// Key for the cue overlay, unique per chunk.
  final Key? cueKey;

  const SpaceCueText({
    super.key,
    required this.span,
    required this.cues,
    required this.fontSize,
    required this.height,
    required this.currentHighlight,
    required this.incorrectHighlight,
    this.cueKey,
  });

  @override
  State<SpaceCueText> createState() => _SpaceCueTextState();
}

class _SpaceCueTextState extends State<SpaceCueText> {
  final _paragraphKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final paragraph = Text.rich(widget.span, key: _paragraphKey);
    if (widget.cues.isEmpty) return paragraph;
    return CustomPaint(
      key: widget.cueKey,
      foregroundPainter: _SpaceCuePainter(
        paragraphKey: _paragraphKey,
        cues: widget.cues,
        fontSize: widget.fontSize,
        height: widget.height,
        currentHighlight: widget.currentHighlight,
        incorrectHighlight: widget.incorrectHighlight,
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      ),
      child: paragraph,
    );
  }
}

class _SpaceCuePainter extends CustomPainter {
  final GlobalKey paragraphKey;
  final List<(int, CharState)> cues;
  final double fontSize;
  final double height;
  final Color currentHighlight;
  final Color incorrectHighlight;
  final TextDirection textDirection;
  final TextScaler textScaler;

  _SpaceCuePainter({
    required this.paragraphKey,
    required this.cues,
    required this.fontSize,
    required this.height,
    required this.currentHighlight,
    required this.incorrectHighlight,
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
      final box = boxes.first.toRect();
      final style = AppTheme.typingTextStyle(
        fontSize: fontSize,
        fontWeight: state == CharState.current
            ? FontWeight.w700
            : FontWeight.w600,
        color: state == CharState.current
            ? AppColors.textPrimary
            : AppColors.incorrect,
        height: height,
      );
      final cue = TextPainter(
        text: TextSpan(text: '␣', style: style),
        textDirection: textDirection,
        textScaler: textScaler,
      )..layout();
      final horizontalScale = cue.width > box.width - 2
          ? ((box.width - 2) / cue.width).clamp(0.0, 1.0)
          : 1.0;
      canvas.save();
      canvas.clipRect(box);
      canvas.drawRect(
        box,
        Paint()
          ..color = state == CharState.current
              ? currentHighlight
              : incorrectHighlight,
      );
      canvas.translate(
        box.left + (box.width - cue.width * horizontalScale) / 2,
        box.top + (box.height - cue.height) / 2,
      );
      canvas.scale(horizontalScale, 1);
      cue.paint(canvas, Offset.zero);
      canvas.restore();
      cue.dispose();
    }
  }

  @override
  bool shouldRepaint(_SpaceCuePainter oldDelegate) => true;
}
