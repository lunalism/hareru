import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfShareService {
  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required DateTime month,
    Rect? sharePositionOrigin,
  }) async {
    final dir = await getTemporaryDirectory();
    final fileName =
        'hareru_report_${month.year}${month.month.toString().padLeft(2, '0')}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(pdfBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Hareru Report ${month.year}/${month.month}',
      sharePositionOrigin: sharePositionOrigin ?? const Rect.fromLTWH(0, 0, 1, 1),
    );
  }
}
