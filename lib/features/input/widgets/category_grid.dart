import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/default_categories.dart';
import '../../../shared/models/transaction_type.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/input_provider.dart';
import 'category_chip.dart';

class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(inputProvider);
    final type = formState.transactionType;
    final selectedKey = formState.selectedCategoryKey;

    final List<CategoryEntry> categories;
    switch (type) {
      case TransactionType.expense:
        // Use user's configured categories from settings for expense
        final settingsCategories = ref.watch(settingsProvider).categories;
        categories = settingsCategories
            .where((c) => c.localeKey != 'transfer')
            .map((c) => CategoryEntry(
                  emoji: c.emoji,
                  localeKey: c.localeKey ?? c.name,
                ))
            .toList();
      case TransactionType.income:
        categories = DefaultCategories.income;
      case TransactionType.transfer:
        categories = DefaultCategories.transfer;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final displayName = cat.getDisplayName(context);
          final key = cat.localeKey;

          return CategoryChip(
            emoji: cat.emoji,
            label: displayName,
            isSelected: selectedKey == key,
            onTap: () {
              ref.read(inputProvider.notifier).setCategory(cat.emoji, key);
            },
          );
        },
      ),
    );
  }
}
