import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../../core/theme/custom_colors.dart';

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key, required this.current});

  final String current;

  // Internal values stored in settings (Korean keys)
  static const _values = ['시스템', '라이트', '다크'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;

    // Display labels from l10n
    final labels = [l10n.system, l10n.light, l10n.dark];

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
            l10n.screenMode,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_values.length, (i) => ListTile(
                onTap: () => Navigator.pop(context, _values[i]),
                title: Text(
                  labels[i],
                  style: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                trailing: current == _values[i]
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
