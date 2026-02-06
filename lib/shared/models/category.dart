enum ExpenseCategory {
  food('食費', '🍱'),
  transport('交通', '🚃'),
  shopping('買物', '🛒'),
  cafe('カフェ', '☕'),
  entertainment('娯楽', '🎮'),
  medical('医療', '💊'),
  transfer('振込', '💳'),
  other('その他', '📎');

  const ExpenseCategory(this.label, this.emoji);

  final String label;
  final String emoji;
}
