import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;
import 'package:hareru/models/transaction.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    required this.onQuickAdd,
    required this.isDark,
  });

  final List<cat_model.Category> categories;
  final String? selectedCategory;
  final void Function(String) onSelect;
  final VoidCallback onQuickAdd;
  final bool isDark;

  String _categoryDisplayName(cat_model.Category cat, AppLocalizations l10n) {
    if (!cat.isDefault) return cat.name;
    return resolveL10nKey(cat.name, l10n);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemCount = categories.length + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.05,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return GestureDetector(
            onTap: onQuickAdd,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? HareruColors.darkCard
                    : HareruColors.lightBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? HareruColors.darkDivider
                      : HareruColors.lightDivider,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 24,
                    color: isDark
                        ? HareruColors.darkTextTertiary
                        : HareruColors.lightTextTertiary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.add,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? HareruColors.darkTextTertiary
                          : HareruColors.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final cat = categories[index];
        final isSelected = selectedCategory == cat.id;
        final displayName = _categoryDisplayName(cat, l10n);

        return GestureDetector(
          onTap: () => onSelect(cat.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? HareruColors.primaryStart
                  : (isDark
                      ? HareruColors.darkCard
                      : HareruColors.lightBg),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 3),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? HareruColors.darkTextPrimary
                            : HareruColors.lightTextPrimary),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void showQuickAddCategoryDialog({
  required BuildContext context,
  required WidgetRef ref,
  required TransactionType selectedType,
  required bool isDark,
  required void Function(String) onCategoryAdded,
}) {
  final l10n = AppLocalizations.of(context)!;
  const activeColor = HareruColors.primaryStart;
  final emojiController = TextEditingController();
  final nameController = TextEditingController();

  final typeStr = switch (selectedType) {
    TransactionType.expense => 'expense',
    TransactionType.transfer => 'transfer',
    TransactionType.savings => 'savings',
    TransactionType.income => 'income',
  };

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor:
            isDark ? HareruColors.darkCard : HareruColors.lightCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.addCategory,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emojiController,
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32),
              decoration: InputDecoration(
                hintText: '\u{1F4C1}',
                hintStyle: TextStyle(
                  fontSize: 32,
                  color: isDark
                      ? HareruColors.darkTextTertiary
                      : HareruColors.lightTextTertiary,
                ),
                labelText: l10n.categoryEmoji,
                labelStyle: TextStyle(
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: activeColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nameController,
              maxLength: 10,
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: l10n.categoryName,
                labelStyle: TextStyle(
                  color: isDark
                      ? HareruColors.darkTextSecondary
                      : HareruColors.lightTextSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: activeColor, width: 2),
                ),
              ),
            ),
          ],
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
              final emoji = emojiController.text.trim();
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(categoryProvider.notifier).addCategory(
                      name,
                      emoji.isEmpty ? '\u{1F4C1}' : emoji,
                      typeStr,
                    );
                Navigator.pop(dialogContext);
                Future.delayed(const Duration(milliseconds: 100), () {
                  final cats = ref
                      .read(categoryProvider.notifier)
                      .getCategoriesByType(typeStr);
                  if (cats.isNotEmpty) {
                    onCategoryAdded(cats.last.id);
                  }
                });
              }
            },
            child: Text(
              l10n.save,
              style: const TextStyle(
                color: activeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}
