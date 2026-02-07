import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/custom_colors.dart';

class BudgetBottomSheet extends StatefulWidget {
  const BudgetBottomSheet({super.key, required this.currentBudget});

  final int currentBudget;

  @override
  State<BudgetBottomSheet> createState() => _BudgetBottomSheetState();
}

class _BudgetBottomSheetState extends State<BudgetBottomSheet> {
  late final TextEditingController _controller;
  final _formatter = NumberFormat('#,###');
  int? _selected;

  static const _presets = [100000, 150000, 200000, 300000];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.currentBudget.toString(),
    );
    if (_presets.contains(widget.currentBudget)) {
      _selected = widget.currentBudget;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final custom = theme.extension<CustomColors>()!;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: custom.nightLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.monthlyBudgetSetting,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              prefixText: '¥ ',
              prefixStyle: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            onChanged: (_) {
              setState(() => _selected = null);
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: _presets.map((p) {
              final isSelected = _selected == p;
              return ChoiceChip(
                label: Text('¥${_formatter.format(p)}'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selected = selected ? p : null;
                    if (selected) _controller.text = p.toString();
                  });
                },
                selectedColor: custom.skyBlueLight,
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 14,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () {
                final value = int.tryParse(_controller.text);
                if (value != null && value > 0) {
                  Navigator.pop(context, value);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.save,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
