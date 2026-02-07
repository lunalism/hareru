import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../../core/theme/custom_colors.dart';

class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key, required this.current});

  final String current;

  static const _options = ['한국어', '日本語', 'English'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: custom.nightLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.language,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ..._options.map((opt) => ListTile(
                onTap: () => Navigator.pop(context, opt),
                title: Text(
                  opt,
                  style: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                trailing: current == opt
                    ? Icon(Icons.check_circle,
                        color: theme.colorScheme.primary, size: 22)
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
