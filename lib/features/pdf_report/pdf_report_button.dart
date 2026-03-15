import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/features/subscription/paywall_screen.dart';
import 'package:hareru/features/subscription/subscription_provider.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/features/pdf_report/pdf_report_generator.dart';
import 'package:hareru/features/pdf_report/pdf_share_service.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';

class PdfReportButton extends ConsumerStatefulWidget {
  const PdfReportButton({required this.selectedMonth, super.key});

  final DateTime selectedMonth;

  @override
  ConsumerState<PdfReportButton> createState() => _PdfReportButtonState();
}

class _PdfReportButtonState extends ConsumerState<PdfReportButton> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final sub = ref.watch(subscriptionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (!sub.canExportPdf) {
      return _buildUpsellBanner(isDark, l10n);
    }
    return _buildShareButton(isDark, l10n);
  }

  Widget _buildUpsellBanner(bool isDark, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.guideIconBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? HareruColors.darkDivider
              : HareruColors.lightDivider,
        ),
      ),
      child: Column(
        children: [
          const Text('\u{1F4C4}', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            l10n.pdfReportTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.pdfReportDescription,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PaywallScreen(),
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: HareruColors.primaryStart,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.unlockWithClearPro} \u2192',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(bool isDark, AppLocalizations l10n) {
    return GestureDetector(
      onTap: _isGenerating ? null : () => _generateAndShare(l10n),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: HareruColors.primaryStart,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(Icons.share_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              _isGenerating ? l10n.pdfGenerating : l10n.pdfShareButton,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndShare(AppLocalizations l10n) async {
    setState(() => _isGenerating = true);

    try {
      final allTxns = ref.read(transactionProvider);
      final month = widget.selectedMonth;
      final monthTxns = allTxns
          .where((t) =>
              t.createdAt.year == month.year &&
              t.createdAt.month == month.month)
          .toList();

      double totalByType(TransactionType type) => monthTxns
          .where((t) => t.type == type)
          .fold(0.0, (sum, t) => sum + t.amount);

      final expenseTotal = totalByType(TransactionType.expense);
      final incomeTotal = totalByType(TransactionType.income);
      final transferTotal = totalByType(TransactionType.transfer);
      final savingsTotal = totalByType(TransactionType.savings);
      final budget = ref.read(budgetProvider);

      // Build category expense map with resolved display names
      final catMap = <String, double>{};
      for (final t
          in monthTxns.where((t) => t.type == TransactionType.expense)) {
        final cat = ref
            .read(categoryProvider.notifier)
            .getCategoryById(t.category);
        final name = cat != null
            ? (cat.isDefault ? resolveL10nKey(cat.name, l10n) : cat.name)
            : resolveL10nKey(t.category, l10n);
        catMap[name] = (catMap[name] ?? 0) + t.amount;
      }

      // Build insights (3 lines: top category, budget/comparison, advice)
      final insights = <String>[];
      final prevMonth = DateTime(month.year, month.month - 1);
      final prevTxns = allTxns
          .where((t) =>
              t.createdAt.year == prevMonth.year &&
              t.createdAt.month == prevMonth.month)
          .toList();
      final prevExpenseTotal = prevTxns
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      String? topCategoryName;
      if (expenseTotal == 0 && incomeTotal == 0) {
        insights.add(l10n.needMoreData);
      } else {
        // Line 1: Top spending category + percentage
        if (catMap.isNotEmpty) {
          final sorted = catMap.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final top = sorted.first;
          topCategoryName = top.key;
          final percent = expenseTotal > 0
              ? (top.value / expenseTotal * 100).toStringAsFixed(0)
              : '0';
          insights.add(l10n.topCategory(top.key, percent));
        }
        // Line 2: Budget pace or month-over-month comparison
        if (budget > 0) {
          final remaining = budget - expenseTotal;
          if (remaining >= 0) {
            final usedPercent =
                (expenseTotal / budget * 100).toStringAsFixed(1);
            insights.add(l10n.pdfBudgetPaceGood(usedPercent));
          } else {
            insights.add(l10n.pdfBudgetPaceOver(
                '\u00a5${_formatAmount(remaining.abs())}'));
          }
        } else if (prevExpenseTotal > 0) {
          final diff = prevExpenseTotal - expenseTotal;
          if (diff > 0) {
            insights.add(
                l10n.savedComparedLastMonth('\u00a5${_formatAmount(diff)}'));
          } else if (diff < 0) {
            insights.add(l10n
                .spentMoreThanLastMonth('\u00a5${_formatAmount(diff.abs())}'));
          }
        }
        // Line 3: Actionable advice
        if (topCategoryName != null) {
          insights.add(l10n.pdfAdviceTopCategory(topCategoryName));
        } else {
          insights.add(l10n.pdfAdviceGeneral);
        }
        if (insights.isEmpty) {
          insights.add(l10n.needMoreData);
        }
      }

      final locale = Localizations.localeOf(context).languageCode;

      // Build category display name map for all transactions
      final categoryDisplayNames = <String, String>{};
      for (final t in monthTxns) {
        if (categoryDisplayNames.containsKey(t.category)) continue;
        final cat = ref
            .read(categoryProvider.notifier)
            .getCategoryById(t.category);
        categoryDisplayNames[t.category] = cat != null
            ? (cat.isDefault ? resolveL10nKey(cat.name, l10n) : cat.name)
            : resolveL10nKey(t.category, l10n);
      }

      final reportData = PdfReportData(
        month: month,
        incomeTotal: incomeTotal,
        expenseTotal: expenseTotal,
        transferTotal: transferTotal,
        savingsTotal: savingsTotal,
        budget: budget,
        categoryExpenses: catMap,
        transactions: monthTxns,
        insights: insights,
        locale: locale,
        categoryDisplayNames: categoryDisplayNames,
        lMonthlyReport: l10n.pdfMonthlyReport,
        lRealExpense: l10n.realExpense,
        lApparentExpense: l10n.pdfApparentExpense,
        lDifference: l10n.pdfDifference,
        lIncome: l10n.income,
        lExpense: l10n.expense,
        lTransfer: l10n.transfer,
        lSavings: l10n.savings,
        lMonthlyBudget: l10n.monthlyBudget,
        lRemaining: l10n.remaining,
        lMonthlyInsight: l10n.monthlyInsight,
        lBrandFooter: l10n.pdfBrandFooter,
        lTransactionCount: l10n.pdfTransactionCount,
        lAndMore: l10n.pdfAndMore,
        lGeneratedOn: l10n.pdfGeneratedOn,
        lOverBudget: l10n.pdfOverBudget,
        lBudgetUsage: l10n.pdfBudgetUsage,
        lBudgetPaceGood: l10n.pdfBudgetPaceGood,
        lBudgetPaceOver: l10n.pdfBudgetPaceOver,
        lAdviceTopCategory: l10n.pdfAdviceTopCategory,
        lAdviceGeneral: l10n.pdfAdviceGeneral,
      );

      final pdfBytes = await PdfReportGenerator.generate(reportData);

      if (!mounted) return;

      await PdfShareService.sharePdf(
        pdfBytes: pdfBytes,
        month: month,
        subject: l10n.shareReportSubject,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.pdfError}: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  String _formatAmount(double value) {
    final s = value.truncate().abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
