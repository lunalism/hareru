import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../domain/daily_expense.dart';
import '../../providers/report_providers.dart';

class TrendBarCard extends ConsumerStatefulWidget {
  const TrendBarCard({super.key});

  @override
  ConsumerState<TrendBarCard> createState() => _TrendBarCardState();
}

class _TrendBarCardState extends ConsumerState<TrendBarCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(reportPeriodProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0');

    final List<ReportDailyExpense> data;
    if (period == ReportPeriod.yearly) {
      data = ref.watch(reportMonthlyExpensesProvider);
    } else {
      data = ref.watch(reportDailyExpensesProvider);
    }

    if (data.isEmpty) return const SizedBox.shrink();

    final amounts = data.map((d) => d.amount).toList();
    final maxAmount = amounts.isEmpty
        ? 1.0
        : amounts.reduce((a, b) => a > b ? a : b).toDouble();
    final maxY = maxAmount == 0 ? 1000.0 : maxAmount * 1.2;
    final average =
        amounts.isEmpty ? 0 : amounts.reduce((a, b) => a + b) ~/ amounts.length;

    // For monthly mode with many bars, use horizontal scroll
    final needsScroll = period == ReportPeriod.monthly && data.length > 14;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: theme.brightness == Brightness.light
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))]
            : null,
        border: theme.brightness == Brightness.dark
            ? Border.all(color: theme.colorScheme.outline)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.expenseTrend,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final chart = SizedBox(
                height: 200,
                width: needsScroll ? data.length * 22.0 : null,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            '¥${fmt.format(rod.toY.round())}',
                            TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.spot == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex =
                              response.spot!.touchedBarGroupIndex;
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: !needsScroll,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Text(
                              _formatShortAmount(value.round()),
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= data.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _bottomLabel(context, period, data[i], i, data.length),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 4,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        strokeWidth: 0.5,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    extraLinesData: ExtraLinesData(
                      horizontalLines: [
                        HorizontalLine(
                          y: average.toDouble(),
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                          strokeWidth: 1,
                          dashArray: [4, 4],
                        ),
                      ],
                    ),
                    barGroups: data.asMap().entries.map((entry) {
                      final i = entry.key;
                      final d = entry.value;
                      final isTouched = i == _touchedIndex;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: d.amount.toDouble() * _animation.value,
                            color: isTouched
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withValues(alpha: 0.7),
                            width: _barWidth(period, data.length),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4)),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );

              if (needsScroll) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: chart,
                );
              }
              return chart;
            },
          ),
          const SizedBox(height: 8),
          // Average line label
          Row(
            children: [
              Container(
                width: 16,
                height: 1,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.dailyAverage(fmt.format(average)),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _barWidth(ReportPeriod period, int count) {
    switch (period) {
      case ReportPeriod.weekly:
        return 28;
      case ReportPeriod.monthly:
        return count > 14 ? 14 : 16;
      case ReportPeriod.yearly:
        return 20;
    }
  }

  String _bottomLabel(BuildContext context, ReportPeriod period,
      ReportDailyExpense d, int index, int total) {
    final l10n = AppLocalizations.of(context)!;
    switch (period) {
      case ReportPeriod.weekly:
        const days = ['', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
        final dayKey = days[d.date.weekday];
        switch (dayKey) {
          case 'mon': return l10n.mon;
          case 'tue': return l10n.tue;
          case 'wed': return l10n.wed;
          case 'thu': return l10n.thu;
          case 'fri': return l10n.fri;
          case 'sat': return l10n.sat;
          case 'sun': return l10n.sun;
          default: return '';
        }
      case ReportPeriod.monthly:
        // Show every 5th day or first/last
        if (index == 0 || index == total - 1 || (index + 1) % 5 == 0) {
          return '${d.date.day}';
        }
        return '';
      case ReportPeriod.yearly:
        return '${d.date.month}';
    }
  }

  String _formatShortAmount(int amount) {
    if (amount >= 10000) return '¥${amount ~/ 10000}만';
    if (amount >= 1000) return '¥${(amount / 1000).toStringAsFixed(0)}k';
    return '¥$amount';
  }
}
