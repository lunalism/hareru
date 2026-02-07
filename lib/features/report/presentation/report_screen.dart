import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../providers/report_providers.dart';
import 'widgets/category_detail_list.dart';
import 'widgets/category_donut_card.dart';
import 'widgets/insight_card.dart';
import 'widgets/period_navigator.dart';
import 'widgets/period_segment.dart';
import 'widgets/report_empty_state.dart';
import 'widgets/summary_card.dart';
import 'widgets/trend_bar_card.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(reportTransactionsProvider);
    final l10n = AppLocalizations.of(context)!;
    final hasExpenses = transactions
        .any((t) => t.transactionType.key == 'expense');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.reportTitle,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          const PeriodSegment(),
          const SizedBox(height: 8),
          const PeriodNavigator(),
          const SizedBox(height: 8),
          Expanded(
            child: hasExpenses
                ? _buildContent()
                : const ReportEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: const [
        SizedBox(height: 8),
        SummaryCard(),
        SizedBox(height: 16),
        CategoryDonutCard(),
        SizedBox(height: 16),
        TrendBarCard(),
        SizedBox(height: 16),
        InsightCard(),
        SizedBox(height: 16),
        CategoryDetailList(),
      ],
    );
  }
}
