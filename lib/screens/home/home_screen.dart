import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/features/subscription/ad_placeholder.dart';
import 'package:hareru/features/subscription/entitlement_gate.dart';
import 'package:hareru/features/subscription/subscription_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/widgets/home/ai_insight_card.dart';
import 'package:hareru/screens/home/widgets/home/breakdown_card.dart';
import 'package:hareru/screens/home/widgets/home/budget_summary_card.dart';
import 'package:hareru/screens/home/widgets/home/empty_state.dart';
import 'package:hareru/screens/home/widgets/home/recent_records_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  List<Transaction> _filterByMonth(List<Transaction> all) {
    return all
        .where((t) =>
            t.createdAt.year == _selectedMonth.year &&
            t.createdAt.month == _selectedMonth.month)
        .toList();
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;
    final allTransactions = ref.watch(transactionProvider);
    final monthTransactions = _filterByMonth(allTransactions);
    final isEmpty = monthTransactions.isEmpty;

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
                // Only show guide cards when there are no transactions at all
                if (allTransactions.isEmpty)
                  GuideCards(isDark: isDark),
              ] else ...[
                BudgetSummaryCard(
                  isDark: isDark,
                  transactions: monthTransactions,
                ),
                const SizedBox(height: 8),
                BreakdownCard(
                  isDark: isDark,
                  transactions: monthTransactions,
                ),
                const SizedBox(height: 24),
                RecentRecordsSection(
                    transactions: monthTransactions, isDark: isDark),
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _goToPreviousMonth,
          child: Icon(
            Icons.chevron_left_rounded,
            color: c.textTertiary,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          l10n.monthFormat(_selectedMonth.year, _selectedMonth.month),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _goToNextMonth,
          child: Icon(
            Icons.chevron_right_rounded,
            color: c.textTertiary,
          ),
        ),
      ],
    );
  }
}
