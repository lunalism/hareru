import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/utils/category_l10n.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;
import 'package:hareru/models/transaction.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({
    super.key,
    required this.onSave,
    this.editTransaction,
  });

  final void Function(Transaction transaction) onSave;
  final Transaction? editTransaction;

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense;
  String? _selectedCategory;
  String _memo = '';
  String _fromAccount = '';
  String _toAccount = '';
  int _selectedPayment = 0; // 0=credit, 1=debit, 2=cash (UI only)
  bool _isRecurring = false; // UI only

  final _memoController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _fromAccountController = TextEditingController();
  final _toAccountController = TextEditingController();

  bool get _isTransfer => _selectedType == TransactionType.transfer;

  bool get _isEditing => widget.editTransaction != null;

  @override
  void initState() {
    super.initState();
    final t = widget.editTransaction;
    if (t != null) {
      _selectedType = t.type;
      final amountStr = t.amount.truncateToDouble() == t.amount
          ? t.amount.toInt().toString()
          : t.amount.toString();
      _amountController.text = _formatWithCommas(amountStr);
      _selectedCategory = t.category;
      _memo = t.memo ?? '';
      _memoController.text = _memo;
      if (t.type == TransactionType.transfer && t.category.contains(' → ')) {
        final parts = t.category.split(' → ');
        _fromAccount = parts[0];
        _toAccount = parts[1];
        _fromAccountController.text = _fromAccount;
        _toAccountController.text = _toAccount;
      } else if (t.type == TransactionType.transfer) {
        _toAccount = t.category;
        _toAccountController.text = t.category;
      }
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    _fromAccountController.dispose();
    _toAccountController.dispose();
    super.dispose();
  }

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
    return resolveL10nKey(cat.name, l10n);
  }

  String _formatWithCommas(String raw) {
    // Remove existing commas
    final clean = raw.replaceAll(',', '');
    if (clean.isEmpty) return '';
    if (clean.contains('.')) {
      final parts = clean.split('.');
      return '${_addCommas(parts[0])}.${parts[1]}';
    }
    return _addCommas(clean);
  }

  String _addCommas(String s) {
    if (s.isEmpty) return '';
    final result = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      result.write(s[i]);
      count++;
      if (count % 3 == 0 && i > 0) result.write(',');
    }
    return result.toString().split('').reversed.join();
  }

  double get _parsedAmount {
    final clean = _amountController.text.replaceAll(',', '');
    return double.tryParse(clean) ?? 0;
  }

  bool get _canSave {
    if (_parsedAmount <= 0) return false;
    if (_isTransfer) {
      return _fromAccount.trim().isNotEmpty && _toAccount.trim().isNotEmpty;
    }
    return _selectedCategory != null;
  }

  void _save() {
    if (!_canSave) return;
    final existing = widget.editTransaction;
    final category = _isTransfer
        ? '${_fromAccount.trim()} → ${_toAccount.trim()}'
        : _selectedCategory!;
    final transaction = Transaction(
      id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      amount: _parsedAmount,
      category: category,
      memo: _memo.isEmpty ? null : _memo,
      createdAt: existing?.createdAt ?? DateTime.now(),
    );
    widget.onSave(transaction);
  }

  void _showQuickAddDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = const Color(0xFFE8453C);
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
    final textPrimary =
        isDark ? HareruColors.darkTextPrimary : HareruColors.lightTextPrimary;

    ref.watch(categoryProvider);
    final categories = _isTransfer
        ? <cat_model.Category>[]
        : ref
            .read(categoryProvider.notifier)
            .getCategoriesByType(_typeToString(_selectedType));

    final headerTitle = switch (_selectedType) {
      TransactionType.transfer => _isEditing ? l10n.editTransfer : l10n.addTransfer,
      TransactionType.income => _isEditing ? l10n.editIncome : l10n.addIncome,
      _ => _isEditing ? l10n.editExpense : l10n.addExpense,
    };

    return Scaffold(
      backgroundColor: bgColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              // === Header ===
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      headerTitle,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        size: 24,
                        color: isDark
                            ? HareruColors.darkTextSecondary
                            : HareruColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // === 2-tab segment ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildSegmentControl(l10n, isDark),
              ),
              const SizedBox(height: 20),

              // === Scrollable content ===
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Amount input
                      _buildAmountInput(isDark, l10n),
                      const SizedBox(height: 24),

                      if (_isTransfer) ...[
                        // Transfer destination field
                        _buildTransferDestField(l10n, isDark),
                        const SizedBox(height: 24),
                      ] else ...[
                        // Category section
                        Text(
                          l10n.category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? HareruColors.darkTextSecondary
                                : HareruColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildCategoryGrid(categories, l10n, isDark),
                        const SizedBox(height: 24),

                        // Payment method chips
                        Text(
                          l10n.paymentMethod,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? HareruColors.darkTextSecondary
                                : HareruColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildPaymentChips(l10n, isDark),
                        const SizedBox(height: 24),
                      ],

                      // Memo field
                      _buildMemoField(l10n, isDark),
                      const SizedBox(height: 16),

                      // Monthly recurring toggle
                      _buildRecurringToggle(l10n, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // === Save button (bottom-fixed) ===
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: _buildSaveButton(l10n, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentControl(AppLocalizations l10n, bool isDark) {
    final types = [
      (TransactionType.expense, l10n.expense),
      (TransactionType.income, l10n.income),
      (TransactionType.transfer, l10n.transfer),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : const Color(0xFFEDE8E3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: types.map((entry) {
          final (type, label) = entry;
          final isSelected = type == _selectedType;

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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? (isDark
                            ? HareruColors.darkTextPrimary
                            : HareruColors.lightTextPrimary)
                        : (isDark
                            ? HareruColors.darkTextTertiary
                            : const Color(0xFF8A8A8A)),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAmountInput(bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '\u00a5',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: _parsedAmount > 0
                      ? const Color(0xFFE8453C)
                      : const Color(0xFFBFBFBF),
                ),
              ),
              const SizedBox(width: 4),
              IntrinsicWidth(
                child: TextField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  autofocus: !_isEditing,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFBFBFBF),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CommaFormatter(),
                    LengthLimitingTextInputFormatter(14), // 10 digits + 3 commas
                  ],
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (_parsedAmount == 0)
            Text(
              l10n.amountHint,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFBFBFBF),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(
    List<cat_model.Category> categories,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final itemCount = categories.length + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.05,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return GestureDetector(
            onTap: () => _showQuickAddDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? HareruColors.darkCard
                    : const Color(0xFFF5F0EB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? HareruColors.darkDivider
                      : HareruColors.lightDivider,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_rounded,
                    size: 24,
                    color: isDark
                        ? HareruColors.darkTextTertiary
                        : HareruColors.lightTextTertiary,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.add,
                    style: TextStyle(
                      fontSize: 11,
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

        final cat = categories[index];
        final isSelected = _selectedCategory == cat.id;
        final displayName = _categoryDisplayName(cat, l10n);

        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE8453C)
                  : (isDark
                      ? HareruColors.darkCard
                      : const Color(0xFFF5F0EB)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 3),
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? HareruColors.darkTextPrimary
                            : HareruColors.lightTextPrimary),
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

  Widget _buildPaymentChips(AppLocalizations l10n, bool isDark) {
    final labels = [l10n.creditCard, l10n.debitCard, l10n.cash];

    return Row(
      children: List.generate(labels.length, (i) {
        final isSelected = _selectedPayment == i;
        return Padding(
          padding: EdgeInsets.only(right: i < labels.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => setState(() => _selectedPayment = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? HareruColors.darkTextPrimary
                        : HareruColors.lightTextPrimary)
                    : (isDark ? HareruColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isDark
                            ? HareruColors.darkDivider
                            : HareruColors.lightDivider,
                      ),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? (isDark
                          ? HareruColors.darkBg
                          : Colors.white)
                      : (isDark
                          ? HareruColors.darkTextSecondary
                          : HareruColors.lightTextSecondary),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTransferDestField(AppLocalizations l10n, bool isDark) {
    final borderColor = isDark
        ? HareruColors.darkDivider
        : const Color(0xFFE5E0DB);
    final fieldBg = isDark ? HareruColors.darkCard : Colors.white;

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
                : const Color(0xFF8A8A8A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: _fromAccountController,
            onChanged: (v) => setState(() => _fromAccount = v),
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: l10n.transferFromPlaceholder,
              hintStyle: TextStyle(
                fontSize: 14,
                color: isDark
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Arrow
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Icon(
              Icons.arrow_downward_rounded,
              size: 20,
              color: Color(0xFF8A8A8A),
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
                : const Color(0xFF8A8A8A),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: _toAccountController,
            onChanged: (v) => setState(() => _toAccount = v),
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? HareruColors.darkTextPrimary
                  : HareruColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: l10n.transferToPlaceholder,
              hintStyle: TextStyle(
                fontSize: 14,
                color: isDark
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoField(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : const Color(0xFFF5F0EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('\u{270F}\u{FE0F}', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _memoController,
              onChanged: (v) => _memo = v,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: l10n.memoPlaceholder,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? HareruColors.darkTextTertiary
                      : HareruColors.lightTextTertiary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringToggle(AppLocalizations l10n, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.repeat_rounded,
              size: 20,
              color: isDark
                  ? HareruColors.darkTextSecondary
                  : HareruColors.lightTextSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.monthlyRecurring,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? HareruColors.darkTextPrimary
                    : HareruColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 28,
          child: Switch.adaptive(
            value: _isRecurring,
            onChanged: (v) => setState(() => _isRecurring = v),
            activeColor: const Color(0xFFE8453C),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(AppLocalizations l10n, bool isDark) {
    return GestureDetector(
      onTap: _canSave ? _save : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: _canSave
              ? const Color(0xFFE8453C)
              : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE5E0DB)),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          _isEditing ? l10n.updateRecord : l10n.saveRecord,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _canSave
                ? Colors.white
                : (isDark
                    ? const Color(0xFF5A5A5A)
                    : const Color(0xFFBFBFBF)),
          ),
        ),
      ),
    );
  }
}

/// TextInputFormatter that adds commas for thousands grouping.
class _CommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Strip commas for pure digits
    final clean = newValue.text.replaceAll(',', '');
    if (clean.isEmpty) return newValue.copyWith(text: '');

    // Format with commas
    final buf = StringBuffer();
    for (var i = 0; i < clean.length; i++) {
      if (i > 0 && (clean.length - i) % 3 == 0) buf.write(',');
      buf.write(clean[i]);
    }
    final formatted = buf.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
