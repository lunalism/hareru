import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/custom_colors.dart';
import 'pages/category_manage_page.dart';
import 'providers/settings_provider.dart';
import 'widgets/budget_bottom_sheet.dart';
import 'widgets/day_picker_sheet.dart';
import 'widgets/language_picker_sheet.dart';
import 'widgets/reminder_time_sheet.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/theme_picker_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final formatter = NumberFormat('#,###');

    // Map theme mode display value to l10n
    String themeModeDisplay(String mode) {
      switch (mode) {
        case '시스템':
          return l10n.system;
        case '라이트':
          return l10n.light;
        case '다크':
          return l10n.dark;
        default:
          return mode;
      }
    }

    // Map start day display value to l10n
    String startDayDisplay(String day) {
      switch (day) {
        case '월요일':
          return l10n.monday;
        case '일요일':
          return l10n.sunday;
        default:
          return day;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.settings,
          style: TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(
              title: l10n.household,
              children: [
                SettingsTile(
                  emoji: '💰',
                  title: l10n.monthlyBudget,
                  value: '¥${formatter.format(settings.monthlyBudget)}',
                  onTap: () => _showBudgetSheet(context, ref, settings),
                ),
                SettingsTile(
                  emoji: '📂',
                  title: l10n.categoryManage,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoryManagePage(),
                      ),
                    );
                  },
                ),
                SettingsTile(
                  emoji: '📅',
                  title: l10n.startDayOfWeek,
                  value: startDayDisplay(settings.startDayOfWeek),
                  onTap: () => _showDayPicker(context, ref, settings),
                ),
                SettingsTile(
                  emoji: '🔄',
                  title: l10n.autoExcludeTransfer,
                  subtitle: l10n.autoExcludeTransferDesc,
                  showChevron: false,
                  isHighlighted: true,
                  trailing: CupertinoSwitch(
                    value: settings.autoExcludeTransfer,
                    activeTrackColor: theme.colorScheme.primary,
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .toggleAutoExcludeTransfer(v),
                  ),
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .toggleAutoExcludeTransfer(!settings.autoExcludeTransfer),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.security,
              children: [
                SettingsTile(
                  emoji: '🔒',
                  title: l10n.appLock,
                  subtitle: settings.appLockEnabled ? l10n.appLockDesc : null,
                  showChevron: false,
                  trailing: CupertinoSwitch(
                    value: settings.appLockEnabled,
                    activeTrackColor: theme.colorScheme.primary,
                    onChanged: (v) => ref
                        .read(settingsProvider.notifier)
                        .toggleAppLock(v),
                  ),
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .toggleAppLock(!settings.appLockEnabled),
                ),
                SettingsTile(
                  emoji: '☁️',
                  title: l10n.icloudBackup,
                  onTap: () => _showComingSoon(context, l10n),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.app,
              children: [
                SettingsTile(
                  emoji: '🌙',
                  title: l10n.screenMode,
                  value: themeModeDisplay(settings.themeMode),
                  onTap: () => _showThemePicker(context, ref, settings),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Column(
                    children: [
                      // Line 1: emoji + title + toggle
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: custom.skyBlueLight,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔔',
                                style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.inputReminder,
                              style: TextStyle(
                                fontFamily: 'PretendardJP',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                            value: settings.reminderEnabled,
                            activeTrackColor: theme.colorScheme.primary,
                            onChanged: (v) => ref
                                .read(settingsProvider.notifier)
                                .toggleReminder(v),
                          ),
                        ],
                      ),
                      // Line 2: divider + description + time badge (only when enabled)
                      if (settings.reminderEnabled) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 44),
                          child: Divider(
                            height: 12,
                            thickness: 0.5,
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 44),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  l10n.inputReminderDesc,
                                  style: TextStyle(
                                    fontFamily: 'PretendardJP',
                                    fontSize: 13,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.45),
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showReminderTimePicker(
                                    context, ref, settings),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.15),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('🕘',
                                          style: TextStyle(fontSize: 11)),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatTime(settings.reminderTime),
                                        style: TextStyle(
                                          fontFamily: 'PretendardJP',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.primary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SettingsTile(
                  emoji: '🌐',
                  title: l10n.language,
                  value: settings.language,
                  onTap: () => _showLanguagePicker(context, ref, settings),
                ),
              ],
            ),
            SettingsSection(
              title: l10n.etc,
              children: [
                SettingsTile(
                  emoji: '💬',
                  title: l10n.sendFeedback,
                  onTap: () => _showComingSoon(context, l10n),
                ),
                SettingsTile(
                  emoji: 'ℹ️',
                  title: l10n.appInfo,
                  value: 'v1.0.0',
                  showChevron: false,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    'Hareru',
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.madeWith,
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 12,
                      color: custom.nightLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _showBudgetSheet(
      BuildContext context, WidgetRef ref, SettingsState settings) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BudgetBottomSheet(currentBudget: settings.monthlyBudget),
    );
    if (result != null) {
      ref.read(settingsProvider.notifier).setBudget(result);
    }
  }

  void _showDayPicker(
      BuildContext context, WidgetRef ref, SettingsState settings) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DayPickerSheet(current: settings.startDayOfWeek),
    );
    if (result != null) {
      ref.read(settingsProvider.notifier).setStartDay(result);
    }
  }

  void _showThemePicker(
      BuildContext context, WidgetRef ref, SettingsState settings) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ThemePickerSheet(current: settings.themeMode),
    );
    if (result != null) {
      ref.read(settingsProvider.notifier).setThemeMode(result);
    }
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, SettingsState settings) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => LanguagePickerSheet(current: settings.language),
    );
    if (result != null) {
      ref.read(settingsProvider.notifier).setLanguage(result);
    }
  }

  void _showReminderTimePicker(
      BuildContext context, WidgetRef ref, SettingsState settings) async {
    final result = await showModalBottomSheet<TimeOfDay>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ReminderTimeSheet(current: settings.reminderTime),
    );
    if (result != null) {
      ref.read(settingsProvider.notifier).setReminderTime(result);
    }
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.preparingFeature,
          style: const TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
