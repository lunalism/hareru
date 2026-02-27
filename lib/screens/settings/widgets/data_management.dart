import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/dark_mode_provider.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/core/providers/pay_day_provider.dart';
import 'package:hareru/core/providers/reminder_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/core/services/notification_service.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat;
import 'package:hareru/models/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

Future<void> backupData() async {
  final settingsBox = await Hive.openBox<dynamic>('settings');
  final transactionsBox = await Hive.openBox<Transaction>('transactions');
  final categoriesBox = await Hive.openBox<cat.Category>('categories');

  final settings = <String, dynamic>{};
  for (final key in settingsBox.keys) {
    settings[key.toString()] = settingsBox.get(key);
  }

  final transactions = transactionsBox.values.map((t) => {
        'id': t.id,
        'type': t.type.index,
        'amount': t.amount,
        'category': t.category,
        'memo': t.memo,
        'createdAt': t.createdAt.toIso8601String(),
      }).toList();

  final categories = categoriesBox.values.map((c) => {
        'id': c.id,
        'name': c.name,
        'emoji': c.emoji,
        'type': c.type,
        'sortOrder': c.sortOrder,
        'isDefault': c.isDefault,
        'createdAt': c.createdAt.toIso8601String(),
      }).toList();

  final backup = {
    'version': '1.0.0',
    'exportDate': DateTime.now().toIso8601String(),
    'settings': settings,
    'categories': categories,
    'transactions': transactions,
  };

  final jsonStr = const JsonEncoder.withIndent('  ').convert(backup);
  final now = DateTime.now();
  final fileName =
      'hareru_backup_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}.json';

  await Share.share(jsonStr, subject: fileName);
}

Future<void> restoreData(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor:
          isDark ? HareruColors.darkCard : HareruColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.restoreData,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark
              ? HareruColors.darkTextPrimary
              : HareruColors.lightTextPrimary,
        ),
      ),
      content: Text(
        l10n.restoreConfirm,
        style: TextStyle(
          color: isDark
              ? HareruColors.darkTextSecondary
              : HareruColors.lightTextSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel,
              style: TextStyle(
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.restoreData,
              style: const TextStyle(
                  color: HareruColors.primaryStart,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;

  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result == null || result.files.isEmpty) return;

  try {
    final file = result.files.first;
    final bytes = file.bytes;
    if (bytes == null) return;

    final jsonStr = utf8.decode(bytes);
    final data = json.decode(jsonStr) as Map<String, dynamic>;

    if (data['settings'] is Map) {
      final settingsBox = await Hive.openBox<dynamic>('settings');
      final settingsData = data['settings'] as Map<String, dynamic>;
      for (final entry in settingsData.entries) {
        await settingsBox.put(entry.key, entry.value);
      }
    }

    if (data['categories'] is List) {
      final categoriesBox = await Hive.openBox<cat.Category>('categories');
      await categoriesBox.clear();
      for (final item in data['categories'] as List) {
        final m = item as Map<String, dynamic>;
        final c = cat.Category(
          id: m['id'] as String,
          name: m['name'] as String,
          emoji: m['emoji'] as String,
          type: m['type'] as String,
          sortOrder: m['sortOrder'] as int,
          isDefault: m['isDefault'] as bool,
          createdAt: DateTime.parse(m['createdAt'] as String),
        );
        await categoriesBox.put(c.id, c);
      }
    }

    if (data['transactions'] is List) {
      final transactionsBox =
          await Hive.openBox<Transaction>('transactions');
      await transactionsBox.clear();
      for (final item in data['transactions'] as List) {
        final m = item as Map<String, dynamic>;
        final t = Transaction(
          id: m['id'] as String,
          type: TransactionType.values[m['type'] as int],
          amount: (m['amount'] as num).toDouble(),
          category: m['category'] as String,
          memo: m['memo'] as String?,
          createdAt: DateTime.parse(m['createdAt'] as String),
        );
        await transactionsBox.put(t.id, t);
      }
    }

    _invalidateAll(ref);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.restoreData)),
      );
    }
  } catch (_) {
    // Invalid file
  }
}

Future<void> resetData(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  // 1st confirmation
  final firstConfirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor:
          isDark ? HareruColors.darkCard : HareruColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.resetData,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark
              ? HareruColors.darkTextPrimary
              : HareruColors.lightTextPrimary,
        ),
      ),
      content: Text(
        l10n.resetConfirm,
        style: TextStyle(
          color: isDark
              ? HareruColors.darkTextSecondary
              : HareruColors.lightTextSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel,
              style: TextStyle(
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.reset,
              style: const TextStyle(
                  color: HareruColors.expense, fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );

  if (firstConfirm != true || !context.mounted) return;

  // 2nd confirmation with keyword input
  final controller = TextEditingController();
  final secondConfirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          backgroundColor:
              isDark ? HareruColors.darkCard : HareruColors.lightCard,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.resetDoubleConfirm,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: l10n.resetKeyword,
              hintStyle: TextStyle(
                color: isDark
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: HareruColors.expense, width: 2),
              ),
            ),
            onChanged: (_) => setDialogState(() {}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.cancel,
                  style: TextStyle(
                      color: isDark
                          ? HareruColors.darkTextSecondary
                          : HareruColors.lightTextSecondary)),
            ),
            TextButton(
              onPressed: controller.text == l10n.resetKeyword
                  ? () => Navigator.pop(ctx, true)
                  : null,
              child: Text(
                l10n.reset,
                style: TextStyle(
                  color: controller.text == l10n.resetKeyword
                      ? HareruColors.expense
                      : (isDark
                          ? HareruColors.darkTextTertiary
                          : HareruColors.lightTextTertiary),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

  if (secondConfirm != true || !context.mounted) return;

  final settingsBox = await Hive.openBox<dynamic>('settings');
  final transactionsBox = await Hive.openBox<Transaction>('transactions');
  final categoriesBox = await Hive.openBox<cat.Category>('categories');

  await settingsBox.clear();
  await transactionsBox.clear();
  await categoriesBox.clear();
  await NotificationService.cancelAll();

  await settingsBox.put('onboarding_completed', false);

  _invalidateAll(ref);

  if (context.mounted) {
    context.go('/onboarding');
  }
}

void _invalidateAll(WidgetRef ref) {
  ref.invalidate(budgetProvider);
  ref.invalidate(payDayProvider);
  ref.invalidate(categoryProvider);
  ref.invalidate(transactionProvider);
  ref.invalidate(darkModeProvider);
  ref.invalidate(reminderProvider);
  ref.invalidate(localeProvider);
}
