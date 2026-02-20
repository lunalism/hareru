import 'dart:math';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfDonutChart extends pw.StatelessWidget {
  PdfDonutChart({
    required this.data,
    required this.colors,
    required this.centerText,
    required this.font,
    this.size = 140,
    this.strokeWidth = 24,
  });

  final Map<String, double> data;
  final List<PdfColor> colors;
  final String centerText;
  final pw.Font font;
  final double size;
  final double strokeWidth;

  @override
  pw.Widget build(pw.Context context) {
    return pw.SizedBox(
      width: size,
      height: size,
      child: pw.CustomPaint(
        size: PdfPoint(size, size),
        painter: (canvas, canvasSize) {
          final center = PdfPoint(canvasSize.x / 2, canvasSize.y / 2);
          final radius = (canvasSize.x - strokeWidth) / 2;
          final total =
              data.values.fold(0.0, (sum, v) => sum + v);
          if (total <= 0) return;

          var startAngle = -pi / 2;
          var i = 0;
          for (final entry in data.entries) {
            final sweep = (entry.value / total) * 2 * pi;
            final colorIndex = i % colors.length;

            _drawArc(
              canvas,
              center,
              radius,
              startAngle,
              sweep,
              colors[colorIndex],
            );

            startAngle += sweep;
            i++;
          }
        },
      ),
    );
  }

  void _drawArc(
    PdfGraphics canvas,
    PdfPoint center,
    double radius,
    double startAngle,
    double sweepAngle,
    PdfColor color,
  ) {
    canvas
      ..setStrokeColor(color)
      ..setLineWidth(strokeWidth)
      ..setLineCap(PdfLineCap.butt);

    const segments = 36;
    final step = sweepAngle / segments;

    final startX = center.x + radius * cos(startAngle);
    final startY = center.y + radius * sin(startAngle);
    canvas.moveTo(startX, startY);

    for (var i = 1; i <= segments; i++) {
      final angle = startAngle + step * i;
      final x = center.x + radius * cos(angle);
      final y = center.y + radius * sin(angle);
      canvas.lineTo(x, y);
    }

    canvas.strokePath();
  }
}
