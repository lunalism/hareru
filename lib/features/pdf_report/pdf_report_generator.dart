import 'package:flutter/services.dart';
import 'package:hareru/features/pdf_report/pdf_donut_chart.dart';
import 'package:hareru/models/transaction.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// All data needed to generate the PDF, decoupled from providers.
class PdfReportData {
  final DateTime month;
  final double incomeTotal;
  final double expenseTotal;
  final double transferTotal;
  final double savingsTotal;
  final int budget;
  final Map<String, double> categoryExpenses; // categoryName → amount
  final List<Transaction> transactions;
  final List<String> insights;
  final String locale; // 'ja', 'ko', 'en'
  final Map<String, String> categoryDisplayNames; // raw key → display name

  // L10n strings passed in so generator is context-free
  final String lMonthlyReport;
  final String lRealExpense;
  final String lApparentExpense;
  final String lDifference;
  final String lIncome;
  final String lExpense;
  final String lTransfer;
  final String lSavings;
  final String lMonthlyBudget;
  final String lRemaining;
  final String lMonthlyInsight;
  final String lBrandFooter;
  final String Function(int) lTransactionCount;
  final String Function(int) lAndMore;
  final String Function(String) lGeneratedOn;

  PdfReportData({
    required this.month,
    required this.incomeTotal,
    required this.expenseTotal,
    required this.transferTotal,
    required this.savingsTotal,
    required this.budget,
    required this.categoryExpenses,
    required this.transactions,
    required this.insights,
    required this.locale,
    required this.categoryDisplayNames,
    required this.lMonthlyReport,
    required this.lRealExpense,
    required this.lApparentExpense,
    required this.lDifference,
    required this.lIncome,
    required this.lExpense,
    required this.lTransfer,
    required this.lSavings,
    required this.lMonthlyBudget,
    required this.lRemaining,
    required this.lMonthlyInsight,
    required this.lBrandFooter,
    required this.lTransactionCount,
    required this.lAndMore,
    required this.lGeneratedOn,
  });
}

const _categoryPdfColors = [
  PdfColor.fromInt(0xFFEF4444),
  PdfColor.fromInt(0xFF3B82F6),
  PdfColor.fromInt(0xFF10B981),
  PdfColor.fromInt(0xFFF59E0B),
  PdfColor.fromInt(0xFF8B5CF6),
  PdfColor.fromInt(0xFFEC4899),
  PdfColor.fromInt(0xFF06B6D4),
  PdfColor.fromInt(0xFFFF6B35),
  PdfColor.fromInt(0xFF6366F1),
  PdfColor.fromInt(0xFF84CC16),
  PdfColor.fromInt(0xFF94A3B8),
];

// ── Type colors (강화) ──
const _expenseColor = PdfColor.fromInt(0xFFFF5252);
const _transferColor = PdfColor.fromInt(0xFF448AFF);
const _savingsColor = PdfColor.fromInt(0xFF4CAF50);
const _incomeColor = PdfColor.fromInt(0xFF7C4DFF);

// ── Shared colors ──
const _textPrimary = PdfColor.fromInt(0xFF1E293B);
const _textSecondary = PdfColor.fromInt(0xFF64748B);
const _textTertiary = PdfColor.fromInt(0xFF94A3B8);
const _headerBg = PdfColor.fromInt(0xFF4A90D9);
const _cardBorder = PdfColor.fromInt(0xFFE2E8F0);
const _stripeBg = PdfColor.fromInt(0xFFF8FAFC);

class PdfReportGenerator {
  static Future<Uint8List> generate(PdfReportData data) async {
    final fontAsset = data.locale == 'ko'
        ? 'assets/fonts/NotoSansKR-Regular.ttf'
        : 'assets/fonts/NotoSansJP-Regular.ttf';
    final fontData = await rootBundle.load(fontAsset);
    final font = pw.Font.ttf(fontData);
    final fontBold = pw.Font.ttf(fontData.buffer.asByteData());

    final doc = pw.Document();

    doc.addPage(_buildPage1(data, font, fontBold));
    doc.addPage(_buildPage2(data, font, fontBold));

    return doc.save();
  }

  // ── Page 1 ──

