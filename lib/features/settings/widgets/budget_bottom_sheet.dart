import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/typography.dart';

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
              color: AppColors.nightLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '월 예산 설정',
            style: AppTypography.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              prefixText: '¥ ',
              prefixStyle: AppTypography.body.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.skyBlue, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: AppTypography.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
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
                selectedColor: AppColors.skyBlueLight,
                backgroundColor: Colors.white,
                side: BorderSide(
                  color:
                      isSelected ? AppColors.skyBlue : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: AppTypography.body.copyWith(
                  color: isSelected ? AppColors.skyBlue : AppColors.night,
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
                backgroundColor: AppColors.skyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '저장',
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
