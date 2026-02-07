import 'package:flutter/material.dart';
import 'hareru_logo_painter.dart';

/// H mark + golden dot symbol only (no wordmark).
class HareruLogoSymbol extends StatelessWidget {
  const HareruLogoSymbol({
    super.key,
    required this.size,
    this.symbolColor,
    this.showGlow = true,
    this.dotOpacity = 1.0,
    this.dotScale = 1.0,
    this.glowSpread = 4.0,
  });

  final double size;
  final Color? symbolColor;
  final bool showGlow;
  final double dotOpacity;
  final double dotScale;
  final double glowSpread;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = symbolColor ?? (isDark ? Colors.white : HareruLogoPainter.mainBlue);

    return CustomPaint(
      size: Size(size * 1.1, size), // extra width for dot overhang
      painter: HareruLogoPainter(
        symbolColor: color,
        dotColor: HareruLogoPainter.goldenYellow,
        showGlow: showGlow,
        dotOpacity: dotOpacity,
        dotScale: dotScale,
        glowSpread: glowSpread,
      ),
    );
  }
}
