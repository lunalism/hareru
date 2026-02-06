import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';
import '../providers/settings_provider.dart';

class CategoryManagePage extends ConsumerWidget {
  const CategoryManagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(settingsProvider).categories;

    return Scaffold(
      backgroundColor: AppColors.cloud,
      appBar: AppBar(
        backgroundColor: AppColors.cloud,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          '카테고리 관리',
          style: AppTypography.body.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showAddDialog(context, ref),
            child: Text(
              '추가',
              style: AppTypography.body.copyWith(
                color: AppColors.skyBlue,
                fontWeight: FontWeight.w600,
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
              color: AppColors.cardWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle,
                        color: AppColors.nightLight, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.skyBlueLight,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(cat.emoji, style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
              title: Text(
                cat.name,
                style: AppTypography.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline,
                    color: AppColors.expense, size: 22),
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
    const emojiOptions = ['🍽️', '🏠', '👕', '🎬', '📚', '🏋️', '🎁', '💡'];
    String selectedEmoji = emojiOptions[0];
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '카테고리 추가',
            style: AppTypography.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
                            ? AppColors.skyBlueLight
                            : AppColors.cloud,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(color: AppColors.skyBlue, width: 1.5)
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
                  hintText: '카테고리명',
                  hintStyle: AppTypography.body.copyWith(
                    color: AppColors.nightLight,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.skyBlue, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                style: AppTypography.body.copyWith(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                '취소',
                style: AppTypography.body.copyWith(color: AppColors.nightLight),
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
                backgroundColor: AppColors.skyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '저장',
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
