import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/features/subscription/subscription_provider.dart';
import 'package:hareru/core/services/revenue_cat_service.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/settings/legal_webview_screen.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isYearly = false;
  Offerings? _offerings;
  bool _isLoadingOfferings = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await RevenueCatService.getOfferings();
      if (mounted) {
        setState(() {
          _offerings = offerings;
          _isLoadingOfferings = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingOfferings = false);
      }
    }
  }

  Package? _getPackage(String identifier) {
    final current = _offerings?.current;
    if (current == null) return null;
    try {
      return current.availablePackages
          .firstWhere((p) => p.identifier == identifier);
    } catch (_) {
      return null;
    }
  }

  String _getClearPrice() {
    final id = _isYearly ? '\$rc_annual' : '\$rc_monthly';
    // Try to get from offerings first
    final pkg = _getPackage(id);
    if (pkg != null) return pkg.storeProduct.priceString;
    // Fallback hardcoded prices
    return _isYearly ? '\u00a53,800' : '\u00a5380';
  }

  String _getClearProPrice() {
    final id = _isYearly ? '\$rc_annual' : '\$rc_monthly';
    final pkg = _getPackage(id);
    if (pkg != null) return pkg.storeProduct.priceString;
    return _isYearly ? '\u00a57,000' : '\u00a5700';
  }

  String _getPeriodSuffix(AppLocalizations l10n) {
    return _isYearly ? '/\u5E74' : '/\u6708';
  }

  void _showResultDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? content,
  }) {
    if (!mounted) return;
    final c = context.colors;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: c.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(icon, color: iconColor, size: 48),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: c.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        content: content != null
            ? Text(
                content,
                style: TextStyle(fontSize: 14, color: c.textSecondary),
                textAlign: TextAlign.center,
              )
            : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'OK',
              style: TextStyle(
                color: HareruColors.primaryStart,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(bool isClearPro) async {
    final l10n = AppLocalizations.of(context)!;
    final current = _offerings?.current;

    if (current == null || current.availablePackages.isEmpty) {
      _showResultDialog(
        icon: Icons.info_outline,
        iconColor: HareruColors.primaryStart,
        title: l10n.purchaseNotAvailable,
        content: l10n.purchaseNotAvailableDesc,
      );
      return;
    }

    // Find the right package
    final packageId = _isYearly ? '\$rc_annual' : '\$rc_monthly';
    final pkg = _getPackage(packageId);
    if (pkg == null) {
      _showResultDialog(
        icon: Icons.info_outline,
        iconColor: HareruColors.primaryStart,
        title: l10n.purchaseNotAvailable,
        content: l10n.purchaseNotAvailableDesc,
      );
      return;
    }

    setState(() => _isPurchasing = true);

    try {
      await ref.read(subscriptionProvider.notifier).purchase(pkg);
      if (mounted) {
        _showResultDialog(
          icon: Icons.check_circle,
          iconColor: HareruColors.savings,
          title: l10n.purchaseSuccess,
        );
        // Close paywall after dialog is shown
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        // User cancelled — do nothing
        return;
      }
      if (errorCode == PurchasesErrorCode.storeProblemError ||
          errorCode ==
              PurchasesErrorCode.productNotAvailableForPurchaseError) {
        _showResultDialog(
          icon: Icons.info_outline,
          iconColor: HareruColors.primaryStart,
          title: l10n.purchaseNotAvailable,
          content: l10n.purchaseNotAvailableDesc,
        );
      } else {
        _showResultDialog(
          icon: Icons.error_outline,
          iconColor: HareruColors.expense,
          title: l10n.purchaseError,
        );
      }
    } catch (_) {
      if (mounted) {
        _showResultDialog(
          icon: Icons.error_outline,
          iconColor: HareruColors.expense,
          title: l10n.purchaseError,
        );
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  Future<void> _handleRestore() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isPurchasing = true);

    try {
      await ref.read(subscriptionProvider.notifier).restore();
      if (mounted) {
        final sub = ref.read(subscriptionProvider);
        if (!sub.isFree) {
          _showResultDialog(
            icon: Icons.check_circle,
            iconColor: HareruColors.savings,
            title: l10n.purchaseRestored,
          );
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) Navigator.pop(context);
          });
        } else {
          _showResultDialog(
            icon: Icons.info_outline,
            iconColor: HareruColors.primaryStart,
            title: l10n.restoreNoPurchase,
          );
        }
      }
    } catch (_) {
      if (mounted) {
        _showResultDialog(
          icon: Icons.error_outline,
          iconColor: HareruColors.expense,
          title: l10n.purchaseError,
        );
      }
    } finally {
      if (mounted) setState(() => _isPurchasing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isDark = context.isDark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: c.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isPurchasing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    l10n.paywallTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Monthly / Yearly toggle
                  _buildPeriodToggle(isDark, l10n),
                  const SizedBox(height: 24),

                  // Loading indicator for offerings
                  if (_isLoadingOfferings)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )
                  else ...[
                    // Clear card
                    _buildPlanCard(
                      isDark: isDark,
                      l10n: l10n,
                      title: l10n.paywallClearTitle,
                      price: _getClearPrice(),
                      period: _getPeriodSuffix(l10n),
                      features: [
                        l10n.featureNoAds,
                        l10n.featureAiInsight,
                        l10n.featureSavingSim,
                        l10n.featureCsvExport,
                      ],
                      cta: l10n.paywallClearCta,
                      onTap: () => _handlePurchase(false),
                      isPro: false,
                    ),
                    const SizedBox(height: 16),

                    // ClearPro card
                    _buildPlanCard(
                      isDark: isDark,
                      l10n: l10n,
                      title: l10n.paywallClearProTitle,
                      price: _getClearProPrice(),
                      period: _getPeriodSuffix(l10n),
                      features: [
                        l10n.featureNoAds,
                        l10n.featureAiInsight,
                        l10n.featureSavingSim,
                        l10n.featureCsvExport,
                        l10n.featureAiCoaching,
                        l10n.featurePdfReport,
                        l10n.featureSavingGoal,
                        l10n.featurePrioritySupport,
                      ],
                      cta: l10n.paywallClearProCta,
                      onTap: () => _handlePurchase(true),
                      isPro: true,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Restore purchases
                  GestureDetector(
                    onTap: _handleRestore,
                    child: Text(
                      l10n.paywallRestore,
                      style: TextStyle(
                        fontSize: 14,
                        color: c.textSecondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Continue with free
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      l10n.paywallContinueFree,
                      style: TextStyle(
                        fontSize: 14,
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Terms & Privacy
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => LegalWebviewScreen(
                              title: l10n.paywallTerms,
                              path: 'terms',
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.paywallTerms,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textTertiary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        '  |  ',
                        style: TextStyle(
                          fontSize: 12,
                          color: c.textTertiary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => LegalWebviewScreen(
                              title: l10n.paywallPrivacy,
                              path: 'privacy',
                            ),
                          ),
                        ),
                        child: Text(
                          l10n.paywallPrivacy,
                          style: TextStyle(
                            fontSize: 12,
                            color: c.textTertiary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodToggle(bool isDark, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.lightCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !_isYearly
                      ? HareruColors.primaryStart
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.paywallMonthly,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: !_isYearly
                        ? Colors.white
                        : (isDark
                            ? HareruColors.darkTextSecondary
                            : HareruColors.lightTextSecondary),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _isYearly
                      ? HareruColors.primaryStart
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.paywallYearly,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isYearly
                            ? Colors.white
                            : (isDark
                                ? HareruColors.darkTextSecondary
                                : HareruColors.lightTextSecondary),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _isYearly
                            ? Colors.white.withValues(alpha: 0.25)
                            : HareruColors.primaryStart.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.paywallYearlyBadge,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _isYearly
                              ? Colors.white
                              : HareruColors.primaryStart,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required bool isDark,
    required AppLocalizations l10n,
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required String cta,
    required VoidCallback onTap,
    required bool isPro,
  }) {
    final c = context.colors;

    final bgColor = isPro
        ? (isDark ? const Color(0xFF2D2518) : const Color(0xFFFFF8E7))
        : (isDark ? HareruColors.darkCard : const Color(0xFFF0F4FF));

    final borderColor = isPro
        ? const Color(0xFFD4A24C)
        : (isDark ? HareruColors.darkDivider : const Color(0xFFBFCFEF));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isPro ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isPro) ...[
                const Text('\u{1F451}', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 14,
                    color: c.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          if (_isYearly) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: HareruColors.savings.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                l10n.paywallSaveMonths,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: HareruColors.savings,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 18, color: HareruColors.savings),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 14,
                        color: c.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isPro
                    ? const Color(0xFFD4A24C)
                    : HareruColors.primaryStart,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                cta,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
