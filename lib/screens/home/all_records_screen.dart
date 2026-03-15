import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/date_formatter.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/record_detail_screen.dart';
import 'package:hareru/widgets/delete_confirmation_dialog.dart';
import 'package:hareru/widgets/transaction_record_item.dart';
import 'package:table_calendar/table_calendar.dart';

class AllRecordsScreen extends ConsumerStatefulWidget {
  const AllRecordsScreen({super.key});

  @override
  ConsumerState<AllRecordsScreen> createState() => _AllRecordsScreenState();
}

class _AllRecordsScreenState extends ConsumerState<AllRecordsScreen> {
  bool _isCalendarView = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  // ── Helpers ──

  Map<DateTime, List<Transaction>> _groupByDate(List<Transaction> txns) {
    final grouped = <DateTime, List<Transaction>>{};
    for (final t in txns) {
      final key =
          DateTime(t.createdAt.year, t.createdAt.month, t.createdAt.day);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }

  double _dayExpenseTotal(List<Transaction> txns) {
    return txns
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Color _amountColor(double amount) {
    if (amount <= 3000) return HareruColors.savings;
    if (amount <= 10000) return HareruColors.income;
    return HareruColors.expense;
  }

  String _compactAmount(double amount) {
    if (amount >= 1000) {
      final k = amount / 1000;
      if (k == k.truncateToDouble()) return '${k.toInt()}k';
      return '${k.toStringAsFixed(1)}k';
    }
    if (amount == amount.truncateToDouble()) return amount.toInt().toString();
    return amount.toStringAsFixed(0);
  }

  String _dateHeader(DateTime date, AppLocalizations l10n, String lang) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return l10n.today;
    if (date == yesterday) return l10n.yesterday;

    return switch (lang) {
      'ko' => '${date.month}월 ${date.day}일',
      'en' => '${monthNameEn(date.month)} ${date.day}',
      _ => '${date.month}月${date.day}日',
    };
  }

  String _dateHeaderWithWeekday(
      DateTime date, AppLocalizations l10n, String lang) {
    final wd = date.weekday; // 1=Mon ... 7=Sun
    final wdLabel = switch (lang) {
      'ko' => const ['월', '화', '수', '목', '금', '토', '일'][wd - 1],
      'en' => const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][wd - 1],
      _ => const ['月', '火', '水', '木', '金', '土', '日'][wd - 1],
    };
    return switch (lang) {
      'ko' => '${date.month}월 ${date.day}일 ($wdLabel)',
      'en' => '$wdLabel, ${monthNameEn(date.month)} ${date.day}',
      _ => '${date.month}月${date.day}日($wdLabel)',
    };
  }


  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    l10n.allRecords,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Toggle
            _buildToggle(isDark, l10n),
            const SizedBox(height: 12),

