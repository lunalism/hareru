import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';

class PremiumBlurCard extends StatelessWidget {
  const PremiumBlurCard({
    super.key,
    required this.child,
    required this.isPremium,
    required this.blurMessage,
  });

  final Widget child;
  final bool isPremium;
  final String blurMessage;

  @override
  Widget build(BuildContext context) {
    if (isPremium) return child;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Actual card content (blurred)
          child,
          // Blur layer
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          // Lock overlay
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('\u{1F512}', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 12),
                    Text(
                      blurMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _PulseCta(l10n: l10n, theme: theme),
                    const SizedBox(height: 6),
                    Text(
                      l10n.blurPrice,
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
}

class _PulseCta extends StatefulWidget {
  const _PulseCta({required this.l10n, required this.theme});
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  State<_PulseCta> createState() => _PulseCtaState();
}

class _PulseCtaState extends State<_PulseCta>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return ScaleTransition(
      scale: _scale,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.blurPremiumComingSoon,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: widget.theme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90D9),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(
          l10n.blurCta,
          style: const TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
