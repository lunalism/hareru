import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/pay_day_provider.dart';
import 'package:hareru/core/providers/reminder_provider.dart';
import 'package:hareru/core/services/notification_service.dart';
import 'package:hareru/l10n/app_localizations.dart';

void showPayDayDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  var selected = ref.read(payDayProvider);
  if (selected == 0) selected = 25;

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor:
                isDark ? HareruColors.darkCard : HareruColors.lightCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              l10n.setPayDay,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
            ),
            content: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selected,
                isExpanded: true,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: HareruColors.primaryStart,
                ),
                dropdownColor:
                    isDark ? HareruColors.darkCard : HareruColors.lightCard,
                items: [
                  ...List.generate(
                    31,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 32,
                    child: Text(l10n.payDayEndOfMonth),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selected = value);
                  }
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(payDayProvider.notifier).setPayDay(selected);
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  l10n.save,
                  style: const TextStyle(
                    color: HareruColors.primaryStart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void showBudgetDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final currentBudget = ref.read(budgetProvider);
  final controller = TextEditingController(
    text: currentBudget > 0 ? currentBudget.toString() : '',
  );

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor:
            isDark ? HareruColors.darkCard : HareruColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.setBudgetTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            prefixText: '¥ ',
            prefixStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: HareruColors.primaryStart,
            ),
            hintText: '150000',
            hintStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? HareruColors.darkDivider
                    : HareruColors.lightDivider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: HareruColors.primaryStart,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: TextStyle(
                color: isDark
                    ? HareruColors.darkTextSecondary
                    : HareruColors.lightTextSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              ref.read(budgetProvider.notifier).setBudget(value);
              Navigator.pop(dialogContext);
            },
            child: Text(
              l10n.save,
              style: const TextStyle(
                color: HareruColors.primaryStart,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showReminderTimePicker(BuildContext context, WidgetRef ref) {
  final reminder = ref.read(reminderProvider);
  final parts = reminder.time.split(':');
  var hour = int.tryParse(parts[0]) ?? 21;
  var minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

  showCupertinoModalPopup<void>(
    context: context,
    builder: (_) => Container(
      height: 260,
      color: Theme.of(context).brightness == Brightness.dark
          ? HareruColors.darkCard
          : HareruColors.lightCard,
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: const TextStyle(
                      color: HareruColors.primaryStart,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    final timeStr =
                        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
                    ref.read(reminderProvider.notifier).setTime(timeStr);
                    _scheduleReminder(context, ref);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              initialDateTime: DateTime(2026, 1, 1, hour, minute),
              onDateTimeChanged: (dt) {
                hour = dt.hour;
                minute = dt.minute;
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> toggleReminder(
  BuildContext context,
  WidgetRef ref,
  bool enabled,
) async {
  if (enabled) {
    final granted = await NotificationService.requestPermission();
    if (!granted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.enableNotificationInSettings),
          ),
        );
      }
      return;
    }
  }

  await ref.read(reminderProvider.notifier).setEnabled(enabled);

  if (enabled) {
    if (context.mounted) {
      await _scheduleReminder(context, ref);
    }
  } else {
    await NotificationService.cancelAll();
  }
}

Future<void> _scheduleReminder(BuildContext context, WidgetRef ref) async {
  final reminder = ref.read(reminderProvider);
  if (!reminder.enabled) return;

  final l10n = AppLocalizations.of(context)!;
  final parts = reminder.time.split(':');
  final hour = int.tryParse(parts[0]) ?? 21;
  final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

  await NotificationService.scheduleDailyReminder(
    hour: hour,
    minute: minute,
    title: l10n.reminderTitle,
    body: l10n.reminderBody,
  );
}
