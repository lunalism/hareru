import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/core/constants/colors.dart';
import 'package:hareru/core/theme/hareru_theme.dart';
import 'package:hareru/core/utils/number_formatter.dart';
import 'package:hareru/core/providers/category_provider.dart';
import 'package:hareru/core/providers/transfer_account_provider.dart';
import 'package:hareru/l10n/app_localizations.dart';
import 'package:hareru/models/category.dart' as cat_model;
import 'package:hareru/models/transaction.dart';
import 'package:hareru/screens/home/widgets/add_transaction/category_grid.dart';
import 'package:hareru/screens/home/widgets/add_transaction/expense_tab.dart';
import 'package:hareru/screens/home/widgets/add_transaction/income_tab.dart';
import 'package:hareru/screens/home/widgets/add_transaction/transfer_tab.dart';

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
  String? _fromAccount;
  String? _toAccount;
  String? _depositAccount;
  String? _pendingTransferCategory;
  int _selectedPayment = 0;
  bool _isRecurring = false;

  final _memoController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  bool get _isTransfer => _selectedType == TransactionType.transfer;
  bool get _isIncome => _selectedType == TransactionType.income;
  bool get _isEditing => widget.editTransaction != null;

  double get _parsedAmount {
    final clean = _amountController.text.replaceAll(',', '');
    return double.tryParse(clean) ?? 0;
  }

  bool get _canSave {
    if (_parsedAmount <= 0) return false;
    if (_isTransfer) return _fromAccount != null && _toAccount != null;
    return _selectedCategory != null;
  }

  @override
  void initState() {
    super.initState();
    final t = widget.editTransaction;
    if (t != null) {
      _selectedType = t.type;
      final amountStr = t.amount.truncateToDouble() == t.amount
          ? t.amount.toInt().toString()
          : t.amount.toString();
      _amountController.text = formatWithCommas(amountStr);
      _selectedCategory = t.category;
      _memo = t.memo ?? '';
      _memoController.text = _memo;
      if (t.type == TransactionType.transfer) {
        _pendingTransferCategory = t.category;
      }
      if (t.type == TransactionType.income && t.category.contains(' → ')) {
        _pendingTransferCategory = t.category;
      }
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
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

  void _save() {
    if (!_canSave) return;
    final existing = widget.editTransaction;
    String category;
    if (_isTransfer) {
      final accounts = ref.read(transferAccountProvider);
      final from = accounts.firstWhere((a) => a.id == _fromAccount);
      final to = accounts.firstWhere((a) => a.id == _toAccount);
      category = '${from.emoji} ${from.nickname} → ${to.emoji} ${to.nickname}';
    } else if (_isIncome && _depositAccount != null) {
      final accounts = ref.read(transferAccountProvider);
      final deposit = accounts.firstWhere((a) => a.id == _depositAccount);
      category =
          '$_selectedCategory → ${deposit.emoji} ${deposit.nickname}';
    } else {
      category = _selectedCategory!;
    }
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

  void _resolvePendingEdits() {
    if (_pendingTransferCategory == null) return;
    final accounts = ref.read(transferAccountProvider);
    if (accounts.isEmpty) return;

    if (_isTransfer && _pendingTransferCategory!.contains(' → ')) {
      final parts = _pendingTransferCategory!.split(' → ');
      for (final a in accounts) {
        final label = '${a.emoji} ${a.nickname}';
        if (label == parts[0] && _fromAccount == null) _fromAccount = a.id;
        if (label == parts[1] && _toAccount == null) _toAccount = a.id;
        if (a.nickname == parts[0] && _fromAccount == null) _fromAccount = a.id;
        if (a.nickname == parts[1] && _toAccount == null) _toAccount = a.id;
      }
      _pendingTransferCategory = null;
    } else if (_isIncome && _pendingTransferCategory!.contains(' → ')) {
      final parts = _pendingTransferCategory!.split(' → ');
      _selectedCategory = parts[0];
      for (final a in accounts) {
        final label = '${a.emoji} ${a.nickname}';
        if (label == parts[1] && _depositAccount == null) {
          _depositAccount = a.id;
        }
      }
      _pendingTransferCategory = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final c = context.colors;
    final l10n = AppLocalizations.of(context)!;
    final bgColor = c.background;
    final textPrimary = c.textPrimary;

    ref.watch(categoryProvider);
    final categories = _isTransfer
        ? <cat_model.Category>[]
        : ref
            .read(categoryProvider.notifier)
            .getCategoriesByType(_typeToString(_selectedType));

    _resolvePendingEdits();

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
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // === Segment control ===
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
                      _buildAmountInput(isDark, l10n),
                      const SizedBox(height: 24),

                      // Tab content
                      if (_isTransfer)
                        TransferTab(
                          fromAccount: _fromAccount,
                          toAccount: _toAccount,
                          onFromSelect: (id) =>
                              setState(() => _fromAccount = id),
                          onToSelect: (id) =>
                              setState(() => _toAccount = id),
                          onAccountDeleted: (id) => setState(() {
                            if (_fromAccount == id) _fromAccount = null;
                            if (_toAccount == id) _toAccount = null;
                          }),
                          isDark: isDark,
                        )
                      else if (_isIncome)
                        IncomeTab(
                          categories: categories,
                          selectedCategory: _selectedCategory,
                          depositAccount: _depositAccount,
                          onCategorySelect: (id) =>
                              setState(() => _selectedCategory = id),
                          onQuickAdd: () => showQuickAddCategoryDialog(
                            context: context,
                            ref: ref,
                            selectedType: _selectedType,
                            isDark: isDark,
                            onCategoryAdded: (id) {
                              if (mounted) setState(() => _selectedCategory = id);
                            },
                          ),
                          onDepositSelect: (id) => setState(() {
                            _depositAccount =
                                _depositAccount == id ? null : id;
                          }),
                          isDark: isDark,
                        )
                      else
                        ExpenseTab(
                          categories: categories,
                          selectedCategory: _selectedCategory,
                          selectedPayment: _selectedPayment,
                          onCategorySelect: (id) =>
                              setState(() => _selectedCategory = id),
                          onQuickAdd: () => showQuickAddCategoryDialog(
                            context: context,
                            ref: ref,
                            selectedType: _selectedType,
                            isDark: isDark,
                            onCategoryAdded: (id) {
                              if (mounted) setState(() => _selectedCategory = id);
                            },
                          ),
                          onPaymentSelect: (i) =>
                              setState(() => _selectedPayment = i),
                          isDark: isDark,
                        ),

                      const SizedBox(height: 24),
                      _buildMemoField(l10n, isDark),
                      const SizedBox(height: 16),
                      _buildRecurringToggle(l10n, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // === Save button ===
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
        color: isDark ? HareruColors.darkCard : HareruColors.headerCardLight,
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
                            : HareruColors.lightTextSecondary),
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
                      ? HareruColors.primaryStart
                      : HareruColors.lightTextTertiary,
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
                      color: HareruColors.lightTextTertiary,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _CommaFormatter(),
                    LengthLimitingTextInputFormatter(14),
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
              style: TextStyle(
                fontSize: 13,
                color: HareruColors.lightTextTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMemoField(AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? HareruColors.darkCard : HareruColors.lightBg,
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
            activeTrackColor: HareruColors.primaryStart,
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
              ? HareruColors.primaryStart
              : (isDark ? HareruColors.darkDivider : HareruColors.lightDivider),
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
                    ? HareruColors.darkTextTertiary
                    : HareruColors.lightTextTertiary),
          ),
        ),
      ),
    );
  }
}

class _CommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final clean = newValue.text.replaceAll(',', '');
    if (clean.isEmpty) return newValue.copyWith(text: '');

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
