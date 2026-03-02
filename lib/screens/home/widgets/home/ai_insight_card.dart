import 'package:flutter/material.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/widgets/emoji_badge.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key, required this.isDark, this.locked = false});

  final bool isDark;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Opacity(
      opacity: locked ? 0.5 : 1.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: c.divider,
          ),
        ),
        child: Row(
          children: [
            const IconBadge(icon: Icons.auto_awesome),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aiInsightTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locked ? l10n.lockClearRequired : l10n.aiInsightMessage,
                    style: TextStyle(
                      fontSize: 12,
                      color: c.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (locked)
              Icon(
                Icons.lock_rounded,
                size: 18,
                color: c.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
