import 'package:flutter/material.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';

class CategoryEntry {
  const CategoryEntry({
    required this.emoji,
    required this.localeKey,
  });

  final String emoji;
  final String localeKey;

  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (localeKey) {
      case 'food':
        return l10n.categoryFood;
      case 'transport':
        return l10n.categoryTransport;
      case 'shopping':
        return l10n.categoryShopping;
      case 'cafe':
        return l10n.categoryCafe;
      case 'entertainment':
        return l10n.categoryEntertainment;
      case 'medical':
        return l10n.categoryMedical;
      case 'transfer':
        return l10n.categoryTransfer;
      case 'other':
        return l10n.categoryOther;
      case 'salary':
        return l10n.categorySalary;
      case 'allowance':
        return l10n.categoryAllowance;
      case 'sidejob':
        return l10n.categorySidejob;
      case 'investment':
        return l10n.categoryInvestment;
      default:
        return localeKey;
    }
  }
}

class DefaultCategories {
  static const expense = [
    CategoryEntry(emoji: '🍱', localeKey: 'food'),
    CategoryEntry(emoji: '🚃', localeKey: 'transport'),
    CategoryEntry(emoji: '🛒', localeKey: 'shopping'),
    CategoryEntry(emoji: '☕', localeKey: 'cafe'),
    CategoryEntry(emoji: '🎮', localeKey: 'entertainment'),
    CategoryEntry(emoji: '💊', localeKey: 'medical'),
    CategoryEntry(emoji: '📎', localeKey: 'other'),
  ];

  static const income = [
    CategoryEntry(emoji: '💰', localeKey: 'salary'),
    CategoryEntry(emoji: '🎁', localeKey: 'allowance'),
    CategoryEntry(emoji: '💼', localeKey: 'sidejob'),
    CategoryEntry(emoji: '📈', localeKey: 'investment'),
    CategoryEntry(emoji: '📎', localeKey: 'other'),
  ];

  static const transfer = [
    CategoryEntry(emoji: '💳', localeKey: 'transfer'),
  ];

  static String emojiForKey(String key) {
    for (final list in [expense, income, transfer]) {
      for (final entry in list) {
        if (entry.localeKey == key) return entry.emoji;
      }
    }
    return '📎';
  }
}
