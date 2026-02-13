import 'package:flutter/material.dart';
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
        const Color(0xFFEF4444),
        const Color(0xFFFEF2F2),
      ),
      TransactionType.transfer => (
        l10n.transfer,
        const Color(0xFF3B82F6),
        const Color(0xFFEFF6FF),
      ),
      TransactionType.savings => (
        l10n.savings,
        const Color(0xFF10B981),
        const Color(0xFFECFDF5),
      ),
      TransactionType.income => (
        l10n.income,
        const Color(0xFFF59E0B),
        const Color(0xFFFEF3C7),
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
