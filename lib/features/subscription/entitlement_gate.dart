import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/features/subscription/paywall_screen.dart';
import 'package:hareru/features/subscription/subscription_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class EntitlementGate extends ConsumerWidget {
  const EntitlementGate({
    required this.requiredTier,
    required this.child,
    this.lockedChild,
    this.showPaywallOnTap = true,
    super.key,
  });

  final SubscriptionTier requiredTier;
  final Widget child;
  final Widget? lockedChild;
  final bool showPaywallOnTap;

  bool _hasAccess(SubscriptionTier currentTier) {
    return currentTier.index >= requiredTier.index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);

    if (_hasAccess(sub.tier)) return child;

    if (lockedChild != null) return lockedChild!;

    return _DefaultLockedWidget(
      requiredTier: requiredTier,
      showPaywallOnTap: showPaywallOnTap,
    );
  }
}

class _DefaultLockedWidget extends StatelessWidget {
  const _DefaultLockedWidget({
    required this.requiredTier,
    required this.showPaywallOnTap,
  });

  final SubscriptionTier requiredTier;
  final bool showPaywallOnTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context)!;

    final label = requiredTier == SubscriptionTier.clearPro
        ? l10n.lockClearProRequired
        : l10n.lockClearRequired;

    return GestureDetector(
      onTap: showPaywallOnTap
          ? () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PaywallScreen(),
                ),
              )
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark
              ? HareruColors.darkCard
              : HareruColors.guideIconBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_rounded,
              size: 28,
              color: c.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: HareruColors.primaryStart,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${l10n.lockUpgrade} \u2192',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
