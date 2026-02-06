import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key, required this.current});

  final String current;

  static const _options = ['시스템', '라이트', '다크'];

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
            '화면 모드',
            style: AppTypography.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._options.map((opt) => ListTile(
                onTap: () => Navigator.pop(context, opt),
                title: Text(opt, style: AppTypography.body.copyWith(fontSize: 16)),
                trailing: current == opt
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
