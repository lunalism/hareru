import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../../../shared/models/default_categories.dart';
import '../../domain/insight.dart';
import '../../providers/report_providers.dart';

class InsightCard extends ConsumerWidget {
  const InsightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(reportInsightsProvider);
    final period = ref.watch(reportPeriodProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    if (insights.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2518) : const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text('📝', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.notEnoughData,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final title = switch (period) {
      ReportPeriod.weekly => l10n.weeklyInsight,
      ReportPeriod.monthly => l10n.monthlyInsight,
      ReportPeriod.yearly => l10n.yearlyInsight,
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2518) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildInsightItem(context, l10n, insight, theme),
              )),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
      BuildContext context, AppLocalizations l10n, Insight insight, ThemeData theme) {
    // Parse insight description for structured data
    if (insight.emoji == '📅') {
      // Top spending day
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(insight.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.topSpendingDay,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  insight.description,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (insight.emoji == '📈') {
      // Category change: "categoryKey|percent|up/down"
      final parts = insight.description.split('|');
      if (parts.length == 3) {
        final catKey = parts[0];
        final pct = int.tryParse(parts[1]) ?? 0;
        final isUp = parts[2] == 'up';
        final catName = _resolveCategoryName(context, catKey);
        final text = isUp
            ? l10n.categoryIncreased(catName, pct)
            : l10n.categoryDecreased(catName, pct);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insight.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.comparedToPrev,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    } else if (insight.emoji == '🏆') {
      // Least spending week: "weekNum|amount"
      final parts = insight.description.split('|');
      if (parts.length == 2) {
        final weekNum = int.tryParse(parts[0]) ?? 1;
        final amount = parts[1];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insight.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.leastSpendingWeek,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '${l10n.nthWeek(weekNum)} — $amount',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    }

    // Fallback
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(insight.emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            insight.description,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _resolveCategoryName(BuildContext context, String key) {
    for (final entry in DefaultCategories.expense) {
      if (entry.localeKey == key) return entry.getDisplayName(context);
    }
    for (final entry in DefaultCategories.income) {
      if (entry.localeKey == key) return entry.getDisplayName(context);
    }
    return key;
  }
}
