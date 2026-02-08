import 'package:flutter/material.dart';
import 'widgets/monthly_summary_card.dart';
import 'widgets/today_expense_list.dart';
import 'widgets/weekly_trend_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  static const _sectionCount = 3;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _sectionCount,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _fadeAnimations = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.easeOut))
        .toList();

    _slideAnimations = _controllers.map((c) {
      return Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: c, curve: Curves.easeOutCubic));
    }).toList();

    _startStaggeredAnimation();
  }

  void _startStaggeredAnimation() async {
    for (var i = 0; i < _sectionCount; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Hareru',
          style: TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded,
                color: theme.colorScheme.onSurface, size: 24),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildAnimatedSection(0, const MonthlySummaryCard()),
            const SizedBox(height: 24),
            _buildAnimatedSection(1, const TodayExpenseList()),
            const SizedBox(height: 24),
            _buildAnimatedSection(2, const WeeklyTrendChart()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(int index, Widget child) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: child,
      ),
    );
  }
}
