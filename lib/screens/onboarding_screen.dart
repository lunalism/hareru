import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/pay_day_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Setup slide state
  int _selectedPayDay = 25;
  final TextEditingController _budgetController = TextEditingController();

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveAndComplete() {
    ref.read(payDayProvider.notifier).setPayDay(_selectedPayDay);
    final budgetText = _budgetController.text.replaceAll(',', '');
    final budget = int.tryParse(budgetText) ?? 0;
    if (budget > 0) {
      ref.read(budgetProvider.notifier).setBudget(budget);
    }
    _completeOnboarding();
  }

  void _completeOnboarding() {
    context.go('/main');
  }

  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value.replaceAll(',', ''));
    if (number == null) return value;
    return NumberFormat('#,###').format(number);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSetupPage = _currentPage == 3;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip (hide on setup page)
            if (!isSetupPage)
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
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            // PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildSlidePage(
                    l10n.onboarding1Title,
                    l10n.onboarding1Desc,
                    _buildCompareVisual(context, l10n, isDark),
                    isDark,
                  ),
                  _buildSlidePage(
                    l10n.onboarding2Title,
                    l10n.onboarding2Desc,
                    _buildTransferVisual(context, l10n, isDark),
                    isDark,
                  ),
                  _buildSlidePage(
                    l10n.onboarding3Title,
                    l10n.onboarding3Desc,
                    _buildSpeedVisual(context, l10n, isDark),
                    isDark,
                  ),
                  _buildSetupPage(context, l10n, isDark),
                ],
              ),
            ),

            // Bottom area: indicator + button
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Page indicators
                  ...List.generate(4, (index) {
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
                            : (isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0)),
                      ),
                    );
                  }),
                  // Skip link on setup page
                  if (isSetupPage) ...[
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _completeOnboarding,
                      child: Text(
                        l10n.setupLater,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // CTA button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: isSetupPage
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4F9CF7), Color(0xFF3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ElevatedButton(
                          onPressed: _saveAndComplete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.getStarted,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      )
                    : ElevatedButton(
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
                          l10n.onboardingNext,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlidePage(
      String title, String description, Widget visual, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 280, child: visual),
          const SizedBox(height: 32),
          Text(
            title,
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
            description,
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
  }

  Widget _buildSetupPage(
      BuildContext context, AppLocalizations l10n, bool isDark) {
    final locale = Localizations.localeOf(context);
    String currencySymbol;
    switch (locale.languageCode) {
      case 'ko':
        currencySymbol = '\u20a9';
        break;
      case 'en':
        currencySymbol = '\$';
        break;
      default:
        currencySymbol = '\u00a5';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            '\u{1F4C5}',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.easySetup,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.setupDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 32),

          // Pay day card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('\u{1F4B0}', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      l10n.payDay,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      l10n.everyMonth,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: _selectedPayDay,
                          isDense: true,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF3B82F6),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                          dropdownColor: isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : const Color(0xFF94A3B8),
                          ),
                          items: [
                            ...List.generate(
                              31,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text('${i + 1}'),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 32,
                              child: Text(l10n.payDayEndOfMonth),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _selectedPayDay = value);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_selectedPayDay <= 31)
                      Text(
                        _selectedPayDay == 32
                            ? ''
                            : Localizations.localeOf(context).languageCode ==
                                    'en'
                                ? ''
                                : '\u65E5',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Budget card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF334155)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('\u{1F3AF}', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      l10n.monthlyBudget,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3B82F6),
                  ),
                  decoration: InputDecoration(
                    prefixText: '$currencySymbol ',
                    prefixStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3B82F6),
                    ),
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF3B82F6),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  onChanged: (value) {
                    final formatted = _formatNumber(value);
                    if (formatted != value) {
                      _budgetController.value = TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ========================================
// 슬라이드 1: 비교 비주얼
// ========================================
Widget _buildCompareVisual(
    BuildContext context, AppLocalizations l10n, bool isDark) {
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
            Text(l10n.otherApps,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF991B1B),
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text('\u00a550,000',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFDC2626))),
            const SizedBox(height: 4),
            Text(l10n.looksLikeExpense,
                style:
                    const TextStyle(fontSize: 10, color: Color(0xFF991B1B))),
            const SizedBox(height: 12),
            _row(l10n.food, '\u00a518,000', const Color(0xFFB91C1C)),
            const SizedBox(height: 4),
            _row(l10n.transport, '\u00a55,000', const Color(0xFFB91C1C)),
            const SizedBox(height: 4),
            _row(l10n.transferAlert, '\u00a518,000',
                const Color(0xFFDC2626)),
            const SizedBox(height: 4),
            _row(l10n.savingsAlert, '\u00a59,000', const Color(0xFFDC2626)),
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
          border: Border.all(
              color: const Color(0xFF4A90D9).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF4A90D9).withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.diamond_outlined,
                    size: 14, color: Color(0xFF4A90D9)),
                const SizedBox(width: 4),
                const Text('Hareru',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2D6BB0),
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('\u00a523,000',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A90D9))),
            const SizedBox(height: 4),
            Text(l10n.realExpense,
                style:
                    const TextStyle(fontSize: 10, color: Color(0xFF2D6BB0))),
            const SizedBox(height: 12),
            _row(l10n.food, '\u00a518,000', const Color(0xFF2D6BB0)),
            const SizedBox(height: 4),
            _row(l10n.transport, '\u00a55,000', const Color(0xFF2D6BB0)),
            const SizedBox(height: 4),
            _strikeRow(l10n.transfer, '\u00a518,000'),
            const SizedBox(height: 4),
            _strikeRow(l10n.savings, '\u00a59,000'),
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
      Flexible(
          child: Text(label,
              style: TextStyle(fontSize: 10, color: color),
              overflow: TextOverflow.ellipsis)),
      Text(amount, style: TextStyle(fontSize: 10, color: color)),
    ],
  );
}

