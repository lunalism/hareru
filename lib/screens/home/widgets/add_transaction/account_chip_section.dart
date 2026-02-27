import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/transfer_account_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';

class AccountChipSection extends ConsumerWidget {
  const AccountChipSection({
    super.key,
    required this.accounts,
    required this.selectedId,
    required this.disabledId,
    required this.onSelect,
    required this.isDark,
    this.onAccountDeleted,
  });

  final List<UserAccount> accounts;
  final String? selectedId;
  final String? disabledId;
  final void Function(String) onSelect;
  final bool isDark;
  final void Function(String accountId)? onAccountDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (accounts.isEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Text(
            l10n.addAccountPrompt,
            style: TextStyle(fontSize: 14, color: HareruColors.lightTextSecondary),
          ),
          const SizedBox(width: 4),
          _AddChip(isDark: isDark),
        ],
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...accounts.map((account) {
          final isSelected = selectedId == account.id;
          final isDisabled = disabledId == account.id;

          return GestureDetector(
            onTap: isDisabled ? null : () => onSelect(account.id),
            onLongPress: () =>
                _showDeleteAccountDialog(
                  context, ref, account, isDark,
                  onDeleted: onAccountDeleted,
                ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.only(left: 6, right: 14, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: isDisabled
                    ? (isDark
                        ? HareruColors.darkCard
                        : HareruColors.lightBg)
                    : isSelected
                        ? HareruColors.lightTextPrimary
                        : (isDark ? HareruColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: (isSelected || isDisabled)
                    ? null
                    : Border.all(
                        color: isDark
                            ? HareruColors.darkDivider
                            : HareruColors.lightDivider,
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.2)
                          : (isDark
                              ? HareruColors.darkBg
                              : HareruColors.lightBg),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      account.emoji,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    account.nickname,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isDisabled
                          ? HareruColors.lightTextTertiary
                          : isSelected
                              ? Colors.white
                              : (isDark
                                  ? HareruColors.darkTextSecondary
                                  : HareruColors.lightTextPrimary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        _AddChip(isDark: isDark),
      ],
    );
  }
}

class _AddChip extends ConsumerWidget {
  const _AddChip({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => showAddAccountDialog(context, ref, l10n, isDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? HareruColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? HareruColors.darkDivider
                : HareruColors.lightDivider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 14,
              color: isDark
                  ? HareruColors.darkTextTertiary
                  : HareruColors.lightTextTertiary,
            ),
            const SizedBox(width: 4),
            Text(
              l10n.add,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAddAccountDialog(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  bool isDark,
) {
  final nameController = TextEditingController();
  var selectedEmoji = '🏦';
  const activeColor = HareruColors.primaryStart;
  const emojiOptions = ['🏦', '💰', '📈', '💳', '🐷', '💵'];

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor:
                isDark ? HareruColors.darkCard : HareruColors.lightCard,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: Text(
              l10n.addAccountTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.addAccountStep1,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: emojiOptions.map((emoji) {
                    final isSelected = selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () =>
                          setDialogState(() => selectedEmoji = emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? activeColor
                              : (isDark
                                  ? HareruColors.darkBg
                                  : HareruColors.lightBg),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.addAccountStep2,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  maxLength: 20,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.addAccountHint,
                    hintStyle: TextStyle(
                      color: isDark
                          ? HareruColors.darkTextTertiary
                          : HareruColors.lightTextTertiary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: activeColor, width: 2),
                    ),
                  ),
                ),
              ],
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
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    ref
                        .read(transferAccountProvider.notifier)
                        .addAccount(name, selectedEmoji);
                    Navigator.pop(dialogContext);
                  }
                },
                child: Text(
                  l10n.add,
                  style: const TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void _showDeleteAccountDialog(
  BuildContext context,
  WidgetRef ref,
  UserAccount account,
  bool isDark, {
  void Function(String)? onDeleted,
}) {
  final l10n = AppLocalizations.of(context)!;
  final label = '${account.emoji} ${account.nickname}';

  showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor:
            isDark ? HareruColors.darkCard : HareruColors.lightCard,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.deleteAccountConfirm(label),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark
                ? HareruColors.darkTextPrimary
                : HareruColors.lightTextPrimary,
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
              ref
                  .read(transferAccountProvider.notifier)
                  .removeAccount(account.id);
              onDeleted?.call(account.id);
              Navigator.pop(dialogContext);
            },
            child: Text(
              l10n.deleteRecord,
              style: TextStyle(
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
