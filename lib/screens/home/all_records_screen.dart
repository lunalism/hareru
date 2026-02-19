import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/record_detail_screen.dart';
import 'package:hareru/widgets/type_badge.dart';
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
    if (amount <= 3000) return const Color(0xFF10B981);
    if (amount <= 10000) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
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
      'en' => '${_monthNameEn(date.month)} ${date.day}',
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
      'en' => '$wdLabel, ${_monthNameEn(date.month)} ${date.day}',
      _ => '${date.month}月${date.day}日($wdLabel)',
    };
  }

  String _monthNameEn(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  String _fullMonthNameEn(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }

  String _formatAmount(double value) {
    final intVal = value.truncateToDouble() == value ? value.toInt() : value;
    final s = intVal.toString();
    if (s.contains('.')) {
      final parts = s.split('.');
      return '${_addCommas(parts[0])}.${parts[1]}';
    }
    return _addCommas(s);
  }

  String _addCommas(String s) {
    final result = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      result.write(s[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    return result.toString().split('').reversed.join();
  }

  Future<bool> _confirmDelete(AppLocalizations l10n, bool isDark) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            isDark ? HareruColors.darkCard : HareruColors.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deleteConfirm,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ),
        content: Text(
          l10n.deleteConfirmSub,
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deleteRecord,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final transactions = ref.watch(transactionProvider);

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
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
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : HareruColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    l10n.allRecords,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? HareruColors.darkTextPrimary
                          : HareruColors.lightTextPrimary,
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
                  : _buildListView(isDark, l10n, lang, transactions),
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
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
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
            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
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
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── List View ──

  Widget _buildListView(bool isDark, AppLocalizations l10n, String lang,
      List<Transaction> transactions) {
    final now = DateTime.now();
    final monthly = transactions
        .where(
            (t) => t.createdAt.year == now.year && t.createdAt.month == now.month)
        .toList();

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
        final items = grouped[date]!;
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
          'en' => '${_fullMonthNameEn(date.month)} ${date.year}',
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
        weekdayStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF94A3B8),
        ),
        weekendStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF94A3B8),
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        cellMargin: EdgeInsets.zero,
        cellPadding: EdgeInsets.zero,
        // Today
        todayDecoration: BoxDecoration(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3B82F6),
        ),
        // Selected
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF3B82F6),
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
          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
        ),
        // Weekend
        weekendTextStyle: TextStyle(
          fontSize: 14,
          color: isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
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
              ? const Color(0xFFEF4444)
              : wd == 6
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF94A3B8);
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
      textColor = const Color(0xFF3B82F6);
    } else if (isSun) {
      textColor = const Color(0xFFEF4444);
    } else if (isSat) {
      textColor = const Color(0xFF3B82F6);
    } else {
      textColor =
          isDark ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B);
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
                ? const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  )
                : isToday
                    ? BoxDecoration(
                        color:
                            const Color(0xFF3B82F6).withValues(alpha: 0.2),
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
          style: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
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
                '${l10n.dailyTotal}: -\u00a5${_formatAmount(expenseTotal)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
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
    final isExpense = t.type == TransactionType.expense;
    final isIncome = t.type == TransactionType.income;
    final cat =
        ref.read(categoryProvider.notifier).getCategoryById(t.category);
    final emoji = cat?.emoji ?? '\u{1F4DD}';
    final catLabel = cat == null
        ? resolveL10nKey(t.category, l10n)
        : cat.isDefault
            ? resolveL10nKey(cat.name, l10n)
            : cat.name;
    final title = t.memo ?? catLabel;
    final hour = t.createdAt.hour.toString().padLeft(2, '0');
    final minute = t.createdAt.minute.toString().padLeft(2, '0');
    final time = '$hour:$minute';

    return Dismissible(
      key: Key(t.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: const Color(0xFFEF4444),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 24),
      ),
      confirmDismiss: (_) => _confirmDelete(l10n, isDark),
      onDismissed: (_) {
        ref.read(transactionProvider.notifier).delete(t.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.recordDeleted)),
        );
      },
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecordDetailScreen(transaction: t),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isDark ? HareruColors.darkBg : HareruColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? HareruColors.darkTextPrimary
                                  : HareruColors.lightTextPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        TypeBadge(type: t.type),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? HareruColors.darkTextTertiary
                            : HareruColors.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isExpense ? '-' : isIncome ? '+' : ''}\u00a5${_formatAmount(t.amount)}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isIncome
                      ? const Color(0xFFF59E0B)
                      : isExpense
                          ? (isDark
                              ? HareruColors.darkTextPrimary
                              : HareruColors.lightTextPrimary)
                          : const Color(0xFF64748B),
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
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