            // Content
            Expanded(
              child: _isCalendarView
                  ? _buildCalendarView(
                      isDark, l10n, lang, transactions)
                  : _buildListView(isDark, l10n, lang, _monthlyTransactions(transactions)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Toggle ──

  Widget _buildToggle(bool isDark, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? HareruColors.darkDivider : HareruColors.lightBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            _toggleButton(
              label: l10n.listView,
              icon: Icons.list_rounded,
              isSelected: !_isCalendarView,
              isDark: isDark,
              onTap: () => setState(() => _isCalendarView = false),
            ),
            _toggleButton(
              label: l10n.calendarView,
              icon: Icons.calendar_month_rounded,
              isSelected: _isCalendarView,
              isDark: isDark,
              onTap: () => setState(() => _isCalendarView = true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isSelected ? HareruColors.primaryStart : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : HareruColors.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : HareruColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ──

  List<Transaction> _monthlyTransactions(List<Transaction> transactions) {
    final now = DateTime.now();
    return transactions
        .where(
            (t) => t.createdAt.year == now.year && t.createdAt.month == now.month)
        .toList();
  }

  // ── List View ──

  Widget _buildListView(bool isDark, AppLocalizations l10n, String lang,
      List<Transaction> monthly) {
    if (monthly.isEmpty) {
      return _buildEmptyState(isDark, l10n);
    }

    final grouped = _groupByDate(monthly);
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      itemCount: sortedDates.length,
      itemBuilder: (context, sectionIndex) {
        final date = sortedDates[sectionIndex];
        final items = grouped[date] ?? [];
        final dateLabel = _dateHeader(date, l10n, lang);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sectionIndex > 0) const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
                ),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: items.asMap().entries.map((entry) {
                  final i = entry.key;
                  final t = entry.value;
                  return Column(
                    children: [
                      _buildRecordItem(t, isDark, l10n),
                      if (i < items.length - 1)
                        Divider(
                          height: 1,
                          indent: 70,
                          color: isDark
                              ? HareruColors.darkDivider
                              : HareruColors.lightDivider,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Calendar View ──

  Widget _buildCalendarView(bool isDark, AppLocalizations l10n, String lang,
      List<Transaction> transactions) {
    final grouped = _groupByDate(transactions);

    // Expense totals per day for markers
    final dayExpenses = <DateTime, double>{};
    for (final entry in grouped.entries) {
      final expense = _dayExpenseTotal(entry.value);
      if (expense > 0) dayExpenses[entry.key] = expense;
    }

    final selectedDate = _selectedDay != null
        ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
        : null;
    final selectedItems = selectedDate != null ? grouped[selectedDate] ?? [] : <Transaction>[];

    return Column(
      children: [
        // Calendar
        _buildCalendarWidget(
            isDark, l10n, lang, grouped, dayExpenses),
        const SizedBox(height: 8),

        // Selected day records
        Expanded(
          child: _buildSelectedDayRecords(
              isDark, l10n, lang, selectedItems, selectedDate),
        ),
      ],
    );
  }

  Widget _buildCalendarWidget(
    bool isDark,
    AppLocalizations l10n,
    String lang,
    Map<DateTime, List<Transaction>> grouped,
    Map<DateTime, double> dayExpenses,
  ) {
    final headerColor = isDark
        ? HareruColors.darkTextPrimary
        : HareruColors.lightTextPrimary;

    return TableCalendar<Transaction>(
      firstDay: DateTime(2020, 1, 1),
      lastDay: DateTime(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      startingDayOfWeek: StartingDayOfWeek.sunday,
      rowHeight: 56,
      daysOfWeekHeight: 28,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left_rounded, color: headerColor),
        rightChevronIcon: Icon(Icons.chevron_right_rounded, color: headerColor),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: headerColor,
        ),
        titleTextFormatter: (date, locale) => switch (lang) {
          'ko' => '${date.year}년 ${date.month}월',
          'en' => '${fullMonthNameEn(date.month)} ${date.year}',
          _ => '${date.year}年${date.month}月',
        },
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (date, locale) {
          final wd = date.weekday; // 1=Mon ... 7=Sun
          return switch (lang) {
            'ko' => const [
                '월', '화', '수', '목', '금', '토', '일'
              ][wd - 1],
            'en' => const [
                'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
              ][wd - 1],
            _ => const ['月', '火', '水', '木', '金', '土', '日'][wd - 1],
          };
        },
        weekdayStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: HareruColors.lightTextTertiary,
        ),
        weekendStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: HareruColors.lightTextTertiary,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        cellMargin: EdgeInsets.zero,
        cellPadding: EdgeInsets.zero,
        // Today
        todayDecoration: BoxDecoration(
          color: const Color(0xFFE8453C).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: HareruColors.primaryStart,
        ),
        // Selected
        selectedDecoration: BoxDecoration(
          color: HareruColors.primaryStart,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        // Default
        defaultTextStyle: TextStyle(
          fontSize: 14,
          color: isDark ? HareruColors.lightBg : HareruColors.lightTextPrimary,
        ),
        // Weekend
        weekendTextStyle: TextStyle(
          fontSize: 14,
          color: isDark ? HareruColors.lightBg : HareruColors.lightTextPrimary,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        // Custom day of week builder for coloring Sun/Sat
        dowBuilder: (context, day) {
          final wd = day.weekday;
          final label = switch (lang) {
            'ko' => const [
                '월', '화', '수', '목', '금', '토', '일'
              ][wd - 1],
            'en' => const [
                'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
              ][wd - 1],
            _ => const ['月', '火', '水', '木', '金', '土', '日'][wd - 1],
          };
          final color = wd == 7
              ? HareruColors.expense
              : wd == 6
                  ? HareruColors.lightTextSecondary
                  : HareruColors.lightTextSecondary;
          return Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          );
        },
        // Default day
        defaultBuilder: (context, day, focusedDay) =>
            _buildDayCell(day, isDark, dayExpenses, isToday: false, isSelected: false),
        // Today
        todayBuilder: (context, day, focusedDay) =>
            _buildDayCell(day, isDark, dayExpenses, isToday: true, isSelected: false),
        // Selected
        selectedBuilder: (context, day, focusedDay) =>
            _buildDayCell(day, isDark, dayExpenses, isToday: false, isSelected: true),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() => _focusedDay = focusedDay);
      },
    );
  }

  Widget _buildDayCell(
    DateTime day,
    bool isDark,
    Map<DateTime, double> dayExpenses, {
    required bool isToday,
    required bool isSelected,
  }) {
    final key = DateTime(day.year, day.month, day.day);
    final expense = dayExpenses[key];
    final hasExpense = expense != null && expense > 0;
    final isSun = day.weekday == 7;
    final isSat = day.weekday == 6;

    // Text color
    Color textColor;
    if (isSelected) {
      textColor = Colors.white;
    } else if (isToday) {
      textColor = HareruColors.primaryStart;
    } else if (isSun) {
      textColor = HareruColors.expense;
    } else if (isSat) {
      textColor = HareruColors.primaryStart;
    } else {
      textColor =
          isDark ? HareruColors.lightBg : HareruColors.lightTextPrimary;
    }

    return SizedBox(
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Date number with circle
          Container(
            width: 28,
            height: 28,
            decoration: isSelected
                ? BoxDecoration(
                    color: HareruColors.primaryStart,
                    shape: BoxShape.circle,
                  )
                : isToday
                    ? BoxDecoration(
                        color:
                            const Color(0xFFE8453C).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      )
                    : null,
            alignment: Alignment.center,
            child: Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    (isToday || isSelected) ? FontWeight.w700 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          if (hasExpense) ...[
            const SizedBox(height: 1),
            // Dot
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: _amountColor(expense),
                shape: BoxShape.circle,
              ),
            ),
            // Compact amount
            Text(
              _compactAmount(expense),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: _amountColor(expense),
              ),
            ),
          ] else
            const SizedBox(height: 15),
        ],
      ),
    );
  }

  // ── Selected day records below calendar ──

  Widget _buildSelectedDayRecords(bool isDark, AppLocalizations l10n,
      String lang, List<Transaction> items, DateTime? selectedDate) {
    if (selectedDate == null || items.isEmpty) {
      return Center(
        child: Text(
          l10n.noRecordsForDay,
          style: TextStyle(fontSize: 14, color: HareruColors.lightTextTertiary),
        ),
      );
    }

    final dayLabel = _dateHeaderWithWeekday(selectedDate, l10n, lang);
    final expenseTotal = _dayExpenseTotal(items);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            dayLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final t = entry.value;
              return Column(
                children: [
                  _buildRecordItem(t, isDark, l10n),
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 70,
                      color: isDark
                          ? HareruColors.darkDivider
                          : HareruColors.lightDivider,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        if (expenseTotal > 0) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                '${l10n.dailyTotal}: -\u00a5${formatAmount(expenseTotal)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HareruColors.expense,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // ── Shared record item ──

  Widget _buildRecordItem(
      Transaction t, bool isDark, AppLocalizations l10n) {
    final catNotifier = ref.read(categoryProvider.notifier);
    final emoji = emojiForCategory(t.category, t.type, catNotifier);
    final title = t.memo ?? categoryLabel(t.category, l10n, catNotifier);
    final hour = t.createdAt.hour.toString().padLeft(2, '0');
    final minute = t.createdAt.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    return Dismissible(
      key: Key(t.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: HareruColors.expense,
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 24),
      ),
      confirmDismiss: (_) => showDeleteConfirmation(
              context: context, l10n: l10n, isDark: isDark),
      onDismissed: (_) {
        ref.read(transactionProvider.notifier).delete(t.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.recordDeleted)),
        );
      },
      child: TransactionRecordItem(
        emoji: emoji,
        title: title,
        subtitle: time,
        transaction: t,
        isDark: isDark,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecordDetailScreen(transaction: t),
          ),
        ),
      ),
    );
  }

  // ── Empty state ──

  Widget _buildEmptyState(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: isDark
                ? HareruColors.darkTextTertiary
                : HareruColors.lightTextTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noRecordsEmpty,
            style: TextStyle(
              fontSize: 15,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
