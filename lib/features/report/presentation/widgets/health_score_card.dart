import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';

import '../../../../shared/services/health_score_calculator.dart';
import '../../providers/ai_insight_provider.dart';
import '../../providers/premium_provider.dart';
import 'premium_blur_card.dart';

class HealthScoreCard extends ConsumerWidget {
  const HealthScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(isPremiumProvider);
    final healthResult = ref.watch(healthScoreProvider);
    final insight = ref.watch(aiInsightProvider);
    final l10n = AppLocalizations.of(context)!;

    return PremiumBlurCard(
      isPremium: isPremium,
      blurMessage: l10n.blurMessageHealth,
      child: _CardContent(
        healthResult: healthResult,
        healthComment: insight?.healthComment,
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.healthResult,
    this.healthComment,
  });

  final HealthScoreResult healthResult;
  final String? healthComment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final gradeColor = _gradeColor(healthResult.grade);
    final gradeText = _gradeText(healthResult.grade, l10n);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
        border: isDark
            ? Border.all(color: theme.colorScheme.outline)
            : null,
      ),
      child: Column(
        children: [
          // Title
          Row(
            children: [
              const Text('\u{1F4CA}', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                l10n.healthScoreTitle,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Circular gauge
          _CircularGauge(
            score: healthResult.total,
            gradeColor: gradeColor,
          ),
          const SizedBox(height: 8),
          Text(
            gradeText,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: gradeColor,
            ),
          ),
          const SizedBox(height: 24),
          // Score bars
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _ScoreBar(
                  label: l10n.healthScoreBudget,
                  score: healthResult.budgetScore,
                  maxScore: 25,
                ),
                const SizedBox(height: 12),
                _ScoreBar(
                  label: l10n.healthScoreSaving,
                  score: healthResult.savingScore,
                  maxScore: 25,
                ),
                const SizedBox(height: 12),
                _ScoreBar(
                  label: l10n.healthScoreBalance,
                  score: healthResult.balanceScore,
                  maxScore: 25,
                ),
                const SizedBox(height: 12),
                _ScoreBar(
                  label: l10n.healthScoreClear,
                  score: healthResult.clearScore,
                  maxScore: 25,
                  isHareru: true,
                ),
              ],
            ),
          ),
          // AI comment
          if (healthComment != null && healthComment!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('\u{1F4AC}', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '\u201C$healthComment\u201D',
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 13,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'excellent':
        return const Color(0xFF10B981);
      case 'good':
        return const Color(0xFF4A90D9);
      case 'average':
        return const Color(0xFFF59E0B);
      case 'caution':
        return const Color(0xFFF97316);
      case 'danger':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF4A90D9);
    }
  }

  String _gradeText(String grade, AppLocalizations l10n) {
    switch (grade) {
      case 'excellent':
        return l10n.healthGradeExcellent;
      case 'good':
        return l10n.healthGradeGood;
      case 'average':
        return l10n.healthGradeAverage;
      case 'caution':
        return l10n.healthGradeCaution;
      case 'danger':
        return l10n.healthGradeDanger;
      default:
        return l10n.healthGradeGood;
    }
  }
}

class _CircularGauge extends StatefulWidget {
  const _CircularGauge({
    required this.score,
    required this.gradeColor,
  });

  final int score;
  final Color gradeColor;

  @override
  State<_CircularGauge> createState() => _CircularGaugeState();
}

class _CircularGaugeState extends State<_CircularGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progress = Tween(begin: 0.0, end: widget.score / 100.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _ctrl.forward();
  }

  @override
  void didUpdateWidget(_CircularGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _progress = Tween(begin: 0.0, end: widget.score / 100.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
      );
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        return SizedBox(
          width: 130,
          height: 130,
          child: CustomPaint(
            painter: _GaugePainter(
              progress: _progress.value,
              color: widget.gradeColor,
              bgColor: bgColor,
            ),
            child: Center(
              child: Text(
                (_progress.value * 100).round().toString(),
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: widget.gradeColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  final double progress;
  final Color color;
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const strokeWidth = 10.0;

    // Background circle
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _ScoreBar extends StatefulWidget {
  const _ScoreBar({
    required this.label,
    required this.score,
    required this.maxScore,
    this.isHareru = false,
  });

  final String label;
  final int score;
  final int maxScore;
  final bool isHareru;

  @override
  State<_ScoreBar> createState() => _ScoreBarState();
}

class _ScoreBarState extends State<_ScoreBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progress =
        Tween(begin: 0.0, end: widget.score / widget.maxScore.toDouble())
            .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Color _barColor(int score, int max) {
    final ratio = score / max;
    if (ratio >= 0.9) return const Color(0xFF10B981);
    if (ratio >= 0.7) return const Color(0xFF4A90D9);
    if (ratio >= 0.5) return const Color(0xFFF59E0B);
    if (ratio >= 0.3) return const Color(0xFFF97316);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barColor = _barColor(widget.score, widget.maxScore);

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        return Row(
          children: [
            SizedBox(
              width: 72,
              child: Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 8,
                  child: LinearProgressIndicator(
                    value: _progress.value,
                    backgroundColor: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 28,
              child: Text(
                '${widget.score}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (widget.isHareru) ...[
              const SizedBox(width: 4),
              Text(
                '\u2728 Hareru',
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981).withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