  static pw.Page _buildPage1(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(data, font, fontBold, full: true),
            pw.SizedBox(height: 24),
            _buildRealExpenseCard(data, font, fontBold),
            pw.SizedBox(height: 22),
            _buildTypeGrid(data, font, fontBold),
            pw.SizedBox(height: 22),
            _buildCategorySection(data, font, fontBold),
            pw.SizedBox(height: 22),
            _buildBudgetBar(data, font, fontBold),
            pw.Spacer(),
            _buildPageFooter(font, '1/2'),
          ],
        );
      },
    );
  }

  // ── Page 2 ──

  static pw.Page _buildPage2(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(data, font, fontBold, full: false),
            pw.SizedBox(height: 22),
            _buildTransactionTable(data, font, fontBold),
            pw.SizedBox(height: 22),
            _buildInsightCard(data, font, fontBold),
            pw.Spacer(),
            _buildBrandFooter(data, font, fontBold),
          ],
        );
      },
    );
  }

  // ── Header ──

  static pw.Widget _buildHeader(
    PdfReportData data,
    pw.Font font,
    pw.Font fontBold, {
    required bool full,
  }) {
    final monthStr = _formatMonth(data.month, data.locale);
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      decoration: const pw.BoxDecoration(
        color: _headerBg,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(16)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            '\u25C7 Hareru',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                monthStr,
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: full ? 22 : 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              if (full)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4),
                  child: pw.Text(
                    data.lMonthlyReport,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 16,
                      color: const PdfColor.fromInt(0xFFD0E4FF),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Real expense card ──

  static pw.Widget _buildRealExpenseCard(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    final apparentExpense =
        data.expenseTotal + data.transferTotal + data.savingsTotal;
    final difference = apparentExpense - data.expenseTotal;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(24),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFFFF0F0),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xFFFECACA),
          width: 1.5,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            data.lRealExpense,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: _textSecondary,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            _yen(data.expenseTotal),
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 48,
              fontWeight: pw.FontWeight.bold,
              color: _expenseColor,
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Container(
            width: double.infinity,
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFFFF5F5),
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  '${data.lApparentExpense}: ${_yen(apparentExpense)}',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 14,
                    color: _textSecondary,
                  ),
                ),
                pw.Text(
                  '${data.lDifference}: ${_yen(difference)}',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Type grid (2x2) ──

  static pw.Widget _buildTypeGrid(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    final items = [
      (data.lIncome, data.incomeTotal, _incomeColor),
      (data.lExpense, data.expenseTotal, _expenseColor),
      (data.lTransfer, data.transferTotal, _transferColor),
      (data.lSavings, data.savingsTotal, _savingsColor),
    ];

    pw.Widget buildCell(String label, double amount, PdfColor color) {
      return pw.Expanded(
        child: pw.Container(
          padding:
              const pw.EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          margin: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _cardBorder, width: 1),
            borderRadius:
                const pw.BorderRadius.all(pw.Radius.circular(12)),
          ),
          child: pw.Row(
            children: [
              pw.Container(
                width: 14,
                height: 14,
                decoration: pw.BoxDecoration(
                  color: color,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 10),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    label,
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 16,
                      color: _textSecondary,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    _yen(amount),
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return pw.Column(
      children: [
        pw.Row(children: [
          buildCell(items[0].$1, items[0].$2, items[0].$3),
          buildCell(items[1].$1, items[1].$2, items[1].$3),
        ]),
        pw.Row(children: [
          buildCell(items[2].$1, items[2].$2, items[2].$3),
          buildCell(items[3].$1, items[3].$2, items[3].$3),
        ]),
      ],
    );
  }

  // ── Category donut + legend ──

  static pw.Widget _buildCategorySection(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    if (data.categoryExpenses.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final sorted = data.categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final displayItems = sorted.take(7).toList();

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Donut chart
        pw.SizedBox(
          width: 190,
          height: 190,
          child: pw.Stack(
            alignment: pw.Alignment.center,
            children: [
              PdfDonutChart(
                data: {for (final e in displayItems) e.key: e.value},
                colors: _categoryPdfColors,
                centerText: _yen(data.expenseTotal),
                font: fontBold,
                size: 190,
                strokeWidth: 32,
              ),
              pw.Text(
                _yen(data.expenseTotal),
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        // Legend
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: displayItems.asMap().entries.map((entry) {
              final i = entry.key;
              final e = entry.value;
              final color =
                  _categoryPdfColors[i % _categoryPdfColors.length];
              final percent = data.expenseTotal > 0
                  ? (e.value / data.expenseTotal * 100).toStringAsFixed(0)
                  : '0';
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 7),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 12,
                      height: 12,
                      decoration: pw.BoxDecoration(
                        color: color,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: pw.Text(
                        _stripEmoji(e.key),
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 16,
                          color: _textPrimary,
                        ),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                    pw.Text(
                      '$percent%',
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── Budget progress bar ──

  static pw.Widget _buildBudgetBar(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    if (data.budget <= 0) return pw.SizedBox.shrink();

    final progress = (data.expenseTotal / data.budget).clamp(0.0, 1.0);
    final percentage =
        (data.expenseTotal / data.budget * 100).toStringAsFixed(1);
    final remaining = data.budget - data.expenseTotal;
    final isOver = remaining < 0;

    final barColor = progress > 0.9
        ? const PdfColor.fromInt(0xFFEF4444)
        : progress > 0.7
            ? const PdfColor.fromInt(0xFFF59E0B)
            : const PdfColor.fromInt(0xFF448AFF);

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _cardBorder, width: 1),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(14)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${data.lMonthlyBudget}  ${_yen(data.budget.toDouble())}',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
              pw.Text(
                '$percentage%',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Stack(
            children: [
              pw.Container(
                height: 16,
                decoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFF1F5F9),
                  borderRadius:
                      pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
              ),
              pw.LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth =
                      (constraints?.maxWidth ?? 515) * progress;
                  return pw.Container(
                    width: barWidth,
                    height: 16,
                    decoration: pw.BoxDecoration(
                      color: barColor,
                      borderRadius: const pw.BorderRadius.all(
                          pw.Radius.circular(8)),
                    ),
                  );
                },
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            isOver
                ? '${_yen(remaining.abs())} over'
                : '${data.lRemaining}: ${_yen(remaining)}',
            style: pw.TextStyle(
              font: font,
              fontSize: 14,
              color: isOver
                  ? const PdfColor.fromInt(0xFFEF4444)
                  : _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Transaction table (Page 2) ──

  static pw.Widget _buildTransactionTable(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    final sections = <pw.Widget>[];

    final typeGroups = [
      (data.lExpense, TransactionType.expense, _expenseColor),
      (data.lTransfer, TransactionType.transfer, _transferColor),
      (data.lSavings, TransactionType.savings, _savingsColor),
    ];

    for (final (label, type, color) in typeGroups) {
      final txns = data.transactions
          .where((t) => t.type == type)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (txns.isEmpty) continue;

      final displayTxns = txns.take(10).toList();
      final remaining = txns.length - displayTxns.length;

      sections.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Section header badge
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: pw.BoxDecoration(
                color: color,
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(10)),
              ),
              child: pw.Text(
                '$label  ${data.lTransactionCount(txns.length)}',
                style: pw.TextStyle(
                  font: fontBold,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 4),
            // Rows with alternating stripes
            ...displayTxns.asMap().entries.map((entry) {
              final idx = entry.key;
              final t = entry.value;
              final isStripe = idx.isOdd;
              return pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: pw.BoxDecoration(
                  color: isStripe ? _stripeBg : null,
                ),
                child: pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 80,
                      child: pw.Text(
                        '${t.createdAt.month}/${t.createdAt.day}',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 16,
                          color: _textTertiary,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        _stripEmoji(
                            data.categoryDisplayNames[t.category] ??
                                t.category),
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 16,
                          color: _textPrimary,
                        ),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                    pw.Text(
                      _yen(t.amount),
                      style: pw.TextStyle(
                        font: fontBold,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (remaining > 0)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                child: pw.Text(
                  data.lAndMore(remaining),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 14,
                    color: _textTertiary,
                  ),
                ),
              ),
            pw.SizedBox(height: 16),
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: sections,
    );
  }

  // ── AI Insight card ──

  static pw.Widget _buildInsightCard(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    if (data.insights.isEmpty) return pw.SizedBox.shrink();

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(22),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF0F9FF),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),
        border: pw.Border.all(
          color: const PdfColor.fromInt(0xFFBAE6FD),
          width: 1.5,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            data.lMonthlyInsight,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: _textPrimary,
            ),
          ),
          pw.SizedBox(height: 12),
          ...data.insights.map(
            (text) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 8),
              child: pw.Text(
                text,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 16,
                  color: _textPrimary,
                  lineSpacing: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Brand footer (Page 2) ──

  static pw.Widget _buildBrandFooter(
      PdfReportData data, pw.Font font, pw.Font fontBold) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    return pw.Column(
      children: [
        pw.Divider(color: _cardBorder, thickness: 1),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              data.lBrandFooter,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: _textSecondary,
              ),
            ),
            pw.Text(
              data.lGeneratedOn(dateStr),
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                color: _textTertiary,
              ),
            ),
            pw.Text(
              '2/2',
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                color: _textTertiary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Page footer ──

  static pw.Widget _buildPageFooter(pw.Font font, String pageNum) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        pageNum,
        style: pw.TextStyle(
          font: font,
          fontSize: 12,
          color: _textTertiary,
        ),
      ),
    );
  }

  // ── Helpers ──

  static String _yen(double value) {
    final intVal = value.truncate();
    final s = intVal.abs().toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    final prefix = intVal < 0 ? '-' : '';
    return '$prefix\u00a5${buf.toString()}';
  }

  static String _formatMonth(DateTime month, String locale) {
    return switch (locale) {
      'ja' => '${month.year}\u5E74${month.month}\u6708',
      'ko' => '${month.year}\uB144 ${month.month}\uC6D4',
      _ => '${month.month}/${month.year}',
    };
  }

  /// Remove emoji codepoints that pdf package cannot render.
  static String _stripEmoji(String text) {
    return text.replaceAll(
      RegExp(
        r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|'
        r'[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|'
        r'[\u{FE00}-\u{FE0F}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA00}-\u{1FA6F}]|'
        r'[\u{1FA70}-\u{1FAFF}]|[\u{200D}]|[\u{20E3}]|[\u{E0020}-\u{E007F}]',
        unicode: true,
      ),
      '',
    ).trim();
  }
}
