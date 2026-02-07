import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/ai_insight.dart';
import '../../providers/ai_insight_provider.dart';
import '../../providers/premium_provider.dart';
import 'premium_blur_card.dart';

class SavingPotentialCard extends ConsumerWidget {
  const SavingPotentialCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final insight = ref.watch(aiInsightProvider);
    final l10n = AppLocalizations.of(context)!;

    return PremiumBlurCard(
      isPremium: isPremium,
      blurMessage: l10n.blurMessageSaving,
      child: _CardContent(insight: insight),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.insight});
  final AiInsight? insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0');
    final isDark = theme.brightness == Brightness.dark;

    final discoveries = insight?.discoveries ?? [];
    final totalMonthlySaving =
        discoveries.fold(0, (sum, d) => sum + d.savingPotential);
    final yearlySaving = totalMonthlySaving * 12;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Text('\u{1F4B0}', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                l10n.savingPotentialTitle,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Total monthly saving
          Text(
            l10n.savingPotentialMonthly(
                '\u00a5${fmt.format(totalMonthlySaving)}'),
            style: const TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.savingPotentialYearly('\u00a5${fmt.format(yearlySaving)}'),
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          if (discoveries.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ...discoveries.take(3).map((item) {
                    final ratio = totalMonthlySaving > 0
                        ? item.savingPotential / totalMonthlySaving
                        : 0.0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _SavingItemRow(
                        label: item.title,
                        amount: item.savingPotential,
                        ratio: ratio,
                        fmt: fmt,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SavingItemRow extends StatelessWidget {
  const _SavingItemRow({
    required this.label,
    required this.amount,
    required this.ratio,
    required this.fmt,
  });

  final String label;
  final int amount;
  final double ratio;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '\u00a5${fmt.format(amount)}',
              style: const TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            height: 6,
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
          ),
        ),
      ],
    );
  }
}
