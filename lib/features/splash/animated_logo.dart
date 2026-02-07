import 'package:flutter/material.dart';
import '../../shared/widgets/hareru_logo_symbol.dart';

/// Animated logo widget for the splash screen.
/// Plays the full entrance animation sequence.
class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key, this.onAnimationComplete});

  final VoidCallback? onAnimationComplete;

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with TickerProviderStateMixin {
  // Phase 1: H symbol fade-in + scale
  late final AnimationController _symbolController;
  late final Animation<double> _symbolOpacity;
  late final Animation<double> _symbolScale;

  // Phase 2: Golden dot appear
  late final AnimationController _dotController;
  late final Animation<double> _dotOpacity;
  late final Animation<double> _dotScale;
  late final Animation<double> _glowSpread;

  // Phase 3: Wordmark slide up
  late final AnimationController _wordmarkController;
  late final Animation<double> _wordmarkOpacity;
  late final Animation<double> _wordmarkOffset;

  @override
  void initState() {
    super.initState();

    // Phase 1: Symbol (0–200ms)
    _symbolController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _symbolOpacity = CurvedAnimation(
      parent: _symbolController,
      curve: Curves.easeOut,
    );
    _symbolScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _symbolController, curve: Curves.easeOut),
    );

    // Phase 2: Dot (300–600ms)
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _dotOpacity = CurvedAnimation(
      parent: _dotController,
      curve: Curves.easeOut,
    );
    _dotScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeOutBack),
    );
    _glowSpread = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 4.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.easeOut),
    );

    // Phase 3: Wordmark (800–1000ms)
    _wordmarkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _wordmarkOpacity = CurvedAnimation(
      parent: _wordmarkController,
      curve: Curves.easeOut,
    );
    _wordmarkOffset = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _wordmarkController, curve: Curves.easeOut),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // 0ms: Start symbol fade in
    _symbolController.forward();

    // 300ms: Start dot
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _dotController.forward();

    // 800ms: Start wordmark
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    _wordmarkController.forward();

    // 1200ms: Animation complete, notify parent
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _dotController.dispose();
    _wordmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const logoSize = 80.0;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _symbolController,
        _dotController,
        _wordmarkController,
      ]),
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // H symbol + dot
            Opacity(
              opacity: _symbolOpacity.value,
              child: Transform.scale(
                scale: _symbolScale.value,
                child: HareruLogoSymbol(
                  size: logoSize,
                  symbolColor: Colors.white,
                  showGlow: true,
                  dotOpacity: _dotOpacity.value,
                  dotScale: _dotScale.value,
                  glowSpread: _glowSpread.value,
                ),
              ),
            ),
            const SizedBox(height: logoSize * 0.2),
            // Wordmark
            Transform.translate(
              offset: Offset(0, _wordmarkOffset.value),
              child: Opacity(
                opacity: _wordmarkOpacity.value,
                child: const Text(
                  'Hareru',
                  style: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: logoSize * 0.32,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
