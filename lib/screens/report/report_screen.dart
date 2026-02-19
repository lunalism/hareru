import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/widgets/add_transaction_sheet.dart';

const _categoryColors = [
  Color(0xFFEF4444),
  Color(0xFF3B82F6),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFF8B5CF6),
  Color(0xFFEC4899),
  Color(0xFF06B6D4),
  Color(0xFFFF6B35),
  Color(0xFF6366F1),
  Color(0xFF84CC16),
  Color(0xFF94A3B8),
];

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  late DateTime _selectedMonth;
  bool _showAllCategories = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth =
          DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      _showAllCategories = false;
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    if (_selectedMonth.isBefore(currentMonth)) {
      setState(() {
        _selectedMonth =
            DateTime(_selectedMonth.year, _selectedMonth.month + 1);
        _showAllCategories = false;
      });
    }
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _selectedMonth.year == now.year &&
        _selectedMonth.month == now.month;
  }

  List<Transaction> _filterByMonth(
      List<Transaction> all, DateTime month) {
    return all
        .where((t) =>
            t.createdAt.year == month.year &&
            t.createdAt.month == month.month)
        .toList();
  }

  double _totalByType(List<Transaction> txns, TransactionType type) {
    return txns
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Map<String, double> _expenseByCategory(List<Transaction> txns) {
    final map = <String, double>{};
    for (final t
        in txns.where((t) => t.type == TransactionType.expense)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  String _formatAmount(double value) {
    if (value == value.truncateToDouble()) {
      return _addCommas(value.truncate().toString());
    }
    return _addCommas(value.toStringAsFixed(2));
  }

  String _addCommas(String s) {
    final parts = s.split('.');
    final intPart = parts[0];
    final result = StringBuffer();
    var count = 0;
    for (var i = intPart.length - 1; i >= 0; i--) {
      result.write(intPart[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    final formatted = result.toString().split('').reversed.join();
    return parts.length > 1 ? '$formatted.${parts[1]}' : formatted;
  }

  String _categoryDisplayName(
      String categoryId, AppLocalizations l10n) {
    final cat =
        ref.read(categoryProvider.notifier).getCategoryById(categoryId);
    if (cat == null) return resolveL10nKey(categoryId, l10n);
    if (!cat.isDefault) return cat.name;
    return resolveL10nKey(cat.name, l10n);
  }

  String _categoryEmoji(String categoryId) {
    final cat =
        ref.read(categoryProvider.notifier).getCategoryById(categoryId);
    return cat?.emoji ?? '\u{1F4DD}';
  }

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: AddTransactionSheet(
            onSave: (transaction) {
              ref.read(transactionProvider.notifier).add(transaction);
              Navigator.pop(sheetContext);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final allTransactions = ref.watch(transactionProvider);
    final monthTxns =
        _filterByMonth(allTransactions, _selectedMonth);
    final isEmpty = monthTxns.isEmpty;

    return Scaffold(
      backgroundColor:
          isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity == null) return;
            if (details.primaryVelocity! < -200) {
              _nextMonth();
            } else if (details.primaryVelocity! > 200) {
              _previousMonth();
            }
          },
          child: Column(
            children: [
              _buildMonthHeader(isDark, l10n),
              Expanded(
                child: isEmpty
                    ? _buildEmptyState(isDark, l10n)
                    : _buildContent(
                        isDark, l10n, monthTxns, allTransactions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Month header ──

  Widget _buildMonthHeader(bool isDark, AppLocalizations l10n) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _previousMonth,
            child: Icon(
              Icons.chevron_left_rounded,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.monthFormat(
                _selectedMonth.year, _selectedMonth.month),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : const Color(0xFF1E293B),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isCurrentMonth ? null : _nextMonth,
            child: Icon(
              Icons.chevron_right_rounded,
              color: _isCurrentMonth
                  ? (isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0))
                  : (isDark
                      ? HareruColors.darkTextTertiary
                      : const Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty state ──

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('\u{1F4CA}', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            l10n.noRecordsYet,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.noRecordsDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : const Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _openAddSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    HareruColors.primaryStart,
                    HareruColors.primaryEnd,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${l10n.startRecording} \u2192',
                style: const TextStyle(
                  fontSize: 14,
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

  // ── Main content ──

  Widget _buildContent(bool isDark, AppLocalizations l10n,
      List<Transaction> monthTxns, List<Transaction> allTxns) {
    final expenseTotal =
        _totalByType(monthTxns, TransactionType.expense);
    final incomeTotal =
        _totalByType(monthTxns, TransactionType.income);
    final transferTotal =
        _totalByType(monthTxns, TransactionType.transfer);
    final savingsTotal =
        _totalByType(monthTxns, TransactionType.savings);
    final remaining = incomeTotal - expenseTotal;
    final savingsRate = incomeTotal > 0
        ? (remaining / incomeTotal * 100)
        : null;
    final budget = ref.watch(budgetProvider);
    final categoryMap = _expenseByCategory(monthTxns);

    // Previous month for AI insight
    final prevMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    final prevTxns = _filterByMonth(allTxns, prevMonth);
    final prevExpenseTotal =
        _totalByType(prevTxns, TransactionType.expense);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSummaryCard(isDark, l10n, incomeTotal, expenseTotal,
              remaining, savingsRate),
          const SizedBox(height: 16),
          _buildCategoryDonutCard(
              isDark, l10n, categoryMap, expenseTotal),
          const SizedBox(height: 16),
          _buildBudgetCard(isDark, l10n, budget, expenseTotal),
          const SizedBox(height: 16),
          _buildTypeBreakdownCard(isDark, l10n, expenseTotal,
              transferTotal, savingsTotal, incomeTotal),
          const SizedBox(height: 16),
          _buildInsightCard(isDark, l10n, expenseTotal,
              prevExpenseTotal, incomeTotal, budget, categoryMap),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ── Card decoration ──

  BoxDecoration _cardDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? HareruColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  // ── Card 1: Summary ──

  Widget _buildSummaryCard(
      bool isDark,
      AppLocalizations l10n,
      double income,
      double expense,
      double remaining,
      double? savingsRate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(isDark),
      child: Column(
        children: [
          _summaryRow(l10n.income, '¥${_formatAmount(income)}',
              const Color(0xFFF59E0B), isDark),
          const SizedBox(height: 12),
          _summaryRow(l10n.realExpense, '¥${_formatAmount(expense)}',
              const Color(0xFFEF4444), isDark),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: isDark
                ? HareruColors.darkDivider
                : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 12),
          _summaryRow(
            l10n.remaining,
            '${remaining < 0 ? '-' : ''}¥${_formatAmount(remaining.abs())}',
            remaining >= 0
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
            isDark,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.savingsRate,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : const Color(0xFF64748B),
                ),
              ),
              Text(
                savingsRate != null
                    ? '${savingsRate.toStringAsFixed(1)}%'
                    : '--%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B82F6),
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      String label, String amount, Color amountColor, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? HareruColors.darkTextSecondary
                : const Color(0xFF64748B),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: amountColor,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  // ── Card 2: Category donut ──

  Widget _buildCategoryDonutCard(bool isDark, AppLocalizations l10n,
      Map<String, double> categoryMap, double expenseTotal) {
    if (categoryMap.isEmpty) return const SizedBox.shrink();

    final sorted = categoryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final displayCount =
        _showAllCategories ? sorted.length : sorted.length.clamp(0, 5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(isDark),
      child: Column(
        children: [
          // Donut chart
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections:
                        sorted.asMap().entries.map((entry) {
                      final colorIndex =
                          entry.key % _categoryColors.length;
                      return PieChartSectionData(
                        value: entry.value.value,
                        color: _categoryColors[colorIndex],
                        radius: 28,
                        showTitle: false,
                      );
                    }).toList(),
                    centerSpaceRadius: 62,
                    sectionsSpace: 2,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.realExpense,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? HareruColors.darkTextTertiary
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '¥${_formatAmount(expenseTotal)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? HareruColors.darkTextPrimary
                            : const Color(0xFF1E293B),
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Category list
          ...sorted
              .take(displayCount)
              .toList()
              .asMap()
              .entries
              .map((entry) {
            final i = entry.key;
            final e = entry.value;
            final colorIndex = i % _categoryColors.length;
            final percent = expenseTotal > 0
                ? (e.value / expenseTotal * 100)
                : 0.0;
            final emoji = _categoryEmoji(e.key);
            final name = _categoryDisplayName(e.key, l10n);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _categoryColors[colorIndex],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(emoji,
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? HareruColors.darkTextPrimary
                            : const Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '¥${_formatAmount(e.value)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : const Color(0xFF1E293B),
                      fontFeatures: const [
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${percent.toStringAsFixed(0)}%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                        fontFeatures: [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Show all / show less toggle
          if (sorted.length > 5)
            GestureDetector(
              onTap: () => setState(
                  () => _showAllCategories = !_showAllCategories),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _showAllCategories
                      ? l10n.showLess
                      : l10n.showAll,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Card 3: Budget progress ──

  Widget _buildBudgetCard(
      bool isDark, AppLocalizations l10n, int budget, double expense) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(isDark),
      child: budget > 0
          ? _buildBudgetProgress(isDark, l10n, budget, expense)
          : Center(
              child: Text(
                l10n.budgetNotSet,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? HareruColors.darkTextTertiary
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
    );
  }

  Widget _buildBudgetProgress(
      bool isDark, AppLocalizations l10n, int budget, double expense) {
    final progress = expense / budget;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(1);
    final remaining = budget - expense;
    final isOver = remaining < 0;

    final barColor = progress > 0.9
        ? const Color(0xFFEF4444)
        : progress > 0.7
            ? const Color(0xFFF59E0B)
            : const Color(0xFF3B82F6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${l10n.monthlyBudget}  ¥${_formatAmount(budget.toDouble())}',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? HareruColors.darkTextSecondary
                    : const Color(0xFF64748B),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: barColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: clampedProgress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isOver
              ? l10n.overBudget(
                  '¥${_formatAmount(remaining.abs())}')
              : l10n.remainingBudget(
                  '¥${_formatAmount(remaining)}'),
          style: TextStyle(
            fontSize: 13,
            color: isOver
                ? const Color(0xFFEF4444)
                : (isDark
                    ? HareruColors.darkTextSecondary
                    : const Color(0xFF64748B)),
          ),
        ),
      ],
    );
  }

  // ── Card 4: Type breakdown ──

  Widget _buildTypeBreakdownCard(
      bool isDark,
      AppLocalizations l10n,
      double expense,
      double transfer,
      double savings,
      double income) {
    final types = [
      (l10n.expense, expense, const Color(0xFFEF4444), false),
      (l10n.transfer, transfer, const Color(0xFF3B82F6), true),
      (l10n.savings, savings, const Color(0xFF10B981), true),
      (l10n.income, income, const Color(0xFFF59E0B), false),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(isDark),
      child: Column(
        children: types.asMap().entries.map((entry) {
          final i = entry.key;
          final (label, amount, color, showNote) = entry.value;

          return Padding(
            padding: EdgeInsets.only(bottom: i < 3 ? 12 : 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? HareruColors.darkTextPrimary
                              : const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                    Text(
                      '¥${_formatAmount(amount)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showNote)
                  Padding(
                    padding: const EdgeInsets.only(left: 18, top: 2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.notIncludedInReal,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Card 5: AI insight ──

  Widget _buildInsightCard(
      bool isDark,
      AppLocalizations l10n,
      double expense,
      double prevExpense,
      double income,
      int budget,
      Map<String, double> categoryMap) {
    final insights = <String>[];

    if (expense == 0 && income == 0) {
      insights.add(l10n.needMoreData);
    } else {
      // Compare with last month
      if (prevExpense > 0) {
        final diff = prevExpense - expense;
        if (diff > 0) {
          insights.add(l10n
              .savedComparedLastMonth('¥${_formatAmount(diff)}'));
        } else if (diff < 0) {
          insights.add(l10n.spentMoreThanLastMonth(
              '¥${_formatAmount(diff.abs())}'));
        }
      }

      // Top category
      if (categoryMap.isNotEmpty) {
        final sorted = categoryMap.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final top = sorted.first;
        final percent = expense > 0
            ? (top.value / expense * 100).toStringAsFixed(0)
            : '0';
        final name = _categoryDisplayName(top.key, l10n);
        insights.add(l10n.topCategory(name, percent));
      }

      // Budget status
      if (budget > 0) {
        final remaining = budget - expense;
        if (remaining >= 0) {
          insights.add(l10n.withinBudget);
        } else {
          insights.add(l10n.overBudgetReport(
              '¥${_formatAmount(remaining.abs())}'));
        }
      }

      if (insights.isEmpty) {
        insights.add(l10n.needMoreData);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            isDark ? const Color(0xFF0F2744) : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF1E3A5F)
              : const Color(0xFFBFDBFE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('\u2728',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                l10n.monthlyInsight,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? HareruColors.darkTextPrimary
                      : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...insights.map((text) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : const Color(0xFF1E293B),
                    height: 1.5,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
