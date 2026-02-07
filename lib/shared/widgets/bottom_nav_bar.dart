import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../../core/theme/custom_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final custom = theme.extension<CustomColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab(context, 0, Icons.home_rounded, l10n.home, custom),
              _buildTab(context, 1, Icons.bar_chart_rounded, l10n.report, custom),
              _buildAddButton(context, l10n, custom),
              _buildTab(context, 3, Icons.menu_book_rounded, l10n.dictionary, custom),
              _buildTab(context, 4, Icons.settings_rounded, l10n.settings, custom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, IconData icon, String label, CustomColors custom) {
    final theme = Theme.of(context);
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? theme.colorScheme.primary : custom.nightLight,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? theme.colorScheme.primary : custom.nightLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, AppLocalizations l10n, CustomColors custom) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onTap(2),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -4,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              child: Text(
                l10n.input,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
