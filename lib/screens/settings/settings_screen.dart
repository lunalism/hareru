import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/core/providers/pay_day_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/settings/category_management_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languages = [
    (code: 'ja', label: '日本語', flag: '🇯🇵'),
    (code: 'ko', label: '한국어', flag: '🇰🇷'),
    (code: 'en', label: 'English', flag: '🇺🇸'),
  ];

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

  void _showPayDayDialog(BuildContext context, WidgetRef ref) {
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

  void _showBudgetDialog(BuildContext context, WidgetRef ref) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final budget = ref.watch(budgetProvider);
    final payDay = ref.watch(payDayProvider);

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

              // Budget section
              Text(
                l10n.budgetSettings,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color:
                      isDark ? HareruColors.darkCard : HareruColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Pay day row
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showPayDayDialog(context, ref),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            const Text('\u{1F4B0}',
                                style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                l10n.payDay,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? HareruColors.darkTextPrimary
                                      : HareruColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Text(
                              payDay > 0
                                  ? _formatPayDay(payDay, l10n)
                                  : '-',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? HareruColors.darkTextSecondary
                                    : HareruColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 22,
                              color: isDark
                                  ? HareruColors.darkTextTertiary
                                  : HareruColors.lightTextTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      indent: 54,
                      color: isDark
                          ? HareruColors.darkDivider
                          : HareruColors.lightDivider,
                    ),
                    // Budget row
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showBudgetDialog(context, ref),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            const Text('\u{1F4CA}',
                                style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                l10n.monthlyBudget,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? HareruColors.darkTextPrimary
                                      : HareruColors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Text(
                              _formatBudget(budget),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? HareruColors.darkTextSecondary
                                    : HareruColors.lightTextSecondary,
                                fontFeatures: const [
                                  FontFeature.tabularFigures()
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 22,
                              color: isDark
                                  ? HareruColors.darkTextTertiary
                                  : HareruColors.lightTextTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Category management
              Container(
                decoration: BoxDecoration(
                  color:
                      isDark ? HareruColors.darkCard : HareruColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          const CategoryManagementScreen(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        const Text('\u{1F4C2}',
                            style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            l10n.categoryManagement,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? HareruColors.darkTextPrimary
                                  : HareruColors.lightTextPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 22,
                          color: isDark
                              ? HareruColors.darkTextTertiary
                              : HareruColors.lightTextTertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Language section
              Text(
                l10n.languageTitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? HareruColors.darkCard
                      : HareruColors.lightCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: _languages.asMap().entries.map((entry) {
                    final i = entry.key;
                    final lang = entry.value;
                    final isSelected =
                        currentLocale.languageCode == lang.code;

                    return Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            ref
                                .read(localeProvider.notifier)
                                .setLocale(Locale(lang.code));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Text(lang.flag,
                                    style:
                                        const TextStyle(fontSize: 24)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    lang.label,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isSelected
                                          ? HareruColors.primaryStart
                                          : (isDark
                                              ? HareruColors
                                                  .darkTextPrimary
                                              : HareruColors
                                                  .lightTextPrimary),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 22,
                                    color: HareruColors.primaryStart,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (i < _languages.length - 1)
                          Divider(
                            height: 1,
                            indent: 54,
                            color: isDark
                                ? HareruColors.darkDivider
                                : HareruColors.lightDivider,
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
