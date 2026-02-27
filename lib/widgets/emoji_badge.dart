import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';

class EmojiBadge extends StatelessWidget {
  const EmojiBadge({
    super.key,
    required this.emoji,
    this.size = 42,
    this.backgroundColor,
    this.isDark = false,
    this.fontSize,
    this.borderRadius = 12,
  });

  final String emoji;
  final double size;
  final Color? backgroundColor;
  final bool isDark;
  final double? fontSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? HareruColors.darkBg : HareruColors.lightBg),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: TextStyle(fontSize: fontSize ?? size * 0.5),
      ),
    );
  }
}

class IconBadge extends StatelessWidget {
  const IconBadge({
    super.key,
    required this.icon,
    this.size = 42,
    this.iconSize = 22,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 12,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? HareruColors.guideIconBg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: iconColor ?? HareruColors.primaryStart),
    );
  }
}
