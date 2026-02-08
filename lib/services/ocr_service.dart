import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrResult {
  const OcrResult({
    this.amount,
    this.storeName,
    this.date,
    required this.rawText,
    required this.confidence,
  });

  final int? amount;
  final String? storeName;
  final String? date;
  final String rawText;
  final double confidence;
}

class OcrService {
  /// Recognizes text from an image file and extracts receipt data.
  Future<OcrResult> processReceipt(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);

    try {
      final recognizedText = await textRecognizer.processImage(inputImage);
      final rawText = recognizedText.text;

      if (rawText.trim().isEmpty) {
        return const OcrResult(rawText: '', confidence: 0.0);
      }

      final amount = _extractAmount(recognizedText);
      final storeName = _extractStoreName(recognizedText);
      final date = _extractDate(rawText);
      final confidence = _calculateConfidence(recognizedText);

      return OcrResult(
        amount: amount,
        storeName: storeName,
        date: date,
        rawText: rawText,
        confidence: confidence,
      );
    } finally {
      textRecognizer.close();
    }
  }

  /// Extracts the total amount from recognized text.
  /// Priority: 合計 > お買上合計 > 税込 > ¥ symbol > largest number
  int? _extractAmount(RecognizedText result) {
    final allText = result.text;
    final lines = allText.split('\n');

    // Pattern priority list (Japanese receipt patterns)
    final patterns = [
      RegExp(r'合計\s*金?額?\s*[¥￥]?\s*([\d,]+)'),
      RegExp(r'お買上\s*合計\s*[¥￥]?\s*([\d,]+)'),
      RegExp(r'税込\s*[¥￥]?\s*([\d,]+)'),
      RegExp(r'合計\s*[¥￥]?\s*([\d,]+)'),
      RegExp(r'total\s*[¥￥]?\s*([\d,]+)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      for (final line in lines) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          final amount = _parseAmount(match.group(1)!);
          if (amount != null && amount > 0) return amount;
        }
      }
    }

    // Fallback: look for ¥ symbol followed by numbers
    final yenPattern = RegExp(r'[¥￥]\s*([\d,]+)');
    int? largestYenAmount;
    for (final line in lines) {
      for (final match in yenPattern.allMatches(line)) {
        final amount = _parseAmount(match.group(1)!);
        if (amount != null && amount > 0) {
          if (largestYenAmount == null || amount > largestYenAmount) {
            largestYenAmount = amount;
          }
        }
      }
    }
    if (largestYenAmount != null) return largestYenAmount;

    // Last fallback: find the largest number on the receipt
    final numberPattern = RegExp(r'(\d{1,3}(?:,\d{3})+|\d{3,})');
    int? largestAmount;
    for (final line in lines) {
      for (final match in numberPattern.allMatches(line)) {
        final amount = _parseAmount(match.group(1)!);
        if (amount != null && amount >= 100 && amount < 1000000) {
          if (largestAmount == null || amount > largestAmount) {
            largestAmount = amount;
          }
        }
      }
    }

    return largestAmount;
  }

  /// Extracts the store name from the first few lines.
  String? _extractStoreName(RecognizedText result) {
    final lines = result.text.split('\n');
    // Skip patterns that aren't store names
    final skipPatterns = [
      RegExp(r'^\d{2,4}[/-]'), // Dates
      RegExp(r'^\d{2,3}-\d{3,4}-\d{4}'), // Phone numbers
      RegExp(r'^〒?\d{3}-\d{4}'), // Postal codes
      RegExp(r'^(東京|大阪|京都|北海道|神奈川|千葉|埼玉|愛知|福岡)'), // Addresses starting with prefecture
      RegExp(r'^\d+[階F]'), // Floor numbers
      RegExp(r'^TEL|^FAX|^tel|^fax'),
      RegExp(r'^\s*$'), // Empty lines
      RegExp(r'^(レシート|領収書|領収証)'), // "Receipt" headers
    ];

    for (var i = 0; i < lines.length && i < 3; i++) {
      final line = lines[i].trim();
      if (line.isEmpty || line.length < 2 || line.length > 30) continue;

      var skip = false;
      for (final pattern in skipPatterns) {
        if (pattern.hasMatch(line)) {
          skip = true;
          break;
        }
      }
      if (!skip) return line;
    }

    return null;
  }

  /// Extracts a date from the text.
  String? _extractDate(String text) {
    // yyyy/mm/dd or yyyy-mm-dd
    final slashDate = RegExp(r'(\d{4})[/\-](\d{1,2})[/\-](\d{1,2})');
    final match1 = slashDate.firstMatch(text);
    if (match1 != null) {
      final y = match1.group(1)!;
      final m = match1.group(2)!.padLeft(2, '0');
      final d = match1.group(3)!.padLeft(2, '0');
      return '$y-$m-$d';
    }

    // yyyy年mm月dd日
    final japaneseDate = RegExp(r'(\d{4})年(\d{1,2})月(\d{1,2})日');
    final match2 = japaneseDate.firstMatch(text);
    if (match2 != null) {
      final y = match2.group(1)!;
      final m = match2.group(2)!.padLeft(2, '0');
      final d = match2.group(3)!.padLeft(2, '0');
      return '$y-$m-$d';
    }

    // Reiwa era: 令和yy年mm月dd日 or R yy/mm/dd
    final reiwaDate = RegExp(r'令和\s*(\d{1,2})年(\d{1,2})月(\d{1,2})日');
    final match3 = reiwaDate.firstMatch(text);
    if (match3 != null) {
      final y = 2018 + int.parse(match3.group(1)!);
      final m = match3.group(2)!.padLeft(2, '0');
      final d = match3.group(3)!.padLeft(2, '0');
      return '$y-$m-$d';
    }

    return null;
  }

  /// Parses a number string removing commas.
  int? _parseAmount(String text) {
    final cleaned = text.replaceAll(',', '').replaceAll(' ', '');
    return int.tryParse(cleaned);
  }

  /// Estimates confidence based on text block quality.
  double _calculateConfidence(RecognizedText result) {
    if (result.blocks.isEmpty) return 0.0;

    var totalConfidence = 0.0;
    var count = 0;
    for (final block in result.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          if (element.confidence != null) {
            totalConfidence += element.confidence!;
            count++;
          }
        }
      }
    }

    if (count == 0) return 0.5; // ML Kit doesn't always provide confidence
    return totalConfidence / count;
  }
}
