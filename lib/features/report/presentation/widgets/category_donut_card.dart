import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/default_categories.dart';
import '../../domain/category_expense.dart';
import '../../providers/report_providers.dart';

class CategoryDonutCard extends ConsumerStatefulWidget {
  const CategoryDonutCard({super.key});

  @override
  ConsumerState<CategoryDonutCard> createState() => _CategoryDonutCardState();
}

class _CategoryDonutCardState extends ConsumerState<CategoryDonutCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _animation;
  int _touchedIndex = -1;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
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
    final categories = ref.watch(reportCategoryExpensesProvider);
    final realExpense = ref.watch(reportRealExpenseProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final fmt = NumberFormat('#,##0');

    if (categories.isEmpty) return const SizedBox.shrink();

    final displayCount = _expanded ? categories.length : categories.length.clamp(0, 5);
    final displayCategories = categories.take(displayCount).toList();
    final hasMore = categories.length > 5 && !_expanded;

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
            l10n.categoryBreakdown,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          // Donut chart
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        startDegreeOffset: -90,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response == null ||
                                  response.touchedSection == null) {
                                _touchedIndex = -1;
                                return;
                              }
                              _touchedIndex =
                                  response.touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sections: categories.asMap().entries.map((entry) {
                          final i = entry.key;
                          final cat = entry.value;
                          final isTouched = i == _touchedIndex;
                          return PieChartSectionData(
                            value: cat.amount.toDouble() * _animation.value,
                            color: cat.color,
                            radius: isTouched ? 35 : 30,
                            showTitle: false,
                          );
                        }).toList(),
                      ),
                    ),
                    // Center text
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '¥${fmt.format(realExpense)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          l10n.realExpense,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Legend list
          ...displayCategories.asMap().entries.map((entry) {
            final i = entry.key;
            final cat = entry.value;
            final isTouched = i == _touchedIndex;
            final displayName = _resolveCategoryName(context, cat);
            return Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: isTouched
                  ? BoxDecoration(
                      color: cat.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cat.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(
                    displayName,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    '¥${fmt.format(cat.amount)}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${cat.percentage.round()}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          if (hasMore) ...[
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _expanded = true),
                child: Text(
                  '+ ${categories.length - 5}개 ${l10n.showMore} ▼',
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _resolveCategoryName(BuildContext context, CategoryExpense cat) {
    // Try to resolve via DefaultCategories display name
    for (final entry in DefaultCategories.expense) {
      if (entry.localeKey == cat.categoryKey) {
        return entry.getDisplayName(context);
      }
    }
    for (final entry in DefaultCategories.income) {
      if (entry.localeKey == cat.categoryKey) {
        return entry.getDisplayName(context);
      }
    }
    return cat.categoryName;
  }
}
