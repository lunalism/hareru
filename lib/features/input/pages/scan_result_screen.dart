import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hareru/l10n/generated/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/models/default_categories.dart';
import '../../../shared/models/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import '../../../shared/services/sync_service.dart';
import '../../home/providers/home_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../widgets/category_chip.dart';

class ScanResultScreen extends ConsumerStatefulWidget {
  const ScanResultScreen({
    super.key,
    required this.imagePath,
    this.amount,
    this.storeName,
    this.date,
    required this.rawText,
    required this.confidence,
  });

  final String imagePath;
  final int? amount;
  final String? storeName;
  final String? date;
  final String rawText;
  final double confidence;

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends ConsumerState<ScanResultScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _storeNameController;
  late final TextEditingController _memoController;
  late DateTime _selectedDate;
  String? _selectedCategoryEmoji;
  String? _selectedCategoryKey;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.amount?.toString() ?? '',
    );
    _storeNameController = TextEditingController(
      text: widget.storeName ?? '',
    );
    _memoController = TextEditingController();

    if (widget.date != null) {
      _selectedDate = DateTime.tryParse(widget.date!) ?? DateTime.now();
    } else {
      _selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _storeNameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amountText = _amountController.text.replaceAll(',', '');
    final amount = int.tryParse(amountText);
    if (amount == null || amount <= 0 || _selectedCategoryKey == null) return;

    setState(() => _isSaving = true);

    final memo = [
      if (_storeNameController.text.isNotEmpty) _storeNameController.text,
      if (_memoController.text.isNotEmpty) _memoController.text,
    ].join(' | ');

    final transaction = Transaction(
      id: const Uuid().v4(),
      amount: amount,
      transactionType: TransactionType.expense,
      categoryEmoji: _selectedCategoryEmoji ?? '📎',
      categoryKey: _selectedCategoryKey ?? 'other',
      note: memo,
      date: _selectedDate,
      isExcludedFromBudget: false,
      createdAt: DateTime.now(),
    );

    final syncService = ref.read(syncServiceProvider);
    await syncService.add(transaction);
    ref.invalidate(allTransactionsProvider);

    if (!mounted) return;
    setState(() => _isSaving = false);

    final l10n = AppLocalizations.of(context)!;
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

    // Pop back to home (past scan screen)
    context.go('/');
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showRawText() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                l10n.rawTextTitle,
                style: const TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                child: SelectableText(
                  widget.rawText.isEmpty ? '(empty)' : widget.rawText,
                  style: const TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final amountText = _amountController.text.replaceAll(',', '');
    final amount = int.tryParse(amountText);
    final canSave = amount != null && amount > 0 && _selectedCategoryKey != null;

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
          l10n.scanResultTitle,
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Image thumbnail
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(widget.imagePath),
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount not recognized warning
                  if (widget.amount == null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 18, color: theme.colorScheme.error),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.amountNotRecognized,
                              style: TextStyle(
                                fontFamily: 'PretendardJP',
                                fontSize: 12,
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Amount field
                  _buildField(
                    label: l10n.amount,
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        prefixText: '¥ ',
                        prefixStyle: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Store name field
                  _buildField(
                    label: l10n.storeName,
                    child: TextField(
                      controller: _storeNameController,
                      style: const TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.storeName,
                        hintStyle: TextStyle(
                          fontFamily: 'PretendardJP',
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date
                  _buildField(
                    label: l10n.date,
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              '${_selectedDate.year}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontFamily: 'PretendardJP',
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Memo
                  _buildField(
                    label: l10n.memo,
                    child: TextField(
                      controller: _memoController,
                      style: const TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.addMemo,
                        hintStyle: TextStyle(
                          fontFamily: 'PretendardJP',
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category selection
                  Text(
                    l10n.selectCategory,
                    style: TextStyle(
                      fontFamily: 'PretendardJP',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryGrid(context),

                  const SizedBox(height: 16),

                  // View raw text button
                  if (widget.rawText.isNotEmpty)
                    Center(
                      child: TextButton.icon(
                        onPressed: _showRawText,
                        icon: Icon(
                          Icons.description_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        label: Text(
                          l10n.viewRawText,
                          style: TextStyle(
                            fontFamily: 'PretendardJP',
                            fontSize: 13,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Container(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(color: theme.colorScheme.outline, width: 0.5),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: canSave && !_isSaving ? _save : null,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l10n.saveThisRecord,
                            style: const TextStyle(
                              fontFamily: 'PretendardJP',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      l10n.rescan,
                      style: TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final settingsCategories = ref.watch(settingsProvider).categories;
    final categories = settingsCategories
        .where((c) => c.localeKey != 'transfer')
        .map((c) => CategoryEntry(
              emoji: c.emoji,
              localeKey: c.localeKey ?? c.name,
            ))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final displayName = cat.getDisplayName(context);
        final key = cat.localeKey;

        return CategoryChip(
          emoji: cat.emoji,
          label: displayName,
          isSelected: _selectedCategoryKey == key,
          onTap: () {
            setState(() {
              _selectedCategoryEmoji = cat.emoji;
              _selectedCategoryKey = key;
            });
          },
        );
      },
    );
  }
}
