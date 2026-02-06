import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';

class _LangOption {
  const _LangOption(this.label, {this.comingSoon = false});
  final String label;
  final bool comingSoon;
}

class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key, required this.current});

  final String current;

  static const _options = [
    _LangOption('한국어'),
    _LangOption('日本語', comingSoon: true),
    _LangOption('English', comingSoon: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.nightLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '언어',
            style: AppTypography.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._options.map((opt) => ListTile(
                onTap: opt.comingSoon
                    ? null
                    : () => Navigator.pop(context, opt.label),
                title: Row(
                  children: [
                    Text(
                      opt.label,
                      style: AppTypography.body.copyWith(
                        fontSize: 16,
                        color: opt.comingSoon
                            ? AppColors.nightLight
                            : AppColors.night,
                      ),
                    ),
                    if (opt.comingSoon) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlueLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'coming soon',
                          style: AppTypography.caption.copyWith(
                            fontSize: 10,
                            color: AppColors.skyBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: current == opt.label
                    ? const Icon(Icons.check_circle,
                        color: AppColors.skyBlue, size: 22)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
