import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/custom_colors.dart';
import '../providers/home_provider.dart';

class WeeklyTrendChart extends ConsumerStatefulWidget {
  const WeeklyTrendChart({super.key});

  @override
  ConsumerState<WeeklyTrendChart> createState() => _WeeklyTrendChartState();
}

class _WeeklyTrendChartState extends ConsumerState<WeeklyTrendChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _weekLabels(AppLocalizations l10n) {
    return [l10n.mon, l10n.tue, l10n.wed, l10n.thu, l10n.fri, l10n.sat, l10n.sun];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final weeklyData = ref.watch(weeklyExpensesProvider);
    final amounts = weeklyData.map((d) => d.amount);
    final maxAmount = amounts.isEmpty ? 0 : amounts.reduce((a, b) => a > b ? a : b);
    final formatter = NumberFormat('#,###');
    final todayWeekday = DateTime.now().weekday;
    final labels = _weekLabels(l10n);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.thisWeekExpense,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(weeklyData.length, (index) {
            final data = weeklyData[index];
            final isToday = (index + 1) == todayWeekday;
            final barRatio =
                maxAmount > 0 ? data.amount / maxAmount : 0.0;
            final highlightColor = theme.colorScheme.primary;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 12,
                        color: isToday ? highlightColor : custom.nightLight,
                        fontWeight:
                            isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: data.isFuture
                        ? const SizedBox.shrink()
                        : AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final animatedRatio = CurvedAnimation(
                                parent: _controller,
                                curve: Curves.easeOutCubic,
                              ).value;
                              return _buildBar(
                                barRatio * animatedRatio,
                                isToday,
                                theme,
                              );
                            },
                          ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      data.isFuture
                          ? 'ー'
                          : '¥${formatter.format(data.amount)}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 12,
                        color: isToday ? highlightColor : custom.nightLight,
                        fontWeight:
                            isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${l10n.today})',
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 10,
                        color: highlightColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBar(double ratio, bool isToday, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth * ratio;
        return Container(
          height: 12,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            width: barWidth,
            height: 12,
            decoration: BoxDecoration(
              color: isToday
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }
}
