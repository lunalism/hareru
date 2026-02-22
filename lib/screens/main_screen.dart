import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/dictionary/dictionary_screen.dart';
import 'package:hareru/screens/home/home_screen.dart';
import 'package:hareru/screens/home/widgets/add_transaction_sheet.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentBudget = ref.read(budgetProvider);
    final controller = TextEditingController(
      text: currentBudget > 0 ? _formatWithCommas(currentBudget.toString()) : '',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? HareruColors.darkCard : HareruColors.lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.setBudgetTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
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
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
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
                color: isDark
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? HareruColors.darkDivider
                      : HareruColors.lightDivider,
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
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
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

  String _formatWithCommas(String digits) {
    final buf = StringBuffer();
    var count = 0;
    for (var i = digits.length - 1; i >= 0; i--) {
      buf.write(digits[i]);
      count++;
      if (count % 3 == 0 && i > 0) buf.write(',');
    }
    return buf.toString().split('').reversed.join();
  }

  final _screens = const [
    HomeScreen(),
    ReportScreen(),
    DictionaryScreen(),
    SettingsScreen(),
  ];

  void _showToast(Transaction transaction) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = switch (transaction.type) {
      TransactionType.expense => const Color(0xFFEF4444),
      TransactionType.transfer => const Color(0xFF3B82F6),
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
        detail: '$typeLabel ¥${_formatNumber(transaction.amount)}',
        isDark: isDark,
        onDismiss: () {
          _toastEntry?.remove();
          _toastEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_toastEntry!);
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble()) {
      return _addCommas(value.truncate().toString());
    }
    return _addCommas(value.toStringAsFixed(2));
  }

  String _addCommas(String s) {
    final parts = s.split('.');
    final intPart = parts[0];
    final result = StringBuffer();
    var count = 0;
    for (var i = intPart.length - 1; i >= 0; i--) {
      result.write(intPart[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    final formatted = result.toString().split('').reversed.join();
    return parts.length > 1 ? '$formatted.${parts[1]}' : formatted;
  }

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: AddTransactionSheet(
            onSave: (transaction) {
              ref.read(transactionProvider.notifier).add(transaction);
              Navigator.pop(sheetContext);
              _showToast(transaction);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = isDark ? HareruColors.darkBg : HareruColors.lightBg;

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
      _TabItem(Icons.home_rounded, l10n.homeTab),
      _TabItem(Icons.bar_chart_rounded, l10n.reportTab),
      _TabItem(Icons.book_outlined, l10n.dictionaryTab),
      _TabItem(Icons.settings_outlined, l10n.settingsTab),
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
    final color = isActive ? HareruColors.primaryStart : inactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _currentIndex = index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, size: 24, color: color),
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
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [HareruColors.primaryStart, HareruColors.primaryEnd],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: HareruColors.primaryStart.withValues(alpha: 0.35),
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
  final String label;
  const _TabItem(this.icon, this.label);
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
