import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HareruLogoPainter extends CustomPainter {
  const HareruLogoPainter({
    required this.symbolColor,
    required this.dotColor,
    this.showGlow = true,
    this.dotOpacity = 1.0,
    this.dotScale = 1.0,
    this.glowSpread = 4.0,
  });

  final Color symbolColor;
  final Color dotColor;
  final bool showGlow;
  final double dotOpacity;
  final double dotScale;
  final double glowSpread;

  /// Brand colors
  static const mainBlue = Color(0xFF4A90D9);
  static const goldenYellow = Color(0xFFFFD54F);
  static const darkText = Color(0xFF333333);

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final strokeWidth = h * 0.16;
    final cornerRadius = strokeWidth * 0.15;

    // H dimensions
    final leftX = size.width * 0.5 - h * 0.35;
    final rightX = size.width * 0.5 + h * 0.35 - strokeWidth;
    final topY = 0.0;
    final bottomY = h;
    final crossbarY = h * 0.43; // slightly above center for optical correction

    final paint = Paint()
      ..color = symbolColor
      ..style = PaintingStyle.fill;

    // Left vertical bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(leftX, topY, strokeWidth, bottomY - topY),
        Radius.circular(cornerRadius),
      ),
      paint,
    );

    // Right vertical bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rightX, topY, strokeWidth, bottomY - topY),
        Radius.circular(cornerRadius),
      ),
      paint,
    );

    // Crossbar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(leftX, crossbarY, rightX + strokeWidth - leftX, strokeWidth),
        Radius.circular(cornerRadius),
      ),
      paint,
    );

    // Golden dot
    if (dotOpacity > 0) {
      final dotDiameter = h * 0.13;
      final dotRadius = dotDiameter / 2 * dotScale;
      final dotCenterX = rightX + strokeWidth + dotRadius * 0.5;
      final dotCenterY = topY - dotRadius * 0.5;
      final dotCenter = Offset(dotCenterX, dotCenterY);

      // Glow effect
      if (showGlow && glowSpread > 0) {
        final glowPaint = Paint()
          ..color = dotColor.withValues(alpha: 0.3 * dotOpacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSpread);
        canvas.drawCircle(dotCenter, dotRadius, glowPaint);
      }

      // Dot
      final dotPaint = Paint()
        ..color = dotColor.withValues(alpha: dotOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HareruLogoPainter oldDelegate) {
    return oldDelegate.symbolColor != symbolColor ||
        oldDelegate.dotColor != dotColor ||
        oldDelegate.showGlow != showGlow ||
        oldDelegate.dotOpacity != dotOpacity ||
        oldDelegate.dotScale != dotScale ||
        oldDelegate.glowSpread != glowSpread;
  }

  /// Paints the logo to a [ui.Picture] for PNG export.
  /// [size] is the canvas size, [backgroundColor] fills the background first.
  static ui.Picture toPicture({
    required Size size,
    required Color symbolColor,
    required Color dotColor,
    Color? backgroundColor,
    ui.Gradient? backgroundGradient,
    bool showGlow = true,
    double padding = 0.2,
  }) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Background
    if (backgroundGradient != null) {
      final bgPaint = Paint()..shader = backgroundGradient;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    } else if (backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor,
      );
    }

    // Calculate padded region
    final pad = size.width * padding;
    final logoSize = Size(size.width - pad * 2, size.height - pad * 2);

    canvas.save();
    canvas.translate(pad, pad + logoSize.height * 0.05); // slight vertical offset for dot space

    final painter = HareruLogoPainter(
      symbolColor: symbolColor,
      dotColor: dotColor,
      showGlow: showGlow,
    );
    painter.paint(canvas, logoSize * 0.9);

    canvas.restore();
    return recorder.endRecording();
  }
}
