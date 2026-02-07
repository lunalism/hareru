import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/ai_insight.dart';
import '../../providers/ai_insight_provider.dart';
import '../../providers/premium_provider.dart';
import 'premium_blur_card.dart';

class AiClearInsightCard extends ConsumerWidget {
  const AiClearInsightCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final insight = ref.watch(aiInsightProvider);
    final comparison = ref.watch(clearComparisonProvider);
    final l10n = AppLocalizations.of(context)!;

    return PremiumBlurCard(
      isPremium: isPremium,
      blurMessage: l10n.blurMessageInsight,
      child: _CardContent(
        insight: insight,
        comparison: comparison,
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.insight,
    required this.comparison,
  });

  final AiInsight? insight;
  final ({int totalWithTransfers, int realExpense, int transferAmount}) comparison;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0');
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
        border: isDark
            ? Border.all(color: theme.colorScheme.outline)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top gradient border
          Container(
            height: 2,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90D9), Color(0xFF6AB0E3)],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Text('\u{1F916}', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.aiInsightTitle,
                        style: const TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '\u2728 ${l10n.premiumBadge}',
                        style: const TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Clear comparison section
                _ClearComparisonSection(
                  comparison: comparison,
                  fmt: fmt,
                  l10n: l10n,
                ),
                // AI discoveries section
                if (insight != null && insight!.discoveries.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Divider(
                      height: 1,
                      color:
                          theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _AiDiscoveriesSection(
                    discoveries: insight!.discoveries,
                    generatedAt: insight!.generatedAt,
                    l10n: l10n,
                  ),
                ],
                // Suggestion section
                if (insight != null &&
                    insight!.suggestion.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color:
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),
                  _AiSuggestionSection(
                    suggestion: insight!.suggestion,
                    l10n: l10n,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClearComparisonSection extends StatelessWidget {
  const _ClearComparisonSection({
    required this.comparison,
    required this.fmt,
    required this.l10n,
  });

  final ({int totalWithTransfers, int realExpense, int transferAmount}) comparison;
  final NumberFormat fmt;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('\u{1F504}', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              l10n.clearComparisonTitle,
              style: const TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (comparison.transferAmount > 0) ...[
          // Other app amount
          Text(
            l10n.clearComparisonOtherApp,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\u00a5${fmt.format(comparison.totalWithTransfers)}',
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              decoration: TextDecoration.lineThrough,
              decorationColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 8),
          // Real expense
          Text(
            l10n.clearComparisonReal,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\u00a5${fmt.format(comparison.realExpense)} \u2728',
            style: const TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A90D9),
            ),
          ),
          const SizedBox(height: 12),
          // Difference explanation
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '\u{1F4A1} ${l10n.clearComparisonSaved(fmt.format(comparison.transferAmount))}',
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              l10n.clearComparisonNoTransfer,
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AiDiscoveriesSection extends StatelessWidget {
  const _AiDiscoveriesSection({
    required this.discoveries,
    required this.generatedAt,
    required this.l10n,
  });

  final List<InsightItem> discoveries;
  final DateTime generatedAt;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('\u{1F4A1}', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              l10n.aiDiscoveriesTitle,
              style: const TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...discoveries.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: i < discoveries.length - 1 ? 12 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}.',
                  style: const TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A90D9),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.detail,
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        Text(
          l10n.aiDiscoveriesLastAnalysis(
            '${generatedAt.month}/${generatedAt.day}',
          ),
          style: TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 11,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        ),
      ],
    );
  }
}

class _AiSuggestionSection extends StatelessWidget {
  const _AiSuggestionSection({
    required this.suggestion,
    required this.l10n,
  });

  final String suggestion;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('\u{1F3AF}', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              l10n.aiSuggestionTitle,
              style: const TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text: '\u201C',
                style: TextStyle(
                  color: Color(0xFF4A90D9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: suggestion),
              const TextSpan(
                text: '\u201D',
                style: TextStyle(
                  color: Color(0xFF4A90D9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
