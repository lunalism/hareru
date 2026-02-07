import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../providers/report_providers.dart';

class PeriodSegment extends ConsumerWidget {
  const PeriodSegment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(reportPeriodProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: ReportPeriod.values.map((period) {
          final isSelected = period == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                ref.read(reportPeriodProvider.notifier).state = period;
                ref.read(reportReferenceDateProvider.notifier).state =
                    DateTime.now();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  _label(l10n, period),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(AppLocalizations l10n, ReportPeriod period) {
    switch (period) {
      case ReportPeriod.weekly:
        return l10n.periodWeekly;
      case ReportPeriod.monthly:
        return l10n.periodMonthly;
      case ReportPeriod.yearly:
        return l10n.periodYearly;
    }
  }
}
