import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/custom_colors.dart';
import '../providers/settings_provider.dart';

class CategoryManagePage extends ConsumerWidget {
  const CategoryManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(settingsProvider).categories;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.categoryManage,
          style: TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showAddDialog(context, ref),
            child: Text(
              l10n.add,
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        onReorder: (oldIndex, newIndex) {
          ref.read(settingsProvider.notifier).reorderCategories(oldIndex, newIndex);
        },
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: child,
            ),
            child: child,
          );
        },
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            key: ValueKey('${cat.emoji}_${cat.name}_$index'),
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle,
                        color: custom.nightLight, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: custom.skyBlueLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(cat.emoji, style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              title: Text(
                cat.getDisplayName(context),
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle_outline,
                    color: custom.expenseRed, size: 22),
                onPressed: () {
                  ref.read(settingsProvider.notifier).removeCategory(index);
                },
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;
    const emojiOptions = ['🍽️', '🏠', '👕', '🎬', '📚', '🏋️', '🎁', '💡'];
    String selectedEmoji = emojiOptions[0];
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.categoryAdd,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: emojiOptions.map((e) {
                  final isSelected = selectedEmoji == e;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedEmoji = e),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? custom.skyBlueLight
                            : theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(e, style: const TextStyle(fontSize: 22)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: l10n.categoryName,
                  hintStyle: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 14,
                    color: custom.nightLight,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: theme.colorScheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  color: custom.nightLight,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  ref.read(settingsProvider.notifier).addCategory(
                        CategoryItem(emoji: selectedEmoji, name: name),
                      );
                  Navigator.pop(ctx);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
