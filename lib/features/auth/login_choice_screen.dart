import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/features/auth/auth_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class LoginChoiceScreen extends ConsumerStatefulWidget {
  const LoginChoiceScreen({super.key});

  @override
  ConsumerState<LoginChoiceScreen> createState() => _LoginChoiceScreenState();
}

class _LoginChoiceScreenState extends ConsumerState<LoginChoiceScreen> {
  bool _isLoading = false;

  Future<void> _signInWithApple() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signInWithApple();
      if (mounted) context.go('/onboarding');
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.loginError)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continueAsGuest() {
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Logo
              SvgPicture.asset(
                isDark
                    ? 'assets/icon/hareru-symbol-white.svg'
                    : 'assets/icon/hareru-symbol-color.svg',
                width: 72,
                height: 72,
              ),
              const SizedBox(height: 24),

              // Welcome title
              Text(
                l10n.welcomeTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                l10n.welcomeSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: c.textSecondary,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 4),

              // Apple Sign In button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signInWithApple,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apple,
                              size: 24,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.signInWithApple,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Guest button
              GestureDetector(
                onTap: _isLoading ? null : _continueAsGuest,
                child: Text(
                  l10n.continueAsGuest,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Backup hint
              Text(
                l10n.loginBackupHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: c.textTertiary,
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
