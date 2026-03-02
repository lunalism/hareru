import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/features/subscription/paywall_screen.dart';
import 'package:hareru/features/subscription/subscription_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class AdPlaceholder extends ConsumerWidget {
  const AdPlaceholder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    if (!sub.showAds) return const SizedBox.shrink();

    final c = context.colors;
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const PaywallScreen(),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.divider),
          ),
          child: Text(
            l10n.adPlaceholder,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: c.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
