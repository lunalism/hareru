import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    // TODO: SharedPreferences에 온보딩 완료 저장
    context.go('/main');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLast = _currentPage == 2;

    final pages = [
      _OnboardingPage(
        title: l10n.onboarding1Title,
        description: l10n.onboarding1Desc,
        visual: _buildCompareVisual(context, l10n, isDark),
      ),
      _OnboardingPage(
        title: l10n.onboarding2Title,
        description: l10n.onboarding2Desc,
        visual: _buildTransferVisual(context, l10n, isDark),
      ),
      _OnboardingPage(
        title: l10n.onboarding3Title,
        description: l10n.onboarding3Desc,
        visual: _buildSpeedVisual(context, l10n, isDark),
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(
                    l10n.onboardingSkip,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 280, child: page.visual),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isActive
                          ? const Color(0xFF4A90D9)
                          : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                  );
                }),
              ),
            ),

            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90D9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? l10n.onboardingStart : l10n.onboardingNext,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title, description;
  final Widget visual;
  _OnboardingPage({required this.title, required this.description, required this.visual});
}

// ========================================
// 슬라이드 1: 비교 비주얼
// ========================================
Widget _buildCompareVisual(BuildContext context, AppLocalizations l10n, bool isDark) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      // 다른 앱
      Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.otherApps, style: const TextStyle(fontSize: 11, color: Color(0xFF991B1B), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('¥50,000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
            const SizedBox(height: 4),
            Text(l10n.looksLikeExpense, style: const TextStyle(fontSize: 10, color: Color(0xFF991B1B))),
            const SizedBox(height: 12),
            _row(l10n.food, '¥18,000', const Color(0xFFB91C1C)),
            const SizedBox(height: 4),
            _row(l10n.transport, '¥5,000', const Color(0xFFB91C1C)),
            const SizedBox(height: 4),
            _row(l10n.transferAlert, '¥18,000', const Color(0xFFDC2626)),
            const SizedBox(height: 4),
            _row(l10n.savingsAlert, '¥9,000', const Color(0xFFDC2626)),
          ],
        ),
      ),
      const SizedBox(width: 12),
      // Hareru
      Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4A90D9).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(color: const Color(0xFF4A90D9).withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.diamond_outlined, size: 14, color: Color(0xFF4A90D9)),
                const SizedBox(width: 4),
                const Text('Hareru', style: TextStyle(fontSize: 11, color: Color(0xFF2D6BB0), fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('¥23,000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF4A90D9))),
            const SizedBox(height: 4),
            Text(l10n.realExpense, style: const TextStyle(fontSize: 10, color: Color(0xFF2D6BB0))),
            const SizedBox(height: 12),
            _row(l10n.food, '¥18,000', const Color(0xFF2D6BB0)),
            const SizedBox(height: 4),
            _row(l10n.transport, '¥5,000', const Color(0xFF2D6BB0)),
            const SizedBox(height: 4),
            _strikeRow(l10n.transfer, '¥18,000'),
            const SizedBox(height: 4),
            _strikeRow(l10n.savings, '¥9,000'),
          ],
        ),
      ),
    ],
  );
}

Widget _row(String label, String amount, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(child: Text(label, style: TextStyle(fontSize: 10, color: color), overflow: TextOverflow.ellipsis)),
      Text(amount, style: TextStyle(fontSize: 10, color: color)),
    ],
  );
}

Widget _strikeRow(String label, String amount) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough)),
      Text(amount, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough)),
    ],
  );
}

// ========================================
// 슬라이드 2: 자동 분류
// ========================================
Widget _buildTransferVisual(BuildContext context, AppLocalizations l10n, bool isDark) {
  final items = [
    (label: l10n.expense, icon: '🛒', example: l10n.expenseExample, color: const Color(0xFFEF4444), bg: const Color(0xFFFEF2F2)),
    (label: l10n.transfer, icon: '🔄', example: l10n.transferExample, color: const Color(0xFFF59E0B), bg: const Color(0xFFFFFBEB)),
    (label: l10n.savings, icon: '🏦', example: l10n.savingsExample, color: const Color(0xFF10B981), bg: const Color(0xFFECFDF5)),
  ];

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(color: item.bg, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Text(item.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: item.color)),
                    const SizedBox(height: 2),
                    Text(item.example, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Text(l10n.auto, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item.color)),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

// ========================================
// 슬라이드 3: 3초 입력
// ========================================
Widget _buildSpeedVisual(BuildContext context, AppLocalizations l10n, bool isDark) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _step('①', l10n.amountInput, '1.5s', false),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('→', style: TextStyle(fontSize: 16, color: Color(0xFFCBD5E1)))),
          _step('②', l10n.category, '1s', false),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 6), child: Text('→', style: TextStyle(fontSize: 16, color: Color(0xFFCBD5E1)))),
          _step('✓', l10n.done, '0.5s', true),
        ],
      ),
      const SizedBox(height: 24),
      Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: Column(
          children: [
            const Text('¥1,280', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6, runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                _chip('🍱 ${l10n.food}', false),
                _chip('☕ ${l10n.cafe}', false),
                _chip('🚃 ${l10n.transport}', false),
                _chip('🛒 ${l10n.conveniStore}', true),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _step(String num, String label, String time, bool done) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: done ? const Color(0xFFECFDF5) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: done ? const Color(0xFF10B981) : const Color(0xFFE2E8F0), width: 1.5),
    ),
    child: Column(
      children: [
        Text(num, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: done ? const Color(0xFF10B981) : const Color(0xFF4A90D9))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(time, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
      ],
    ),
  );
}

Widget _chip(String label, bool selected) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFF4A90D9) : const Color(0xFFE2E8F0),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : const Color(0xFF475569), fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
  );
}
