import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../providers/report_providers.dart';

class PeriodNavigator extends ConsumerWidget {
  const PeriodNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(reportPeriodProvider);
    final refDate = ref.watch(reportReferenceDateProvider);
    final isLatest = ref.watch(reportIsLatestPeriodProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 24),
            onPressed: () => _navigate(ref, period, refDate, -1),
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Text(
            _periodLabel(l10n, period, refDate),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.chevron_right,
                size: 24,
                color: isLatest
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.15)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            onPressed: isLatest ? null : () => _navigate(ref, period, refDate, 1),
          ),
        ],
      ),
    );
  }

  void _navigate(WidgetRef ref, ReportPeriod period, DateTime refDate, int dir) {
    DateTime next;
    switch (period) {
      case ReportPeriod.weekly:
        next = refDate.add(Duration(days: 7 * dir));
      case ReportPeriod.monthly:
        next = DateTime(refDate.year, refDate.month + dir, refDate.day > 28 ? 28 : refDate.day);
      case ReportPeriod.yearly:
        next = DateTime(refDate.year + dir, refDate.month, refDate.day);
    }
    ref.read(reportReferenceDateProvider.notifier).state = next;
  }

  String _periodLabel(AppLocalizations l10n, ReportPeriod period, DateTime refDate) {
    switch (period) {
      case ReportPeriod.weekly:
        final weekday = refDate.weekday;
        final monday = DateTime(refDate.year, refDate.month, refDate.day)
            .subtract(Duration(days: weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        return l10n.weekRangeFormat(
            monday.month, monday.day, sunday.month, sunday.day);
      case ReportPeriod.monthly:
        return l10n.monthFormat(refDate.year, refDate.month);
      case ReportPeriod.yearly:
        return l10n.yearFormat(refDate.year);
    }
  }
}
