import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transaction_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;

class CategoryManagementScreen extends ConsumerStatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  ConsumerState<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState
    extends ConsumerState<CategoryManagementScreen> {
  String _selectedType = 'expense';

  static const _typeColors = {
    'expense': Color(0xFFEF4444),
    'transfer': Color(0xFF3B82F6),
    'savings': Color(0xFF10B981),
    'income': Color(0xFFF59E0B),
  };

  String _typeLabel(String type, AppLocalizations l10n) {
    return switch (type) {
      'expense' => l10n.expense,
      'transfer' => l10n.transfer,
      'savings' => l10n.savings,
      'income' => l10n.income,
      _ => type,
    };
  }

  String _categoryDisplayName(cat_model.Category cat, AppLocalizations l10n) {
    if (!cat.isDefault) return cat.name;
    return resolveL10nKey(cat.name, l10n);
  }

  void _showAddDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emojiController = TextEditingController();
    final nameController = TextEditingController();

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
                    borderSide: BorderSide(
                        color: _typeColors[_selectedType]!, width: 2),
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
                    borderSide: BorderSide(
                        color: _typeColors[_selectedType]!, width: 2),
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
                        _selectedType,
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(
                l10n.save,
                style: TextStyle(
                  color: _typeColors[_selectedType],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, cat_model.Category cat) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emojiController = TextEditingController(text: cat.emoji);
    final nameController = TextEditingController(
      text: cat.isDefault ? _categoryDisplayName(cat, l10n) : cat.name,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? HareruColors.darkCard : HareruColors.lightCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.editCategory,
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
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
                decoration: InputDecoration(
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
                    borderSide: BorderSide(
                        color: _typeColors[_selectedType]!, width: 2),
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
                    borderSide: BorderSide(
                        color: _typeColors[_selectedType]!, width: 2),
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
                  ref.read(categoryProvider.notifier).updateCategory(
                        cat.id,
                        cat.isDefault ? cat.name : name,
                        emoji.isEmpty ? '\u{1F4C1}' : emoji,
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(
                l10n.save,
                style: TextStyle(
                  color: _typeColors[_selectedType],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleDelete(BuildContext context, cat_model.Category cat) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (cat.isDefault) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.cannotDeleteDefault),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final transactions = ref.read(transactionProvider);
    final count = transactions.where((t) => t.category == cat.id).length;

    if (count > 0) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor:
                isDark ? HareruColors.darkCard : HareruColors.lightCard,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(
              l10n.deleteCategory,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
            ),
            content: Text(
              l10n.deleteCategoryConfirm(count),
              style: TextStyle(
                color: isDark
                    ? HareruColors.darkTextSecondary
                    : HareruColors.lightTextSecondary,
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
                  ref
                      .read(categoryProvider.notifier)
                      .deleteCategory(cat.id);
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  l10n.deleteCategory,
                  style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      ref.read(categoryProvider.notifier).deleteCategory(cat.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    ref.watch(categoryProvider);
    final categories =
        ref.read(categoryProvider.notifier).getCategoriesByType(_selectedType);

    return Scaffold(
      backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
      appBar: AppBar(
        backgroundColor: isDark ? HareruColors.darkBg : HareruColors.lightBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.categoryManagement,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Type tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: _buildTypeTabs(l10n, isDark),
          ),
          const SizedBox(height: 8),
          // Category list
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final ids = categories.map((c) => c.id).toList();
                final item = ids.removeAt(oldIndex);
                ids.insert(newIndex, item);
                ref
                    .read(categoryProvider.notifier)
                    .reorderCategories(_selectedType, ids);
              },
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.transparent,
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final cat = categories[index];
                final displayName = _categoryDisplayName(cat, l10n);

                return Dismissible(
                  key: ValueKey('dismiss_${cat.id}'),
                  direction: cat.isDefault
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (cat.isDefault) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.cannotDeleteDefault),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return false;
                    }
                    _handleDelete(context, cat);
                    return false;
                  },
                  child: Container(
                    key: ValueKey(cat.id),
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? HareruColors.darkCard
                          : HareruColors.lightCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      child: Row(
                        children: [
                          Icon(
                            Icons.drag_handle_rounded,
                            color: isDark
                                ? HareruColors.darkTextTertiary
                                : HareruColors.lightTextTertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(cat.emoji,
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? HareruColors.darkTextPrimary
                                    : HareruColors.lightTextPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showEditDialog(context, cat),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: isDark
                                  ? HareruColors.darkTextTertiary
                                  : HareruColors.lightTextTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Add button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () => _showAddDialog(context),
                icon: Icon(Icons.add_rounded,
                    color: _typeColors[_selectedType]),
                label: Text(
                  l10n.addCategory,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _typeColors[_selectedType],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: _typeColors[_selectedType]!
                          .withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildTypeTabs(AppLocalizations l10n, bool isDark) {
    final types = ['expense', 'transfer', 'savings', 'income'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: types.map((type) {
          final isSelected = type == _selectedType;
          final color = _typeColors[type]!;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedType = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? HareruColors.darkBg : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color
                            : (isDark
                                ? HareruColors.darkTextTertiary
                                : HareruColors.lightTextTertiary),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _typeLabel(type, l10n),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? color
                            : (isDark
                                ? HareruColors.darkTextTertiary
                                : HareruColors.lightTextTertiary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
