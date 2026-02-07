import 'package:flutter/material.dart';
import '../../../core/theme/custom_colors.dart';

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
    this.badgeText,
    this.onBadgeTap,
  });

  final String emoji;
  final String title;
  final String? subtitle;
  final String? value;
  final bool showChevron;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isHighlighted;
  final String? badgeText;
  final VoidCallback? onBadgeTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;

    final content = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: subtitle != null && trailing != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: subtitle != null && trailing != null ? 32 : null,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: custom.skyBlueLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: subtitle != null && trailing != null ? 32 : null,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subtitle!,
                            style: TextStyle(
                              fontFamily: 'PretendardJP',
                              fontSize: 12,
                              color: custom.nightLight,
                            ),
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onBadgeTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badgeText!,
                                style: TextStyle(
                                  fontFamily: 'PretendardJP',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            ?trailing,
            if (trailing == null && value != null)
              Text(
                value!,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  color: custom.nightLight,
                ),
              ),
            if (showChevron && trailing == null) ...[
              const SizedBox(width: 4),
              Icon(Icons.chevron_right,
                  color: custom.nightLight, size: 20),
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
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
