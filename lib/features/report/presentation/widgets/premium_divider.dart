import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';

import '../../providers/premium_provider.dart';

class PremiumDivider extends ConsumerWidget {
  const PremiumDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.watch(isPremiumProvider);

    final label = isPremium
        ? '\u2728 ${l10n.premiumDividerLabel}'
        : '\u2728 ${l10n.premiumDividerLabelFree} \u2728';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
