import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/models/category.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'categories';

class CategoryNotifier extends StateNotifier<List<Category>> {
  CategoryNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    final box = await Hive.openBox<Category>(_boxName);
    if (box.isEmpty) {
      await _seedDefaults(box);
    }
    _loadFromBox(box);
  }

  void _loadFromBox(Box<Category> box) {
    final items = box.values.toList();
    items.sort((a, b) {
      final typeCompare = a.type.compareTo(b.type);
      if (typeCompare != 0) return typeCompare;
      return a.sortOrder.compareTo(b.sortOrder);
    });
    state = items;
  }

  List<Category> getCategoriesByType(String type) {
    final filtered = state.where((c) => c.type == type).toList();
    filtered.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return filtered;
  }

  Future<void> addCategory(String name, String emoji, String type) async {
    final box = await Hive.openBox<Category>(_boxName);
    final existing = getCategoriesByType(type);
    final maxSort =
        existing.isEmpty ? 0 : existing.map((c) => c.sortOrder).reduce((a, b) => a > b ? a : b);
    final cat = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      emoji: emoji,
      type: type,
      sortOrder: maxSort + 1,
      isDefault: false,
      createdAt: DateTime.now(),
    );
    await box.put(cat.id, cat);
    _loadFromBox(box);
  }

  Future<void> updateCategory(String id, String name, String emoji) async {
    final box = await Hive.openBox<Category>(_boxName);
    final existing = box.get(id);
    if (existing == null) return;
    final updated = Category(
      id: existing.id,
      name: name,
      emoji: emoji,
      type: existing.type,
      sortOrder: existing.sortOrder,
      isDefault: existing.isDefault,
      createdAt: existing.createdAt,
    );
    await box.put(id, updated);
    _loadFromBox(box);
  }

  Future<void> deleteCategory(String id) async {
    final box = await Hive.openBox<Category>(_boxName);
    await box.delete(id);
    _loadFromBox(box);
  }

  Future<void> reorderCategories(String type, List<String> orderedIds) async {
    final box = await Hive.openBox<Category>(_boxName);
    for (var i = 0; i < orderedIds.length; i++) {
      final existing = box.get(orderedIds[i]);
      if (existing != null) {
        final updated = Category(
          id: existing.id,
          name: existing.name,
          emoji: existing.emoji,
          type: existing.type,
          sortOrder: i,
          isDefault: existing.isDefault,
          createdAt: existing.createdAt,
        );
        await box.put(orderedIds[i], updated);
      }
    }
    _loadFromBox(box);
  }

  Category? getCategoryById(String id) {
    try {
      return state.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _seedDefaults(Box<Category> box) async {
    final now = DateTime.now();
    final defaults = <Category>[
      // Expense
      Category(id: 'catFood', name: 'catFood', emoji: '\u{1F35A}', type: 'expense', sortOrder: 0, isDefault: true, createdAt: now),
      Category(id: 'catTransport', name: 'catTransport', emoji: '\u{1F683}', type: 'expense', sortOrder: 1, isDefault: true, createdAt: now),
      Category(id: 'catHousing', name: 'catHousing', emoji: '\u{1F3E0}', type: 'expense', sortOrder: 2, isDefault: true, createdAt: now),
      Category(id: 'catUtility', name: 'catUtility', emoji: '\u{1F4A1}', type: 'expense', sortOrder: 3, isDefault: true, createdAt: now),
      Category(id: 'catPhone', name: 'catPhone', emoji: '\u{1F4F1}', type: 'expense', sortOrder: 4, isDefault: true, createdAt: now),
      Category(id: 'catDaily', name: 'catDaily', emoji: '\u{1F6D2}', type: 'expense', sortOrder: 5, isDefault: true, createdAt: now),
      Category(id: 'catClothing', name: 'catClothing', emoji: '\u{1F455}', type: 'expense', sortOrder: 6, isDefault: true, createdAt: now),
      Category(id: 'catMedical', name: 'catMedical', emoji: '\u{1F3E5}', type: 'expense', sortOrder: 7, isDefault: true, createdAt: now),
      Category(id: 'catSocial', name: 'catSocial', emoji: '\u{1F389}', type: 'expense', sortOrder: 8, isDefault: true, createdAt: now),
      Category(id: 'catHobby', name: 'catHobby', emoji: '\u{1F3AE}', type: 'expense', sortOrder: 9, isDefault: true, createdAt: now),
      Category(id: 'catEducation', name: 'catEducation', emoji: '\u{1F4DA}', type: 'expense', sortOrder: 10, isDefault: true, createdAt: now),
      Category(id: 'catOther', name: 'catOther', emoji: '\u{1F4C1}', type: 'expense', sortOrder: 11, isDefault: true, createdAt: now),
      // Transfer
      Category(id: 'catBankTransfer', name: 'catBankTransfer', emoji: '\u{1F3E6}', type: 'transfer', sortOrder: 0, isDefault: true, createdAt: now),
      Category(id: 'catCard', name: 'catCard', emoji: '\u{1F4B3}', type: 'transfer', sortOrder: 1, isDefault: true, createdAt: now),
      Category(id: 'catEMoney', name: 'catEMoney', emoji: '\u{1F4F2}', type: 'transfer', sortOrder: 2, isDefault: true, createdAt: now),
      Category(id: 'catTransferOther', name: 'catTransferOther', emoji: '\u{1F4C1}', type: 'transfer', sortOrder: 3, isDefault: true, createdAt: now),
      // Savings
      Category(id: 'catSavings', name: 'catSavings', emoji: '\u{1F3E6}', type: 'savings', sortOrder: 0, isDefault: true, createdAt: now),
      Category(id: 'catInvestment', name: 'catInvestment', emoji: '\u{1F4C8}', type: 'savings', sortOrder: 1, isDefault: true, createdAt: now),
      Category(id: 'catGoal', name: 'catGoal', emoji: '\u{1F3AF}', type: 'savings', sortOrder: 2, isDefault: true, createdAt: now),
      Category(id: 'catSavingsOther', name: 'catSavingsOther', emoji: '\u{1F4C1}', type: 'savings', sortOrder: 3, isDefault: true, createdAt: now),
      // Income
      Category(id: 'salary', name: 'salary', emoji: '\u{1F4B0}', type: 'income', sortOrder: 0, isDefault: true, createdAt: now),
      Category(id: 'sideJob', name: 'sideJob', emoji: '\u{1F4BC}', type: 'income', sortOrder: 1, isDefault: true, createdAt: now),
      Category(id: 'bonus', name: 'bonus', emoji: '\u{1F381}', type: 'income', sortOrder: 2, isDefault: true, createdAt: now),
      Category(id: 'allowance', name: 'allowance', emoji: '\u{1F45B}', type: 'income', sortOrder: 3, isDefault: true, createdAt: now),
      Category(id: 'investmentReturn', name: 'investmentReturn', emoji: '\u{1F4C8}', type: 'income', sortOrder: 4, isDefault: true, createdAt: now),
      Category(id: 'fleaMarket', name: 'fleaMarket', emoji: '\u{1F4E6}', type: 'income', sortOrder: 5, isDefault: true, createdAt: now),
      Category(id: 'extraIncome', name: 'extraIncome', emoji: '\u{1F4B4}', type: 'income', sortOrder: 6, isDefault: true, createdAt: now),
      Category(id: 'otherIncome', name: 'otherIncome', emoji: '\u{1F4C1}', type: 'income', sortOrder: 7, isDefault: true, createdAt: now),
    ];

    for (final cat in defaults) {
      await box.put(cat.id, cat);
    }
  }
}

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<Category>>(
  (ref) => CategoryNotifier(),
);
