enum ExpenseCategory {
  food('식비', '🍱'),
  transport('교통', '🚃'),
  shopping('쇼핑', '🛒'),
  cafe('카페', '☕'),
  entertainment('여가', '🎮'),
  medical('의료', '💊'),
  transfer('이체', '💳'),
  other('기타', '📎');

  const ExpenseCategory(this.label, this.emoji);

  final String label;
  final String emoji;
}
