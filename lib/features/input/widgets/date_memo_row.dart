import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/input_provider.dart';

class DateMemoRow extends ConsumerWidget {
  const DateMemoRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(inputProvider);
    final date = formState.effectiveDate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Date picker
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                ref.read(inputProvider.notifier).setDate(picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(date, context),
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Memo field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.memo,
                  hintStyle: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  icon: Icon(
                    Icons.edit_note_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
                onChanged: (value) {
                  ref.read(inputProvider.notifier).setMemo(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      final l10n = AppLocalizations.of(context)!;
      return l10n.today;
    }
    return DateFormat('M/d').format(date);
  }
}
