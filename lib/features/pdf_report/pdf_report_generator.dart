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

const _expenseColor = PdfColor.fromInt(0xFFEF4444);
const _transferColor = PdfColor.fromInt(0xFF3B82F6);
const _savingsColor = PdfColor.fromInt(0xFF10B981);
const _incomeColor = PdfColor.fromInt(0xFF8B5CF6);

class PdfReportGenerator {
  static Future<Uint8List> generate(PdfReportData data) async {
    final fontData = await rootBundle.load('assets/fonts/NotoSansJP-Regular.ttf');
    final font = pw.Font.ttf(fontData);

    final doc = pw.Document();

    doc.addPage(_buildPage1(data, font));
    doc.addPage(_buildPage2(data, font));

    return doc.save();
  }

  // ── Page 1 ──

  static pw.Page _buildPage1(PdfReportData data, pw.Font font) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(data, font, full: true),
            pw.SizedBox(height: 20),
            _buildRealExpenseCard(data, font),
            pw.SizedBox(height: 16),
            _buildTypeGrid(data, font),
            pw.SizedBox(height: 16),
            _buildCategorySection(data, font),
            pw.SizedBox(height: 16),
            _buildBudgetBar(data, font),
            pw.Spacer(),
            _buildPageFooter(font, '1/2'),
          ],
        );
      },
    );
  }

  // ── Page 2 ──

  static pw.Page _buildPage2(PdfReportData data, pw.Font font) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(data, font, full: false),
            pw.SizedBox(height: 16),
            _buildTransactionTable(data, font),
            pw.SizedBox(height: 16),
            _buildInsightCard(data, font),
            pw.Spacer(),
            _buildBrandFooter(data, font),
          ],
        );
      },
    );
  }

  // ── Gradient Header ──

  static pw.Widget _buildHeader(
      PdfReportData data, pw.Font font, {required bool full}) {
    final monthStr = _formatMonth(data.month, data.locale);
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF4A90D9),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(12)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Hareru',
            style: pw.TextStyle(
              font: font,
              fontSize: full ? 20 : 16,
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
                  font: font,
                  fontSize: full ? 14 : 12,
                  color: PdfColors.white,
                ),
              ),
              if (full)
                pw.Text(
                  data.lMonthlyReport,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 11,
                    color: const PdfColor.fromInt(0xFFD0E4FF),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Real expense card ──

  static pw.Widget _buildRealExpenseCard(PdfReportData data, pw.Font font) {
    final apparentExpense =
        data.expenseTotal + data.transferTotal + data.savingsTotal;
    final difference = apparentExpense - data.expenseTotal;

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFFEF2F2),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            data.lRealExpense,
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              color: const PdfColor.fromInt(0xFF64748B),
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _yen(data.expenseTotal),
            style: pw.TextStyle(
              font: font,
              fontSize: 28,
              fontWeight: pw.FontWeight.bold,
              color: _expenseColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${data.lApparentExpense}: ${_yen(apparentExpense)}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: const PdfColor.fromInt(0xFF94A3B8),
                ),
              ),
              pw.Text(
                '${data.lDifference}: ${_yen(difference)}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: const PdfColor.fromInt(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Type grid (4 columns) ──

  static pw.Widget _buildTypeGrid(PdfReportData data, pw.Font font) {
    final items = [
      (data.lIncome, data.incomeTotal, _incomeColor),
      (data.lExpense, data.expenseTotal, _expenseColor),
      (data.lTransfer, data.transferTotal, _transferColor),
      (data.lSavings, data.savingsTotal, _savingsColor),
    ];

    return pw.Row(
      children: items.map((item) {
        final (label, amount, color) = item;
        return pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            child: pw.Column(
              children: [
                pw.Container(
                  width: 8,
                  height: 8,
                  decoration: pw.BoxDecoration(
                    color: color,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  label,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 10,
                    color: const PdfColor.fromInt(0xFF64748B),
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  _yen(amount),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Category donut + legend ──

  static pw.Widget _buildCategorySection(PdfReportData data, pw.Font font) {
    if (data.categoryExpenses.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final sorted = data.categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final displayItems = sorted.take(8).toList();

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Donut chart
        pw.SizedBox(
          width: 140,
          height: 140,
          child: pw.Stack(
            alignment: pw.Alignment.center,
            children: [
              PdfDonutChart(
                data: {for (final e in displayItems) e.key: e.value},
                colors: _categoryPdfColors,
                centerText: _yen(data.expenseTotal),
                font: font,
              ),
              pw.Text(
                _yen(data.expenseTotal),
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(width: 16),
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
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                        color: color,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                    pw.SizedBox(width: 6),
                    pw.Expanded(
                      child: pw.Text(
                        _stripEmoji(e.key),
                        style: pw.TextStyle(font: font, fontSize: 10),
                        overflow: pw.TextOverflow.clip,
                      ),
                    ),
                    pw.Text(
                      '$percent%',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 9,
                        color: const PdfColor.fromInt(0xFF94A3B8),
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

  static pw.Widget _buildBudgetBar(PdfReportData data, pw.Font font) {
    if (data.budget <= 0) return pw.SizedBox.shrink();

    final progress = (data.expenseTotal / data.budget).clamp(0.0, 1.0);
    final percentage = (data.expenseTotal / data.budget * 100).toStringAsFixed(1);
    final remaining = data.budget - data.expenseTotal;
    final isOver = remaining < 0;

    final barColor = progress > 0.9
        ? const PdfColor.fromInt(0xFFEF4444)
        : progress > 0.7
            ? const PdfColor.fromInt(0xFFF59E0B)
            : const PdfColor.fromInt(0xFF3B82F6);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${data.lMonthlyBudget}  ${_yen(data.budget.toDouble())}',
              style: pw.TextStyle(
                font: font,
                fontSize: 10,
                color: const PdfColor.fromInt(0xFF64748B),
              ),
            ),
            pw.Text(
              '$percentage%',
              style: pw.TextStyle(
                font: font,
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: barColor,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Stack(
          children: [
            pw.Container(
              height: 8,
              decoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFF1F5F9),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
            ),
            pw.LayoutBuilder(
              builder: (context, constraints) {
                final barWidth =
                    (constraints?.maxWidth ?? 515) * progress;
                return pw.Container(
                  width: barWidth,
                  height: 8,
                  decoration: pw.BoxDecoration(
                    color: barColor,
                    borderRadius:
                        const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                );
              },
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          isOver
              ? '${_yen(remaining.abs())} over'
              : '${data.lRemaining}: ${_yen(remaining)}',
          style: pw.TextStyle(
            font: font,
            fontSize: 9,
            color: isOver
                ? const PdfColor.fromInt(0xFFEF4444)
                : const PdfColor.fromInt(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ── Transaction table (Page 2) ──

  static pw.Widget _buildTransactionTable(PdfReportData data, pw.Font font) {
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

      final displayTxns = txns.take(15).toList();
      final remaining = txns.length - displayTxns.length;

      sections.add(
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding:
                  const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                color: color,
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(
                '$label  ${data.lTransactionCount(txns.length)}',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 6),
            ...displayTxns.map((t) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 3),
                  child: pw.Row(
                    children: [
                      pw.SizedBox(
                        width: 60,
                        child: pw.Text(
                          '${t.createdAt.month}/${t.createdAt.day}',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            color: const PdfColor.fromInt(0xFF94A3B8),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          _stripEmoji(t.category),
                          style: pw.TextStyle(font: font, fontSize: 9),
                          overflow: pw.TextOverflow.clip,
                        ),
                      ),
                      pw.Text(
                        _yen(t.amount),
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                )),
            if (remaining > 0)
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 2),
                child: pw.Text(
                  data.lAndMore(remaining),
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: const PdfColor.fromInt(0xFF94A3B8),
                  ),
                ),
              ),
            pw.SizedBox(height: 12),
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

  static pw.Widget _buildInsightCard(PdfReportData data, pw.Font font) {
    if (data.insights.isEmpty) return pw.SizedBox.shrink();

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(14),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF0F9FF),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            data.lMonthlyInsight,
            style: pw.TextStyle(
              font: font,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 6),
          ...data.insights.map(
            (text) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 3),
              child: pw.Text(
                text,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 10,
                  color: const PdfColor.fromInt(0xFF1E293B),
                  lineSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Brand footer (Page 2) ──

  static pw.Widget _buildBrandFooter(PdfReportData data, pw.Font font) {
    final now = DateTime.now();
    final dateStr = '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';

    return pw.Column(
      children: [
        pw.Divider(color: const PdfColor.fromInt(0xFFE2E8F0)),
        pw.SizedBox(height: 6),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              data.lBrandFooter,
              style: pw.TextStyle(
                font: font,
                fontSize: 9,
                color: const PdfColor.fromInt(0xFF94A3B8),
              ),
            ),
            pw.Text(
              data.lGeneratedOn(dateStr),
              style: pw.TextStyle(
                font: font,
                fontSize: 9,
                color: const PdfColor.fromInt(0xFF94A3B8),
              ),
            ),
            pw.Text(
              '2/2',
              style: pw.TextStyle(
                font: font,
                fontSize: 9,
                color: const PdfColor.fromInt(0xFF94A3B8),
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
          fontSize: 9,
          color: const PdfColor.fromInt(0xFF94A3B8),
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
