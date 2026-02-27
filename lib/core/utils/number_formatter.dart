String formatAmount(double value) {
  if (value == value.truncateToDouble()) {
    return addCommas(value.truncate().toString());
  }
  return addCommas(value.toStringAsFixed(2));
}

String addCommas(String s) {
  if (s.isEmpty) return '';
  final parts = s.split('.');
  final intPart = parts[0];
  final result = StringBuffer();
  var count = 0;
  for (var i = intPart.length - 1; i >= 0; i--) {
    result.write(intPart[i]);
    count++;
    if (count % 3 == 0 && i > 0) result.write(',');
  }
  final formatted = result.toString().split('').reversed.join();
  return parts.length > 1 ? '$formatted.${parts[1]}' : formatted;
}

String formatWithCommas(String raw) {
  final clean = raw.replaceAll(',', '');
  if (clean.isEmpty) return '';
  if (clean.contains('.')) {
    final parts = clean.split('.');
    return '${addCommas(parts[0])}.${parts[1]}';
  }
  return addCommas(clean);
}
