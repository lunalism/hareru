import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'providers/input_provider.dart';
import 'widgets/transaction_type_selector.dart';
import 'widgets/amount_display.dart';
import 'widgets/category_grid.dart';
import 'widgets/date_memo_row.dart';
import 'widgets/number_keypad.dart';

class InputScreen extends ConsumerWidget {
  const InputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.input,
          style: const TextStyle(
            fontFamily: 'PretendardJP',
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Top section: type selector + amount + categories + date/memo
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const TransactionTypeSelector(),
                  const AmountDisplay(),
                  const SizedBox(height: 4),
                  const CategoryGrid(),
                  const SizedBox(height: 12),
                  const DateMemoRow(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          // Bottom: number keypad + save button
          NumberKeypad(
            onSave: () => _handleSave(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await ref.read(inputProvider.notifier).save();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.savedSuccess,
            style: const TextStyle(fontFamily: 'PretendardJP'),
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      context.pop();
    }
  }
}
