import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/features/subscription/ad_placeholder.dart';
import 'package:hareru/features/subscription/entitlement_gate.dart';
import 'package:hareru/features/subscription/subscription_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/home/widgets/home/ai_insight_card.dart';
import 'package:hareru/screens/home/widgets/home/breakdown_card.dart';
import 'package:hareru/screens/home/widgets/home/budget_summary_card.dart';
import 'package:hareru/screens/home/widgets/home/empty_state.dart';
import 'package:hareru/screens/home/widgets/home/recent_records_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final isDark = context.isDark;
    final transactions = ref.watch(transactionProvider);
    final isEmpty = transactions.isEmpty;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeader(context, isDark),
              const SizedBox(height: 20),
              _buildMonthSelector(context, isDark),
              const SizedBox(height: 16),
              if (isEmpty) ...[
                EmptyMainCard(isDark: isDark),
                const SizedBox(height: 24),
                GuideCards(isDark: isDark),
              ] else ...[
                BudgetSummaryCard(isDark: isDark),
                const SizedBox(height: 8),
                BreakdownCard(isDark: isDark),
                const SizedBox(height: 24),
                RecentRecordsSection(
                    transactions: transactions, isDark: isDark),
                const SizedBox(height: 24),
                EntitlementGate(
                  requiredTier: SubscriptionTier.clear,
                  lockedChild: AiInsightCard(isDark: isDark, locked: true),
                  child: AiInsightCard(isDark: isDark),
                ),
              ],
              // Ad placeholder for free users
              const AdPlaceholder(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final c = context.colors;
    return Row(
      children: [
        SvgPicture.asset(
          isDark
              ? 'assets/icon/hareru-symbol-white.svg'
              : 'assets/icon/hareru-symbol-color.svg',
          width: 28,
          height: 28,
        ),
        const SizedBox(width: 8),
        Text(
          'Hareru',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector(BuildContext context, bool isDark) {
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.chevron_left_rounded,
          color: c.textTertiary,
        ),
        const SizedBox(width: 12),
        Text(
          l10n.monthFormat(now.year, now.month),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.chevron_right_rounded,
          color: c.textTertiary,
        ),
      ],
    );
  }
}
