import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;
import 'package:hareru/screens/home/widgets/add_transaction/category_grid.dart';

class ExpenseTab extends StatelessWidget {
  const ExpenseTab({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedPayment,
    required this.onCategorySelect,
    required this.onQuickAdd,
    required this.onPaymentSelect,
    required this.isDark,
  });

  final List<cat_model.Category> categories;
  final String? selectedCategory;
  final int selectedPayment;
  final void Function(String) onCategorySelect;
  final VoidCallback onQuickAdd;
  final void Function(int) onPaymentSelect;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category section
        Text(
          l10n.category,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 10),
        CategoryGrid(
          categories: categories,
          selectedCategory: selectedCategory,
          onSelect: onCategorySelect,
          onQuickAdd: onQuickAdd,
          isDark: isDark,
        ),
        const SizedBox(height: 24),

        // Payment method chips
        Text(
          l10n.paymentMethod,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 10),
        _PaymentChips(
          selectedPayment: selectedPayment,
          onSelect: onPaymentSelect,
          isDark: isDark,
        ),
      ],
    );
  }
}

class _PaymentChips extends StatelessWidget {
  const _PaymentChips({
    required this.selectedPayment,
    required this.onSelect,
    required this.isDark,
  });

  final int selectedPayment;
  final void Function(int) onSelect;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [l10n.creditCard, l10n.debitCard, l10n.cash];

    return Row(
      children: List.generate(labels.length, (i) {
        final isSelected = selectedPayment == i;
        return Padding(
          padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary)
                    : (isDark ? HareruColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? HareruColors.darkDivider
                            : HareruColors.lightDivider,
                      ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? (isDark
                          ? HareruColors.darkBg
                          : Colors.white)
                      : (isDark
                          ? HareruColors.darkTextSecondary
                          : HareruColors.lightTextSecondary),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
