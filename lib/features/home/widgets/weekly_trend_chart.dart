import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
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
    // Start animation after a short delay for staggered effect
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyData = ref.watch(weeklyExpensesProvider);
    final maxAmount =
        weeklyData.map((d) => d.amount).reduce((a, b) => a > b ? a : b);
    final formatter = NumberFormat('#,###');
    final todayWeekday = DateTime.now().weekday; // 1=Mon

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
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
          Text('今週の支出', style: AppTypography.sectionHeader),
          const SizedBox(height: 16),
          ...List.generate(weeklyData.length, (index) {
            final data = weeklyData[index];
            final isToday = (index + 1) == todayWeekday;
            final barRatio =
                maxAmount > 0 ? data.amount / maxAmount : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: Text(
                      data.label,
                      style: AppTypography.caption.copyWith(
                        color:
                            isToday ? AppColors.skyBlueDark : AppColors.nightLight,
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
                      style: AppTypography.caption.copyWith(
                        color:
                            isToday ? AppColors.skyBlueDark : AppColors.nightLight,
                        fontWeight:
                            isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(今日)',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.skyBlueDark,
                        fontSize: 10,
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

  Widget _buildBar(double ratio, bool isToday) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth * ratio;
        return Container(
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            width: barWidth,
            height: 12,
            decoration: BoxDecoration(
              color: isToday ? AppColors.skyBlueDark : AppColors.skyBlue,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }
}
