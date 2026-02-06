import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
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
    final settings = ref.watch(settingsProvider);
    final formatter = NumberFormat('#,###');

    return Scaffold(
      backgroundColor: AppColors.cloud,
      appBar: AppBar(
        backgroundColor: AppColors.cloud,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '설정',
          style: AppTypography.body.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 1: 가계부
            SettingsSection(
              title: '가계부',
              children: [
                SettingsTile(
                  emoji: '💰',
                  title: '월 예산',
                  value: '¥${formatter.format(settings.monthlyBudget)}',
                  onTap: () => _showBudgetSheet(context, ref, settings),
                ),
                SettingsTile(
                  emoji: '📂',
                  title: '카테고리 관리',
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
                  title: '주 시작 요일',
                  value: settings.startDayOfWeek,
                  onTap: () => _showDayPicker(context, ref, settings),
                ),
                SettingsTile(
                  emoji: '🔄',
                  title: '이체 자동 제외',
                  subtitle: '계좌 간 이체를 지출에서 자동으로 제외합니다',
                  showChevron: false,
                  isHighlighted: true,
                  trailing: CupertinoSwitch(
                    value: settings.autoExcludeTransfer,
                    activeTrackColor: AppColors.skyBlue,
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

            // 섹션 2: 보안
            SettingsSection(
              title: '보안',
              children: [
                SettingsTile(
                  emoji: '🔒',
                  title: '앱 잠금',
                  subtitle: settings.appLockEnabled
                      ? 'Face ID 또는 패스코드로 잠금'
                      : null,
                  showChevron: false,
                  trailing: CupertinoSwitch(
                    value: settings.appLockEnabled,
                    activeTrackColor: AppColors.skyBlue,
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
                  title: 'iCloud 백업',
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),

            // 섹션 3: 앱
            SettingsSection(
              title: '앱',
              children: [
                SettingsTile(
                  emoji: '🌙',
                  title: '화면 모드',
                  value: settings.themeMode,
                  onTap: () => _showThemePicker(context, ref, settings),
                ),
                SettingsTile(
                  emoji: '🔔',
                  title: '입력 리마인더',
                  subtitle: settings.reminderEnabled
                      ? '매일 설정한 시간에 알림을 보내드려요'
                      : null,
                  showChevron: false,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (settings.reminderEnabled)
                        GestureDetector(
                          onTap: () =>
                              _showReminderTimePicker(context, ref, settings),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.skyBlueLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _formatTime(settings.reminderTime),
                              style: AppTypography.body.copyWith(
                                color: AppColors.skyBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      if (settings.reminderEnabled) const SizedBox(width: 8),
                      CupertinoSwitch(
                        value: settings.reminderEnabled,
                        activeTrackColor: AppColors.skyBlue,
                        onChanged: (v) => ref
                            .read(settingsProvider.notifier)
                            .toggleReminder(v),
                      ),
                    ],
                  ),
                  onTap: () => ref
                      .read(settingsProvider.notifier)
                      .toggleReminder(!settings.reminderEnabled),
                ),
                SettingsTile(
                  emoji: '🌐',
                  title: '언어',
                  value: settings.language,
                  onTap: () => _showLanguagePicker(context, ref, settings),
                ),
              ],
            ),

            // 섹션 4: 기타
            SettingsSection(
              title: '기타',
              children: [
                SettingsTile(
                  emoji: '💬',
                  title: '의견 보내기',
                  onTap: () => _showComingSoon(context),
                ),
                SettingsTile(
                  emoji: 'ℹ️',
                  title: '앱 정보',
                  value: 'v1.0.0',
                  showChevron: false,
                ),
              ],
            ),

            // 하단 로고
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    'Hareru',
                    style: AppTypography.body.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.skyBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with 💙',
                    style: AppTypography.caption,
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

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '준비 중인 기능이에요',
          style: AppTypography.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.skyBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
