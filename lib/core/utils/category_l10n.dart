import 'package:flutter/widgets.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';

String resolveL10nKey(String key, AppLocalizations l10n) {
  return switch (key) {
    'catFood' => l10n.catFood,
    'catTransport' => l10n.catTransport,
    'catDaily' => l10n.catDaily,
    'catCafe' => l10n.catCafe,
    'catHobby' => l10n.catHobby,
    'catClothing' => l10n.catClothing,
    'catMedical' => l10n.catMedical,
    'catPhone' => l10n.catPhone,
    'catHousing' => l10n.catHousing,
    'catSocial' => l10n.catSocial,
    'catEducation' => l10n.catEducation,
    'catOther' => l10n.catOther,
    'catUtility' => l10n.catUtility,
    'catBankTransfer' => l10n.catBankTransfer,
    'catCard' => l10n.catCard,
    'catEMoney' => l10n.catEMoney,
    'catTransferOther' => l10n.catTransferOther,
    'catSavings' => l10n.catSavings,
    'catInvestment' => l10n.catInvestment,
    'catGoal' => l10n.catGoal,
    'catSavingsOther' => l10n.catSavingsOther,
    'salary' => l10n.salary,
    'sideJob' => l10n.sideJob,
    'bonus' => l10n.bonus,
    'allowance' => l10n.allowance,
    'investmentReturn' => l10n.investmentReturn,
    'fleaMarket' => l10n.fleaMarket,
    'extraIncome' => l10n.extraIncome,
    'otherIncome' => l10n.otherIncome,
    _ => key,
  };
}

String categoryLabel(
  String category,
  AppLocalizations l10n,
  CategoryNotifier notifier,
) {
  if (category.contains(' → ')) {
    final parts = category.split(' → ');
    final baseCat = notifier.getCategoryById(parts[0]);
    final baseLabel = baseCat == null
        ? resolveL10nKey(parts[0], l10n)
        : baseCat.isDefault
            ? resolveL10nKey(baseCat.name, l10n)
            : baseCat.name;
    return '$baseLabel → ${parts[1]}';
  }
  final cat = notifier.getCategoryById(category);
  if (cat == null) return resolveL10nKey(category, l10n);
  if (!cat.isDefault) return cat.name;
  return resolveL10nKey(cat.name, l10n);
}

String emojiForCategory(
  String category,
  TransactionType type,
  CategoryNotifier notifier,
) {
  if (type == TransactionType.transfer && category.contains(' → ')) {
    final first = category.characters.first;
    if (first.codeUnits.first > 0xFF) return first;
  }
  final baseCategory =
      category.contains(' → ') ? category.split(' → ').first : category;
  final cat = notifier.getCategoryById(baseCategory);
  return cat?.emoji ?? '\u{1F4DD}';
}
