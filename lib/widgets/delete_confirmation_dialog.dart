import 'package:flutter/material.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/l10n/app_localizations.dart';

Future<bool> showDeleteConfirmation({
  required BuildContext context,
  required AppLocalizations l10n,
  required bool isDark,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor:
          isDark ? HareruColors.darkCard : HareruColors.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        l10n.deleteConfirm,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: isDark
              ? HareruColors.darkTextPrimary
              : HareruColors.lightTextPrimary,
        ),
      ),
      content: Text(
        l10n.deleteConfirmSub,
        style: TextStyle(
          fontSize: 14,
          color: isDark
              ? HareruColors.darkTextSecondary
              : HareruColors.lightTextSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: HareruColors.lightTextSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(
            l10n.deleteRecord,
            style: const TextStyle(
              color: HareruColors.expense,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
