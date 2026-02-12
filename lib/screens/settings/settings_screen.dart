import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/locale_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _languages = [
    (code: 'ja', label: '日本語', flag: '🇯🇵'),
    (code: 'ko', label: '한국어', flag: '🇰🇷'),
    (code: 'en', label: 'English', flag: '🇺🇸'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

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
                  color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
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
                                    style: const TextStyle(fontSize: 24)),
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
                                              ? HareruColors.darkTextPrimary
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