Widget _strikeRow(String label, String amount) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label,
          style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              decoration: TextDecoration.lineThrough)),
      Text(amount,
          style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF94A3B8),
              decoration: TextDecoration.lineThrough)),
    ],
  );
}

// ========================================
// 슬라이드 2: 자동 분류
// ========================================
Widget _buildTransferVisual(
    BuildContext context, AppLocalizations l10n, bool isDark) {
  final items = [
    (
      label: l10n.expense,
      icon: '\u{1F6D2}',
      example: l10n.expenseExample,
      color: const Color(0xFFEF4444),
      bg: const Color(0xFFFEF2F2)
    ),
    (
      label: l10n.transfer,
      icon: '\u{1F504}',
      example: l10n.transferExample,
      color: const Color(0xFFF59E0B),
      bg: const Color(0xFFFFFBEB)
    ),
    (
      label: l10n.savings,
      icon: '\u{1F3E6}',
      example: l10n.savingsExample,
      color: const Color(0xFF10B981),
      bg: const Color(0xFFECFDF5)
    ),
  ];

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
              color: item.bg, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Text(item.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: item.color)),
                    const SizedBox(height: 2),
                    Text(item.example,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Text(l10n.auto,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.color)),
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
Widget _buildSpeedVisual(
    BuildContext context, AppLocalizations l10n, bool isDark) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _step('\u2460', l10n.amountInput, '1.5s', false),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('\u2192',
                  style:
                      TextStyle(fontSize: 16, color: Color(0xFFCBD5E1)))),
          _step('\u2461', l10n.category, '1s', false),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('\u2192',
                  style:
                      TextStyle(fontSize: 16, color: Color(0xFFCBD5E1)))),
          _step('\u2713', l10n.done, '0.5s', true),
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
            const Text('\u00a51,280',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A))),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                _chip('\u{1F371} ${l10n.food}', false),
                _chip('\u2615 ${l10n.cafe}', false),
                _chip('\u{1F683} ${l10n.transport}', false),
                _chip('\u{1F6D2} ${l10n.conveniStore}', true),
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
      border: Border.all(
          color:
              done ? const Color(0xFF10B981) : const Color(0xFFE2E8F0),
          width: 1.5),
    ),
    child: Column(
      children: [
        Text(num,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: done
                    ? const Color(0xFF10B981)
                    : const Color(0xFF4A90D9))),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(time,
            style:
                const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
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
    child: Text(label,
        style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.white : const Color(0xFF475569),
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
  );
}
