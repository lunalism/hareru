import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;
import 'package:hareru/models/transaction.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key, required this.onSave});

  final void Function(Transaction transaction) onSave;

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  TransactionType _selectedType = TransactionType.expense;
  String _amount = '0';
  String? _selectedCategory;
  String _memo = '';

  static const _typeColors = {
    TransactionType.expense: Color(0xFFEF4444),
    TransactionType.transfer: Color(0xFF3B82F6),
    TransactionType.savings: Color(0xFF10B981),
    TransactionType.income: Color(0xFFF59E0B),
  };

  static const _saveGradients = {
    TransactionType.expense: [Color(0xFFEF4444), Color(0xFFDC2626)],
    TransactionType.transfer: [Color(0xFF3B82F6), Color(0xFF2563EB)],
    TransactionType.savings: [Color(0xFF10B981), Color(0xFF059669)],
    TransactionType.income: [Color(0xFFF59E0B), Color(0xFFD97706)],
  };

  String _typeToString(TransactionType type) {
    return switch (type) {
      TransactionType.expense => 'expense',
      TransactionType.transfer => 'transfer',
      TransactionType.savings => 'savings',
      TransactionType.income => 'income',
    };
  }

  String _categoryDisplayName(cat_model.Category cat, AppLocalizations l10n) {
    if (!cat.isDefault) return cat.name;
    return _resolveL10nKey(cat.name, l10n);
  }

  String _resolveL10nKey(String key, AppLocalizations l10n) {
    return switch (key) {
      'catFood' => l10n.catFood,
      'catTransport' => l10n.catTransport,
      'catDaily' => l10n.catDaily,
      'catCafe' => l10n.catCafe,
      'catHobby' => l10n.catHobby,
      'catClothing' => l10n.catClothing,
      'catMedical' => l10n.catMedical,
      'catPhone' => l10n.catPhone,
      'catHousing' => l10n.catHousing,
      'catSocial' => l10n.catSocial,
      'catEducation' => l10n.catEducation,
      'catOther' => l10n.catOther,
      'catUtility' => l10n.catUtility,
      'catBankTransfer' => l10n.catBankTransfer,
      'catCard' => l10n.catCard,
      'catEMoney' => l10n.catEMoney,
      'catTransferOther' => l10n.catTransferOther,
      'catSavings' => l10n.catSavings,
      'catInvestment' => l10n.catInvestment,
      'catGoal' => l10n.catGoal,
      'catSavingsOther' => l10n.catSavingsOther,
      'salary' => l10n.salary,
      'sideJob' => l10n.sideJob,
      'bonus' => l10n.bonus,
      'allowance' => l10n.allowance,
      'investmentReturn' => l10n.investmentReturn,
      'fleaMarket' => l10n.fleaMarket,
      'extraIncome' => l10n.extraIncome,
      'otherIncome' => l10n.otherIncome,
      _ => key,
    };
  }

  void _onDigit(String digit) {
    setState(() {
      if (_amount == '0') {
        _amount = digit;
      } else if (_amount.length < 10) {
        _amount += digit;
      }
    });
  }

  void _onDoubleZero() {
    setState(() {
      if (_amount != '0' && _amount.length < 9) {
        _amount += '00';
      }
    });
  }

  void _onDot() {
    setState(() {
      if (!_amount.contains('.') && _amount.length < 9) {
        _amount += '.';
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = '0';
      }
    });
  }

  String _formatAmount(String raw) {
    if (raw.contains('.')) {
      final parts = raw.split('.');
      final intPart = _addCommas(parts[0]);
      return '$intPart.${parts[1]}';
    }
    return _addCommas(raw);
  }

  String _addCommas(String s) {
    final result = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      result.write(s[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    return result.toString().split('').reversed.join();
  }

  bool get _canSave {
    final parsed = double.tryParse(_amount) ?? 0;
    return parsed > 0 && _selectedCategory != null;
  }

  void _save() {
    if (!_canSave) return;
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      amount: double.parse(_amount),
      category: _selectedCategory!,
      memo: _memo.isEmpty ? null : _memo,
      createdAt: DateTime.now(),
    );
    widget.onSave(transaction);
  }

  void _showQuickAddDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = _typeColors[_selectedType]!;
    final emojiController = TextEditingController();
    final nameController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? HareruColors.darkCard : HareruColors.lightCard,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            l10n.addCategory,
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
            children: [
              TextField(
                controller: emojiController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32),
                decoration: InputDecoration(
                  hintText: '\u{1F4C1}',
                  hintStyle: TextStyle(
                    fontSize: 32,
                    color: isDark
                        ? HareruColors.darkTextTertiary
                        : HareruColors.lightTextTertiary,
                  ),
                  labelText: l10n.categoryEmoji,
                  labelStyle: TextStyle(
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: nameController,
                maxLength: 10,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? HareruColors.darkTextPrimary
                      : HareruColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  labelText: l10n.categoryName,
                  labelStyle: TextStyle(
                    color: isDark
                        ? HareruColors.darkTextSecondary
                        : HareruColors.lightTextSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeColor, width: 2),
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
                final emoji = emojiController.text.trim();
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  ref.read(categoryProvider.notifier).addCategory(
                        name,
                        emoji.isEmpty ? '\u{1F4C1}' : emoji,
                        _typeToString(_selectedType),
                      );
                  Navigator.pop(dialogContext);
                  // Select the newly added category after a brief delay
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (mounted) {
                      final cats = ref
                          .read(categoryProvider.notifier)
                          .getCategoriesByType(
                              _typeToString(_selectedType));
                      if (cats.isNotEmpty) {
                        setState(
                            () => _selectedCategory = cats.last.id);
                      }
                    }
                  });
                }
              },
              child: Text(
                l10n.save,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = isDark ? HareruColors.darkBg : HareruColors.lightBg;
    final cardColor = isDark ? HareruColors.darkCard : HareruColors.lightCard;
    final textPrimary =
        isDark ? HareruColors.darkTextPrimary : HareruColors.lightTextPrimary;
    final textSecondary = isDark
        ? HareruColors.darkTextSecondary
        : HareruColors.lightTextSecondary;
    final activeColor = _typeColors[_selectedType]!;

    ref.watch(categoryProvider);
    final categories = ref
        .read(categoryProvider.notifier)
        .getCategoriesByType(_typeToString(_selectedType));

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // === Fixed top: drag handle + type tabs ===
          const SizedBox(height: 10),
          // Drag handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          // Type tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildTypeTabs(l10n, isDark, cardColor),
          ),
          const SizedBox(height: 14),

          // === Scrollable middle: amount + categories + memo ===
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Amount display
                  _buildAmountDisplay(activeColor, isDark),
                  const SizedBox(height: 14),

                  // Category grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildCategoryGrid(
                        categories, l10n, isDark, cardColor, textSecondary, activeColor),
                  ),
                  const SizedBox(height: 12),

                  // Memo field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildMemoField(l10n, isDark, cardColor, textPrimary),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // === Fixed bottom: numpad ===
          _buildNumpad(isDark, cardColor, textPrimary, activeColor, l10n),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildTypeTabs(AppLocalizations l10n, bool isDark, Color cardColor) {
    final inactiveColor = isDark
        ? HareruColors.darkTextTertiary
        : HareruColors.lightTextTertiary;

    final types = [
      (TransactionType.expense, l10n.expense),
      (TransactionType.transfer, l10n.transfer),
      (TransactionType.savings, l10n.savings),
      (TransactionType.income, l10n.income),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: types.map((entry) {
          final (type, label) = entry;
          final isSelected = type == _selectedType;
          final color = _typeColors[type]!;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                _selectedType = type;
                _selectedCategory = null;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? HareruColors.darkBg : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected ? color : inactiveColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? color : inactiveColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountDisplay(Color activeColor, bool isDark) {
    final isZero = _amount == '0';
    final displayAmount = isZero ? '0' : _formatAmount(_amount);
    final amountFontSize = displayAmount.length >= 8 ? 36.0 : 44.0;
    final amountColor = isZero
        ? const Color(0xFF94A3B8)
        : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A));
    final yenColor = isZero ? const Color(0xFF94A3B8) : activeColor;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '\u00a5',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: yenColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              displayAmount,
              style: TextStyle(
                fontSize: amountFontSize,
                fontWeight: FontWeight.w700,
                color: amountColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: activeColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(
    List<cat_model.Category> categories,
    AppLocalizations l10n,
    bool isDark,
    Color cardColor,
    Color textSecondary,
    Color activeColor,
  ) {
    // +1 for the add button
    final itemCount = categories.length + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.15,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Last item is the add button
        if (index == categories.length) {
          return GestureDetector(
            onTap: () => _showQuickAddDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? HareruColors.darkDivider
                      : HareruColors.lightDivider,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 24,
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.add,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final cat = categories[index];
        final isSelected = _selectedCategory == cat.id;
        final displayName = _categoryDisplayName(cat, l10n);

        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor.withValues(alpha: 0.12)
                  : cardColor,
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? Border.all(color: activeColor, width: 1.5)
                  : Border.all(
                      color: isDark
                          ? HareruColors.darkDivider
                          : HareruColors.lightDivider,
                      width: 1,
                    ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? activeColor : textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMemoField(AppLocalizations l10n, bool isDark, Color cardColor,
      Color textPrimary) {
    final textTertiary = isDark
        ? HareruColors.darkTextTertiary
        : HareruColors.lightTextTertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? HareruColors.darkDivider : HareruColors.lightDivider,
        ),
      ),
      child: Row(
        children: [
          Text('\u{1F4DD}', style: TextStyle(fontSize: 16, color: textTertiary)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              onChanged: (v) => _memo = v,
              style: TextStyle(fontSize: 13, color: textPrimary),
              decoration: InputDecoration(
                hintText: l10n.memoPlaceholder,
                hintStyle: TextStyle(fontSize: 13, color: textTertiary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad(bool isDark, Color cardColor, Color textPrimary,
      Color activeColor, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Row 1: 7 8 9 backspace
          _numpadRow(['7', '8', '9', 'backspace'], isDark, cardColor,
              textPrimary, activeColor, l10n),
          const SizedBox(height: 6),
          // Row 2: 4 5 6 00
          _numpadRow(['4', '5', '6', '00'], isDark, cardColor, textPrimary,
              activeColor, l10n),
          const SizedBox(height: 6),
          // Row 3: 1 2 3 .
          _numpadRow(['1', '2', '3', '.'], isDark, cardColor, textPrimary,
              activeColor, l10n),
          const SizedBox(height: 6),
          // Row 4: [Save (2 cols)] [0 (1 col)]
          _buildLastRow(isDark, cardColor, textPrimary, activeColor, l10n),
        ],
      ),
    );
  }

  Widget _numpadRow(List<String> keys, bool isDark, Color cardColor,
      Color textPrimary, Color activeColor, AppLocalizations l10n) {
    return Row(
      children: keys.asMap().entries.map((entry) {
        final i = entry.key;
        final key = entry.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
            child: key == 'backspace'
                ? _buildKeyButton(
                    child: Icon(
                      Icons.backspace_outlined,
                      size: 20,
                      color: textPrimary,
                    ),
                    onTap: _onBackspace,
                    isDark: isDark,
                    cardColor: cardColor,
                  )
                : _buildKeyButton(
                    child: Text(
                      key,
                      style: TextStyle(
                        fontSize: key == '00' || key == '.' ? 18 : 22,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                    ),
                    onTap: () {
                      if (key == '00') {
                        _onDoubleZero();
                      } else if (key == '.') {
                        _onDot();
                      } else {
                        _onDigit(key);
                      }
                    },
                    isDark: isDark,
                    cardColor: cardColor,
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLastRow(bool isDark, Color cardColor, Color textPrimary,
      Color activeColor, AppLocalizations l10n) {
    return Row(
      children: [
        // Save button (2 cols)
        Expanded(
          flex: 2,
          child: _buildSaveButton(activeColor, l10n, isDark),
        ),
        const SizedBox(width: 8),
        // 0 button (1 col)
        Expanded(
          child: _buildKeyButton(
            child: Text(
              '0',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            onTap: () => _onDigit('0'),
            isDark: isDark,
            cardColor: cardColor,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyButton({
    required Widget child,
    required VoidCallback onTap,
    required bool isDark,
    required Color cardColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  Widget _buildSaveButton(Color activeColor, AppLocalizations l10n, bool isDark) {
    final gradientColors = _saveGradients[_selectedType]!;

    return GestureDetector(
      onTap: _canSave ? _save : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 46,
        decoration: BoxDecoration(
          gradient: _canSave
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: gradientColors,
                )
              : null,
          color: _canSave ? null : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          l10n.saveRecord,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _canSave ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
