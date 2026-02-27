import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/dictionary/dictionary_screen.dart';
import 'package:hareru/screens/home/home_screen.dart';
import 'package:hareru/screens/home/widgets/add_transaction_screen.dart';
import 'package:hareru/screens/report/report_screen.dart';
import 'package:hareru/screens/settings/settings_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  static const _channel = MethodChannel('app.hareru.ios/widget');
  int _currentIndex = 0;
  OverlayEntry? _toastEntry;

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleDeepLink);
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    super.dispose();
  }

  Future<void> _handleDeepLink(MethodCall call) async {
    if (call.method == 'onDeepLink') {
      final route = call.arguments as String? ?? 'home';
      if (route == 'budget' && mounted) {
        // Ensure we're on home tab, then show budget dialog
        setState(() => _currentIndex = 0);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showBudgetDialog();
        });
      }
    }
  }

  void _showBudgetDialog() {
    final l10n = AppLocalizations.of(context)!;
    final c = context.colors;
    final currentBudget = ref.read(budgetProvider);
    final controller = TextEditingController(
      text: currentBudget > 0 ? addCommas(currentBudget.toString()) : '',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: c.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.setBudgetTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [_CommaFormatter()],
            autofocus: true,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
            decoration: InputDecoration(
              prefixText: '¥ ',
              prefixStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: HareruColors.primaryStart,
              ),
              hintText: '150,000',
              hintStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: c.textTertiary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: c.divider,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: HareruColors.primaryStart,
                  width: 2,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: c.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                final digits = controller.text.replaceAll(',', '');
                final value = int.tryParse(digits) ?? 0;
                ref.read(budgetProvider.notifier).setBudget(value);
                Navigator.pop(dialogContext);
              },
              child: Text(
                l10n.save,
                style: const TextStyle(
                  color: HareruColors.primaryStart,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  final _screens = const [
    HomeScreen(),
    ReportScreen(),
    DictionaryScreen(),
    SettingsScreen(),
  ];

  void _showToast(Transaction transaction) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final color = switch (transaction.type) {
      TransactionType.expense => const Color(0xFFEF4444),
      TransactionType.transfer => const Color(0xFF5B7FCC),
      TransactionType.savings => const Color(0xFF10B981),
      TransactionType.income => const Color(0xFFF59E0B),
    };

    final typeLabel = switch (transaction.type) {
      TransactionType.expense => l10n.expense,
      TransactionType.transfer => l10n.transfer,
      TransactionType.savings => l10n.savings,
      TransactionType.income => l10n.income,
    };

    _toastEntry?.remove();
    _toastEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        color: color,
        message: l10n.recordSaved,
        detail: '$typeLabel ¥${formatAmount(transaction.amount)}',
        isDark: isDark,
        onDismiss: () {
          _toastEntry?.remove();
          _toastEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_toastEntry!);
  }


  void _openAddSheet() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => AddTransactionScreen(
          onSave: (transaction) {
            ref.read(transactionProvider.notifier).add(transaction);
            Navigator.pop(context);
            _showToast(transaction);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = c.background;

    return Scaffold(
      backgroundColor: bgColor,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: _buildFab(context, isDark, bgColor),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(context, isDark, l10n, bgColor),
    );
  }

  Widget _buildBottomNav(
      BuildContext context, bool isDark, AppLocalizations l10n, Color bgColor) {
    final navBarColor = isDark ? HareruColors.darkNavBar : HareruColors.lightNavBar;
    final inactiveColor =
        isDark ? HareruColors.navInactiveDark : HareruColors.navInactiveLight;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final tabs = [
      _TabItem(CupertinoIcons.house, CupertinoIcons.house_fill, l10n.homeTab),
      _TabItem(CupertinoIcons.chart_bar, CupertinoIcons.chart_bar_fill, l10n.reportTab),
      _TabItem(CupertinoIcons.book, CupertinoIcons.book_fill, l10n.dictionaryTab),
      _TabItem(CupertinoIcons.gear_alt, CupertinoIcons.gear_alt_fill, l10n.settingsTab),
    ];

    return Container(
      decoration: BoxDecoration(
        color: navBarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomPadding, top: 8),
      child: Row(
        children: [
          // Left 2 tabs
          ...tabs.sublist(0, 2).asMap().entries.map((e) {
            return _buildTab(e.key, tabs[e.key], inactiveColor, isDark);
          }),
          // FAB spacer
          const Expanded(child: SizedBox(height: 50)),
          // Right 2 tabs
          ...tabs.sublist(2).asMap().entries.map((e) {
            final index = e.key + 2;
            return _buildTab(index, tabs[index], inactiveColor, isDark);
          }),
        ],
      ),
    );
  }

  Widget _buildTab(
      int index, _TabItem tab, Color inactiveColor, bool isDark) {
    final isActive = index == _currentIndex;
    const activeColor = Color(0xFFE8453C);
    const deactiveColor = Color(0xFF8A8A8A);
    final color = isActive ? activeColor : deactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? tab.activeIcon : tab.icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context, bool isDark, Color bgColor) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _openAddSheet,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              color: HareruColors.primaryStart,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: HareruColors.primaryStart.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabItem(this.icon, this.activeIcon, this.label);
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.color,
    required this.message,
    required this.detail,
    required this.isDark,
    required this.onDismiss,
  });

  final Color color;
  final String message;
  final String detail;
  final bool isDark;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 8,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.detail,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (int.tryParse(digits) == null) {
      return oldValue;
    }

    final buf = StringBuffer();
    var count = 0;
    for (var i = digits.length - 1; i >= 0; i--) {
      buf.write(digits[i]);
      count++;
      if (count % 3 == 0 && i > 0) buf.write(',');
    }
    final formatted = buf.toString().split('').reversed.join();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
