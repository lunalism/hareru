import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/transfer_account_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/screens/home/widgets/add_transaction/account_chip_section.dart';

class TransferTab extends ConsumerWidget {
  const TransferTab({
    super.key,
    required this.fromAccount,
    required this.toAccount,
    required this.onFromSelect,
    required this.onToSelect,
    required this.onAccountDeleted,
    required this.isDark,
  });

  final String? fromAccount;
  final String? toAccount;
  final void Function(String) onFromSelect;
  final void Function(String) onToSelect;
  final void Function(String) onAccountDeleted;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final accounts = ref.watch(transferAccountProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // From account
        Text(
          l10n.transferFrom,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        AccountChipSection(
          accounts: accounts,
          selectedId: fromAccount,
          disabledId: toAccount,
          onSelect: onFromSelect,
          onAccountDeleted: onAccountDeleted,
          isDark: isDark,
        ),

        // Arrow
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Icon(
              Icons.arrow_downward_rounded,
              size: 16,
              color: HareruColors.lightTextSecondary,
            ),
          ),
        ),

        // To account
        Text(
          l10n.transferTo,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextSecondary
                : HareruColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        AccountChipSection(
          accounts: accounts,
          selectedId: toAccount,
          disabledId: fromAccount,
          onSelect: onToSelect,
          onAccountDeleted: onAccountDeleted,
          isDark: isDark,
        ),
      ],
    );
  }
}
