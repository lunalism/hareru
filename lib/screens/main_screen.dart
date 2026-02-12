import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/dictionary/dictionary_screen.dart';
import 'package:hareru/screens/home/home_screen.dart';
import 'package:hareru/screens/report/report_screen.dart';
import 'package:hareru/screens/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    ReportScreen(),
    DictionaryScreen(),
    SettingsScreen(),
  ];

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

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Nav bar body
        Container(
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
        ),
        // FAB — positioned above nav bar
        Positioned(
          top: -28,
          child: _buildFab(context, isDark, bgColor),
        ),
      ],
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
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.preparingFeature),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 64,
        height: 64,
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
          child: const Text(
            '+',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              height: 1,
            ),
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
