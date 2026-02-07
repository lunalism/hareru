import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import '../providers/input_provider.dart';

class NumberKeypad extends ConsumerWidget {
  const NumberKeypad({super.key, required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final canSave = ref.watch(inputProvider.select((s) => s.canSave));
    final isSaving = ref.watch(inputProvider.select((s) => s.isSaving));

    return Column(
      children: [
        // Keypad grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildRow(context, ref, ['1', '2', '3']),
              _buildRow(context, ref, ['4', '5', '6']),
              _buildRow(context, ref, ['7', '8', '9']),
              _buildRow(context, ref, ['00', '0', 'backspace']),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Save button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: canSave && !isSaving ? onSave : null,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        l10n.save,
                        style: const TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref, List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: _KeypadButton(
            label: key,
            onTap: () => _handleTap(ref, key),
          ),
        );
      }).toList(),
    );
  }

  void _handleTap(WidgetRef ref, String key) {
    HapticFeedback.lightImpact();
    if (key == 'backspace') {
      ref.read(inputProvider.notifier).backspace();
    } else {
      ref.read(inputProvider.notifier).appendDigit(key);
    }
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBackspace = label == 'backspace';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: isBackspace ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 52,
          child: Center(
            child: isBackspace
                ? Icon(
                    Icons.backspace_outlined,
                    size: 22,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
