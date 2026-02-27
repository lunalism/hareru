import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/transfer_account_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;
import 'package:hareru/screens/home/widgets/add_transaction/account_chip_section.dart';
import 'package:hareru/screens/home/widgets/add_transaction/category_grid.dart';

class IncomeTab extends ConsumerWidget {
  const IncomeTab({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.depositAccount,
    required this.onCategorySelect,
    required this.onQuickAdd,
    required this.onDepositSelect,
    required this.isDark,
  });

  final List<cat_model.Category> categories;
  final String? selectedCategory;
  final String? depositAccount;
  final void Function(String) onCategorySelect;
  final VoidCallback onQuickAdd;
  final void Function(String) onDepositSelect;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accounts = ref.watch(transferAccountProvider);

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

        // Deposit account chips
        Text(
          l10n.incomeDepositTo,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        AccountChipSection(
          accounts: accounts,
          selectedId: depositAccount,
          disabledId: null,
          onSelect: onDepositSelect,
          isDark: isDark,
        ),
      ],
    );
  }
}
