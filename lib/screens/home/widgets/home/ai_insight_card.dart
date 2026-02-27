import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? HareruColors.darkDivider : HareruColors.lightDivider,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: HareruColors.guideIconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child:
                const Icon(Icons.auto_awesome, size: 22, color: HareruColors.primaryStart),
          ),
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
                    color: isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.aiInsightMessage,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
