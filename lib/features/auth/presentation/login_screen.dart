import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/widgets/hareru_logo.dart';
import '../providers/auth_providers.dart';
import 'widgets/migration_progress_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;

  Future<void> _signInWithApple() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
      if (!mounted) return;
      await _onLoginSuccess();
    } catch (e) {
      if (!mounted) return;
      _showError();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();
      if (!mounted) return;
      await _onLoginSuccess();
    } catch (e) {
      if (!mounted) return;
      _showError();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onLoginSuccess() async {
    final box = Hive.box('settings');
    await box.put('hasSeenLogin', true);

    if (!mounted) return;

    // Show migration dialog
    await showMigrationDialog(context, ref);

    if (!mounted) return;
    context.go('/');
  }

  void _skip() async {
    final box = Hive.box('settings');
    await box.put('hasSeenLogin', true);
    if (!mounted) return;
    context.go('/');
  }

  void _showError() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.loginError,
          style: const TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final canGoBack = GoRouter.of(context).canPop();

    return Scaffold(
      appBar: canGoBack
          ? AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: Colors.transparent,
            )
          : null,
      body: SafeArea(
        top: !canGoBack,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo
              const HareruLogo(size: 72),
              const SizedBox(height: 16),
              Text(
                l10n.loginSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(flex: 2),

              // Apple Sign In
              SignInWithAppleButton(
                onPressed: _isLoading ? () {} : _signInWithApple,
                style: isDark
                    ? SignInWithAppleButtonStyle.white
                    : SignInWithAppleButtonStyle.black,
                text: l10n.loginWithApple,
                height: 52,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              const SizedBox(height: 12),

              // Google Sign In
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        isDark ? const Color(0xFF2D2D2D) : Colors.white,
                    side: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.2),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google "G" logo
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CustomPaint(painter: _GoogleLogoPainter()),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.loginWithGoogle,
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Skip button (first launch) or empty space (from settings)
              if (!canGoBack)
                TextButton(
                  onPressed: _isLoading ? null : _skip,
                  child: Column(
                    children: [
                      Text(
                        l10n.loginSkip,
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.loginSkipNote,
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 12,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),

              // Loading indicator
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Blue arc (top-right)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.2
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      -0.6, // ~-35 degrees
      -2.2, // sweep ~-125 degrees (counter-clockwise: top-right to bottom-left)
      false,
      bluePaint,
    );

    // Green arc (bottom-right)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.2
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      1.0,
      1.2,
      false,
      greenPaint,
    );

    // Yellow arc (bottom-left)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.2
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      2.2,
      0.8,
      false,
      yellowPaint,
    );

    // Red arc (top-left)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.2
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.7),
      3.0,
      0.7,
      false,
      redPaint,
    );

    // Horizontal bar (blue)
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTRB(w * 0.5, h * 0.4, w, h * 0.6),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
