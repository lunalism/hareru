import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/dark_mode_provider.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/core/providers/pay_day_provider.dart';
import 'package:hareru/core/providers/reminder_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/settings/category_management_screen.dart';
import 'package:hareru/screens/settings/faq_screen.dart';
import 'package:hareru/screens/settings/widgets/contact_sheet.dart';
import 'package:hareru/screens/settings/widgets/data_management.dart';
import 'package:hareru/screens/settings/widgets/settings_dialogs.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final budget = ref.watch(budgetProvider);
    final payDay = ref.watch(payDayProvider);
    final themeMode = ref.watch(darkModeProvider);
    final reminder = ref.watch(reminderProvider);

    return Scaffold(
      backgroundColor: c.background,
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
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 28),

              // Budget section
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
                    onTap: () => showPayDayDialog(context, ref),
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
                    onTap: () => showBudgetDialog(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Category management
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

              // Appearance section
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

              // Notification section
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
                      onChanged: (v) => toggleReminder(context, ref, v),
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
                      onTap: () => showReminderTimePicker(context, ref),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 28),

              // Data section
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
                    onTap: backupData,
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F4E5}',
                    label: l10n.restoreData,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => restoreData(context, ref),
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{1F5D1}',
                    label: l10n.resetData,
                    showChevron: true,
                    isDark: isDark,
                    labelColor: HareruColors.expense,
                    onTap: () => resetData(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Support section
              _sectionHeader(l10n.support, isDark),
              const SizedBox(height: 12),
              _card(
                isDark,
                children: [
                  _row(
                    emoji: '\u{2753}',
                    label: l10n.faq,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const FaqScreen(),
                      ),
                    ),
                  ),
                  _divider(isDark),
                  _row(
                    emoji: '\u{2709}\u{FE0F}',
                    label: l10n.contactUs,
                    showChevron: true,
                    isDark: isDark,
                    onTap: () => showContactSheet(context),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Language section
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

              // About section
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
                        'mailto:support@hareru.app?subject=Hareru ${l10n.feedback}')),
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

  // Reusable widgets

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
