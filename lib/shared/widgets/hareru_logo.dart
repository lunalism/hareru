import 'package:flutter/material.dart';
import 'hareru_logo_painter.dart';
import 'hareru_logo_symbol.dart';

/// Full Hareru logo: H symbol + golden dot + optional "Hareru" wordmark.
class HareruLogo extends StatelessWidget {
  const HareruLogo({
    super.key,
    required this.size,
    this.showWordmark = true,
    this.isDark,
    this.symbolColor,
    this.showGlow = true,
    this.wordmarkOpacity = 1.0,
    this.dotOpacity = 1.0,
    this.dotScale = 1.0,
    this.glowSpread = 4.0,
    this.symbolOpacity = 1.0,
    this.symbolScale = 1.0,
    this.wordmarkOffset = 0.0,
  });

  final double size;
  final bool showWordmark;
  final bool? isDark;
  final Color? symbolColor;
  final bool showGlow;
  final double wordmarkOpacity;
  final double dotOpacity;
  final double dotScale;
  final double glowSpread;
  final double symbolOpacity;
  final double symbolScale;
  final double wordmarkOffset;

  @override
  Widget build(BuildContext context) {
    final dark = isDark ?? Theme.of(context).brightness == Brightness.dark;
    final wordmarkColor = dark ? Colors.white : HareruLogoPainter.darkText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Symbol
        Opacity(
          opacity: symbolOpacity,
          child: Transform.scale(
            scale: symbolScale,
            child: HareruLogoSymbol(
              size: size,
              symbolColor: symbolColor,
              showGlow: showGlow,
              dotOpacity: dotOpacity,
              dotScale: dotScale,
              glowSpread: glowSpread,
            ),
          ),
        ),
        // Wordmark
        if (showWordmark) ...[
          SizedBox(height: size * 0.2),
          Transform.translate(
            offset: Offset(0, wordmarkOffset),
            child: Opacity(
              opacity: wordmarkOpacity,
              child: Text(
                'Hareru',
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: size * 0.32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: wordmarkColor,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
