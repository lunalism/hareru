import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../shared/models/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import '../../../shared/services/sync_service.dart';
import '../../home/providers/home_provider.dart';

class InputFormState {
  const InputFormState({
    this.transactionType = TransactionType.expense,
    this.amountString = '',
    this.selectedCategoryEmoji,
    this.selectedCategoryKey,
    this.date,
    this.memo = '',
    this.fromAccount,
    this.toAccount,
    this.isSaving = false,
  });

  final TransactionType transactionType;
  final String amountString;
  final String? selectedCategoryEmoji;
  final String? selectedCategoryKey;
  final DateTime? date;
  final String memo;
  final String? fromAccount;
  final String? toAccount;
  final bool isSaving;

  int get amount => int.tryParse(amountString) ?? 0;
  DateTime get effectiveDate => date ?? DateTime.now();
  bool get canSave => amount > 0 && selectedCategoryKey != null;

  String get displayAmount {
    if (amountString.isEmpty) return '0';
    final value = int.tryParse(amountString);
    if (value == null) return amountString;
    return _formatNumber(value);
  }

  static String _formatNumber(int value) {
    final str = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  InputFormState copyWith({
    TransactionType? transactionType,
    String? amountString,
    String? selectedCategoryEmoji,
    String? selectedCategoryKey,
    DateTime? date,
    String? memo,
    String? fromAccount,
    String? toAccount,
    bool? isSaving,
    bool clearCategory = false,
  }) {
    return InputFormState(
      transactionType: transactionType ?? this.transactionType,
      amountString: amountString ?? this.amountString,
      selectedCategoryEmoji: clearCategory ? null : (selectedCategoryEmoji ?? this.selectedCategoryEmoji),
      selectedCategoryKey: clearCategory ? null : (selectedCategoryKey ?? this.selectedCategoryKey),
      date: date ?? this.date,
      memo: memo ?? this.memo,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class InputNotifier extends AutoDisposeNotifier<InputFormState> {
  @override
  InputFormState build() => const InputFormState();

  void setType(TransactionType type) {
    state = state.copyWith(transactionType: type, clearCategory: true);
  }

  void appendDigit(String digit) {
    final newAmount = state.amountString + digit;
    if (newAmount.length > 10) return;
    // Prevent leading zeros
    if (state.amountString == '0' && digit == '0') return;
    if (state.amountString == '0' && digit == '00') return;
    if (state.amountString == '0' && digit != '00') {
      state = state.copyWith(amountString: digit);
      return;
    }
    state = state.copyWith(amountString: newAmount);
  }

  void backspace() {
    if (state.amountString.isEmpty) return;
    state = state.copyWith(
      amountString: state.amountString.substring(0, state.amountString.length - 1),
    );
  }

  void clearAmount() {
    state = state.copyWith(amountString: '');
  }

  void setCategory(String emoji, String key) {
    state = state.copyWith(
      selectedCategoryEmoji: emoji,
      selectedCategoryKey: key,
    );
  }

  void setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void setMemo(String memo) {
    state = state.copyWith(memo: memo);
  }

  Future<bool> save() async {
    if (!state.canSave) return false;
    state = state.copyWith(isSaving: true);

    final transaction = Transaction(
      id: const Uuid().v4(),
      amount: state.amount,
      transactionType: state.transactionType,
      categoryEmoji: state.selectedCategoryEmoji ?? '📎',
      categoryKey: state.selectedCategoryKey ?? 'other',
      note: state.memo,
      date: state.effectiveDate,
      fromAccount: state.fromAccount,
      toAccount: state.toAccount,
      isExcludedFromBudget: state.transactionType == TransactionType.transfer,
      createdAt: DateTime.now(),
    );

    final syncService = ref.read(syncServiceProvider);
    await syncService.add(transaction);
    ref.invalidate(allTransactionsProvider);
    state = state.copyWith(isSaving: false);
    return true;
  }
}

final inputProvider =
    AutoDisposeNotifierProvider<InputNotifier, InputFormState>(InputNotifier.new);
