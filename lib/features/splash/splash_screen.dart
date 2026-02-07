import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/hareru_logo_painter.dart';
import 'animated_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeOutController;
  late final Animation<double> _fadeOut;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    // Remove native splash now that Flutter is rendering
    FlutterNativeSplash.remove();
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _fadeOutController.dispose();
    super.dispose();
  }

  void _onLogoAnimationComplete() async {
    if (_navigating) return;
    // Short pause after animation completes
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _navigating = true;

    // Fade out
    await _fadeOutController.forward();
    if (!mounted) return;

    // Navigate to home, replacing splash in stack
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeOutController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeOut.value,
          child: child,
        );
      },
      child: Scaffold(
        backgroundColor: HareruLogoPainter.mainBlue,
        body: Center(
          child: AnimatedLogo(
            onAnimationComplete: _onLogoAnimationComplete,
          ),
        ),
      ),
    );
  }
}
