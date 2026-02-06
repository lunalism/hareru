import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    this.value,
    this.showChevron = true,
    this.trailing,
    this.onTap,
    this.isHighlighted = false,
  });

  final String emoji;
  final String title;
  final String? subtitle;
  final String? value;
  final bool showChevron;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.skyBlueLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppTypography.caption),
                  ],
                ],
              ),
            ),
            ?trailing,
            if (trailing == null && value != null)
              Text(
                value!,
                style: AppTypography.body.copyWith(
                  color: AppColors.nightLight,
                ),
              ),
            if (showChevron && trailing == null) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right,
                  color: AppColors.nightLight, size: 20),
            ],
          ],
        ),
      ),
    );

    if (!isHighlighted) return content;

    return Stack(
      children: [
        content,
        Positioned(
          left: 0,
          top: 8,
          bottom: 8,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              color: AppColors.skyBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
