import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:hareru/screens/settings/category_management_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _appVersion = '';

  static const _languages = [
    (code: 'ja', label: '日本語', flag: '🇯🇵'),
    (code: 'ko', label: '한국어', flag: '🇰🇷'),
    (code: 'en', label: 'English', flag: '🇺🇸'),
  ];

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() => _appVersion = info.version);
    }
  }

  String _formatBudget(int value) {
    if (value == 0) return '¥0';
    final s = value.toString();
    final result = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      result.write(s[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    return '¥${result.toString().split('').reversed.join()}';
  }

  String _formatPayDay(int payDay, AppLocalizations l10n) {
    if (payDay == 32) return l10n.payDayLabel(l10n.payDayEndOfMonth);
    return l10n.payDayLabel('$payDay');
  }

  // ── Dialogs ──

  void _showPayDayDialog(BuildContext context) {
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

  void _showBudgetDialog(BuildContext context) {
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

  void _showTimePicker(BuildContext context) {
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
                      _scheduleReminder();
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

  Future<void> _scheduleReminder() async {
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

  Future<void> _toggleReminder(bool enabled) async {
    if (enabled) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (mounted) {
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
      await _scheduleReminder();
    } else {
      await NotificationService.cancelAll();
    }
  }

  // ── Backup / Restore / Reset ──

  Future<void> _backupData() async {
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

  Future<void> _restoreData() async {
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

    if (confirmed != true || !mounted) return;

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

      // Restore settings
      if (data['settings'] is Map) {
        final settingsBox = await Hive.openBox<dynamic>('settings');
        final settingsData = data['settings'] as Map<String, dynamic>;
        for (final entry in settingsData.entries) {
          await settingsBox.put(entry.key, entry.value);
        }
      }

      // Restore categories
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

      // Restore transactions
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

      // Refresh providers
      ref.invalidate(budgetProvider);
      ref.invalidate(payDayProvider);
      ref.invalidate(categoryProvider);
      ref.invalidate(transactionProvider);
      ref.invalidate(darkModeProvider);
      ref.invalidate(reminderProvider);
      ref.invalidate(localeProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.restoreData)),
        );
      }
    } catch (_) {
      // Invalid file
    }
  }

  Future<void> _resetData() async {
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
                    color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (firstConfirm != true || !mounted) return;

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
                      color: Color(0xFFEF4444), width: 2),
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
                        ? const Color(0xFFEF4444)
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

    if (secondConfirm != true || !mounted) return;

    // Execute reset
    final settingsBox = await Hive.openBox<dynamic>('settings');
    final transactionsBox = await Hive.openBox<Transaction>('transactions');
    final categoriesBox = await Hive.openBox<cat.Category>('categories');

    await settingsBox.clear();
    await transactionsBox.clear();
    await categoriesBox.clear();
    await NotificationService.cancelAll();

    // Reset onboarding flag
    await settingsBox.put('onboarding_completed', false);

    // Refresh and go to onboarding
    ref.invalidate(budgetProvider);
    ref.invalidate(payDayProvider);
    ref.invalidate(categoryProvider);
    ref.invalidate(transactionProvider);
    ref.invalidate(darkModeProvider);
    ref.invalidate(reminderProvider);
    ref.invalidate(localeProvider);

    if (mounted) {
      context.go('/onboarding');
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final budget = ref.watch(budgetProvider);
    final payDay = ref.watch(payDayProvider);
    final themeMode = ref.watch(darkModeProvider);
    final reminder = ref.watch(reminderProvider);

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                l10n.settingsTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? HareruColors.darkTextPrimary
                      : HareruColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 28),

              // ── Budget section ──
              _sectionHeader(l10n.budgetSettings, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{1F4B0}',
                    label: l10n.payDay,
                    trailing: Text(
                      payDay > 0 ? _formatPayDay(payDay, l10n) : '-',
                      style: _trailingStyle(isDark),
                    ),
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => _showPayDayDialog(context),
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F4CA}',
                    label: l10n.monthlyBudget,
                    trailing: Text(
                      _formatBudget(budget),
                      style: _trailingStyle(isDark).copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => _showBudgetDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Category management ──
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{1F4C2}',
                    label: l10n.categoryManagement,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const CategoryManagementScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Appearance section ──
              _sectionHeader(l10n.appearance, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{1F319}',
                    label: l10n.darkMode,
                    trailing: Switch.adaptive(
                      value: themeMode == ThemeMode.dark,
                      activeTrackColor: HareruColors.primaryStart,
                      onChanged: (_) =>
                          ref.read(darkModeProvider.notifier).toggle(),
                    ),
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Notification section ──
              _sectionHeader(l10n.notification, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{1F514}',
                    label: l10n.recordReminder,
                    trailing: Switch.adaptive(
                      value: reminder.enabled,
                      activeTrackColor: HareruColors.primaryStart,
                      onChanged: _toggleReminder,
                    ),
                    isDark: isDark,
                  ),
                  if (reminder.enabled) ...[
                    _divider(isDark),
                    _row(
                      emoji: '\u{23F0}',
                      label: reminder.time,
                      showChevron: true,
                      isDark: isDark,
                      onTap: () => _showTimePicker(context),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 28),

              // ── Data section ──
              _sectionHeader(l10n.data, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{1F4BE}',
                    label: l10n.backupData,
                    showChevron: true,
                    isDark: isDark,
                    onTap: _backupData,
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F4E5}',
                    label: l10n.restoreData,
                    showChevron: true,
                    isDark: isDark,
                    onTap: _restoreData,
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F5D1}',
                    label: l10n.resetData,
                    showChevron: true,
                    isDark: isDark,
                    labelColor: const Color(0xFFEF4444),
                    onTap: _resetData,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Language section ──
              _sectionHeader(l10n.languageTitle, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: _languages.asMap().entries.expand((entry) {
                  final i = entry.key;
                  final lang = entry.value;
                  final isSelected =
                      currentLocale.languageCode == lang.code;
                  return [
                    _row(
                      emoji: lang.flag,
                      label: lang.label,
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded,
                              size: 22, color: HareruColors.primaryStart)
                          : null,
                      isDark: isDark,
                      labelWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      labelColor: isSelected
                          ? HareruColors.primaryStart
                          : null,
                      onTap: () => ref
                          .read(localeProvider.notifier)
                          .setLocale(Locale(lang.code)),
                    ),
                    if (i < _languages.length - 1) _divider(isDark),
                  ];
                }).toList(),
              ),
              const SizedBox(height: 28),

              // ── About section ──
              _sectionHeader(l10n.aboutApp, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{1F4E7}',
                    label: l10n.feedback,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => launchUrl(Uri.parse(
                        'mailto:support@hareru.app?subject=Hareru フィードバック')),
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{2B50}',
                    label: l10n.rateApp,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.rateAppLater)),
                      );
                    },
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F4C4}',
                    label: l10n.termsOfService,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () =>
                        launchUrl(Uri.parse('https://hareru.app/terms')),
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F512}',
                    label: l10n.privacyPolicy,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () =>
                        launchUrl(Uri.parse('https://hareru.app/privacy')),
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '',
                    label: l10n.version,
                    trailing: Text(
                      _appVersion,
                      style: _trailingStyle(isDark),
                    ),
                    isDark: isDark,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ── Reusable widgets ──

  Widget _sectionHeader(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark
              ? HareruColors.darkTextSecondary
              : HareruColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _card(bool isDark, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _row({
    required String emoji,
    required String label,
    Widget? trailing,
    bool showChevron = false,
    required bool isDark,
    VoidCallback? onTap,
    Color? labelColor,
    FontWeight? labelWeight,
  }) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          if (emoji.isNotEmpty) ...[
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
          ] else
            const SizedBox(width: 38),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: labelWeight ?? FontWeight.w400,
                color: labelColor ??
                    (isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary),
              ),
            ),
          ),
          ?trailing,
          if (showChevron) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 54,
      color: isDark ? HareruColors.darkDivider : HareruColors.lightDivider,
    );
  }

  TextStyle _trailingStyle(bool isDark) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: isDark
          ? HareruColors.darkTextSecondary
          : HareruColors.lightTextSecondary,
    );
  }
}
