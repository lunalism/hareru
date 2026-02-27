import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/transaction.dart';

class TypeBadge extends StatelessWidget {
  const TypeBadge({super.key, required this.type});

  final TransactionType type;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (label, textColor, bgColor) = switch (type) {
      TransactionType.expense => (
        l10n.expense,
        HareruColors.expense,
        HareruColors.expenseBgLight,
      ),
      TransactionType.transfer => (
        l10n.transfer,
        HareruColors.transferBlue,
        HareruColors.transferBgLight,
      ),
      TransactionType.savings => (
        l10n.savings,
        HareruColors.savings,
        HareruColors.savingsBgLight,
      ),
      TransactionType.income => (
        l10n.income,
        HareruColors.income,
        HareruColors.incomeBgLight,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
