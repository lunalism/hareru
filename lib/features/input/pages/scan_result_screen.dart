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
import '../../../services/premium_ocr_service.dart';
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
    this.suggestedCategoryKey,
    this.suggestedCategoryEmoji,
    this.categoryConfidence = 0.0,
    this.categoryMatchReason,
  });

  final String imagePath;
  final int? amount;
  final String? storeName;
  final String? date;
  final String rawText;
  final double confidence;
  final String? suggestedCategoryKey;
  final String? suggestedCategoryEmoji;
  final double categoryConfidence;
  final String? categoryMatchReason;

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

  // Premium OCR state
  bool _isPremiumLoading = false;
  PremiumOcrResult? _premiumResult;
  bool _premiumApplied = false;

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

    // Apply suggested category if confidence is high enough
    if (widget.suggestedCategoryKey != null && widget.categoryConfidence >= 0.6) {
      _selectedCategoryKey = widget.suggestedCategoryKey;
      _selectedCategoryEmoji = widget.suggestedCategoryEmoji;
    }

    // Start premium OCR for ClearPro users
    _tryPremiumOcr();
  }

  Future<void> _tryPremiumOcr() async {
    final tier = ref.read(settingsProvider).subscriptionTier;
    if (tier != 'clearPro') return;
    if (widget.rawText.isEmpty) return;

    setState(() => _isPremiumLoading = true);

    final locale = ref.read(settingsProvider).language;
    final localeCode = locale == '일본어'
        ? 'ja'
        : locale == '영어'
            ? 'en'
            : 'ko';

    final result = await PremiumOcrService().parseReceipt(widget.rawText, localeCode);

    if (!mounted) return;
    setState(() {
      _isPremiumLoading = false;
      if (result != null) {
        _premiumResult = result;
        _applyPremiumResult(result);
      }
    });
  }

  void _applyPremiumResult(PremiumOcrResult result) {
    _premiumApplied = true;
    if (result.amount > 0) {
      _amountController.text = result.amount.toString();
    }
    if (result.storeName.isNotEmpty) {
      _storeNameController.text = result.storeName;
    }
    if (result.date.isNotEmpty) {
      final parsed = DateTime.tryParse(result.date);
      if (parsed != null) _selectedDate = parsed;
    }
    // Map premium category to our category keys
    final premiumKey = _mapPremiumCategory(result.category);
    if (premiumKey != null) {
      _selectedCategoryKey = premiumKey;
      _selectedCategoryEmoji = DefaultCategories.emojiForKey(premiumKey);
    }
    if (result.memo != null && result.memo!.isNotEmpty) {
      _memoController.text = result.memo!;
    }
  }

  String? _mapPremiumCategory(String category) {
    final lower = category.toLowerCase();
    const mapping = {
      'food': 'food',
      '食費': 'food',
      'cafe': 'cafe',
      'カフェ': 'cafe',
      '外食': 'cafe',
      'transport': 'transport',
      '交通': 'transport',
      '交通費': 'transport',
      'shopping': 'shopping',
      '買物': 'shopping',
      '日用品': 'shopping',
      'medical': 'medical',
      '医療': 'medical',
      '医療費': 'medical',
      'entertainment': 'entertainment',
      '娯楽': 'entertainment',
      '趣味': 'entertainment',
      'other': 'other',
      'その他': 'other',
    };

    for (final entry in mapping.entries) {
      if (lower.contains(entry.key.toLowerCase())) return entry.value;
    }
    return null;
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
        actions: [
          if (_premiumApplied)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Chip(
                label: Text(
                  l10n.aiAnalyzed,
                  style: TextStyle(
                    fontFamily: 'PretendardJP',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
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

                  // Premium loading banner
                  if (_isPremiumLoading)
                    _buildPremiumLoadingBanner(theme, l10n),

                  // Amount not recognized warning
                  if (widget.amount == null && !_premiumApplied) ...[
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

                  // Category selection with auto-detect badge
                  Row(
                    children: [
                      Text(
                        l10n.selectCategory,
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      if (_selectedCategoryKey != null &&
                          _selectedCategoryKey == widget.suggestedCategoryKey &&
                          !_premiumApplied) ...[
                        const SizedBox(width: 8),
                        _buildCategoryBadge(theme, l10n),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryGrid(context),

                  // Premium items list (ClearPro only)
                  if (_premiumResult != null && _premiumResult!.items.isNotEmpty)
                    _buildItemsList(theme, l10n),

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

                  // Premium upsell banner (for Free/Clear users)
                  if (_premiumResult == null && !_isPremiumLoading)
                    _buildUpsellBanner(theme, l10n),

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

  Widget _buildCategoryBadge(ThemeData theme, AppLocalizations l10n) {
    final isHighConfidence = widget.categoryConfidence >= 0.8;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isHighConfidence
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isHighConfidence ? l10n.autoDetected : l10n.pleaseVerify,
        style: TextStyle(
          fontFamily: 'PretendardJP',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isHighConfidence ? theme.colorScheme.primary : Colors.orange,
        ),
      ),
    );
  }

  Widget _buildPremiumLoadingBanner(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.premiumOcrBannerClearPro,
              style: TextStyle(
                fontFamily: 'PretendardJP',
                fontSize: 12,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpsellBanner(ThemeData theme, AppLocalizations l10n) {
    final tier = ref.watch(settingsProvider).subscriptionTier;
    if (tier == 'clearPro') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.auto_awesome_rounded,
                size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.premiumOcrBanner,
                style: TextStyle(
                  fontFamily: 'PretendardJP',
                  fontSize: 12,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(ThemeData theme, AppLocalizations l10n) {
    final items = _premiumResult!.items;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          collapsedBackgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          title: Text(
            '${l10n.purchasedItems} (${items.length})',
            style: const TextStyle(
              fontFamily: 'PretendardJP',
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          children: [
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.quantity > 1) ...[
                      Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '¥${item.price}',
                      style: const TextStyle(
                        fontFamily: 'PretendardJP',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            if (_premiumResult!.tax > 0) ...[
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.taxAmount,
                      style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  Text('¥${_premiumResult!.tax}',
                      style: const TextStyle(
                          fontFamily: 'PretendardJP', fontSize: 12)),
                ],
              ),
            ],
            if (_premiumResult!.discount > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.discountAmount,
                      style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                  Text('-¥${_premiumResult!.discount}',
                      style: TextStyle(
                          fontFamily: 'PretendardJP',
                          fontSize: 12,
                          color: theme.colorScheme.error)),
                ],
              ),
            ],
          ],
        ),
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
