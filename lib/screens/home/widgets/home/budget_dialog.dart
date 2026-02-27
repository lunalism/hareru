import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/core/providers/budget_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

void showHomeBudgetDialog(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final currentBudget = ref.read(budgetProvider);
  final controller = TextEditingController(
    text: currentBudget > 0 ? addCommas(currentBudget.toString()) : '',
  );

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor:
            isDark ? HareruColors.darkCard : HareruColors.lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.setBudgetTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [_BudgetCommaFormatter()],
          autofocus: true,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            prefixText: '¥ ',
            prefixStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: HareruColors.primaryStart,
            ),
            hintText: '150,000',
            hintStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? HareruColors.darkDivider
                    : HareruColors.lightDivider,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: HareruColors.primaryStart,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              final digits = controller.text.replaceAll(',', '');
              final value = int.tryParse(digits) ?? 0;
              ref.read(budgetProvider.notifier).setBudget(value);
              Navigator.pop(dialogContext);
            },
            child: Text(
              l10n.save,
              style: const TextStyle(
                color: HareruColors.primaryStart,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _BudgetCommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (int.tryParse(digits) == null) {
      return oldValue;
    }

    final buf = StringBuffer();
    var count = 0;
    for (var i = digits.length - 1; i >= 0; i--) {
      buf.write(digits[i]);
      count++;
      if (count % 3 == 0 && i > 0) buf.write(',');
    }
    final formatted = buf.toString().split('').reversed.join();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
