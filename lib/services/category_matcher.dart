class CategorySuggestion {
  const CategorySuggestion({
    this.categoryKey,
    this.categoryEmoji,
    required this.confidence,
    this.matchReason,
  });

  final String? categoryKey;
  final String? categoryEmoji;
  final double confidence;
  final String? matchReason;
}

class CategoryMatcher {
  /// Suggests a category based on store name and raw OCR text.
  CategorySuggestion suggestCategory(String? storeName, String rawText) {
    // 1. Try matching store name (highest confidence)
    if (storeName != null && storeName.isNotEmpty) {
      for (final entry in _keywordMap.entries) {
        for (final keyword in entry.value) {
          if (storeName == keyword) {
            return CategorySuggestion(
              categoryKey: entry.key,
              categoryEmoji: _emojiMap[entry.key],
              confidence: 0.95,
              matchReason: '$keyword → ${_labelMap[entry.key]}',
            );
          }
        }
      }
      // Partial match in store name
      final storeUpper = storeName.toUpperCase();
      for (final entry in _keywordMap.entries) {
        for (final keyword in entry.value) {
          if (storeUpper.contains(keyword.toUpperCase())) {
            return CategorySuggestion(
              categoryKey: entry.key,
              categoryEmoji: _emojiMap[entry.key],
              confidence: 0.8,
              matchReason: '$keyword → ${_labelMap[entry.key]}',
            );
          }
        }
      }
    }

    // 2. Search full rawText (lower confidence)
    if (rawText.isNotEmpty) {
      final textUpper = rawText.toUpperCase();
      for (final entry in _keywordMap.entries) {
        for (final keyword in entry.value) {
          if (textUpper.contains(keyword.toUpperCase())) {
            return CategorySuggestion(
              categoryKey: entry.key,
              categoryEmoji: _emojiMap[entry.key],
              confidence: 0.6,
              matchReason: '$keyword → ${_labelMap[entry.key]}',
            );
          }
        }
      }
    }

    // 3. No match
    return const CategorySuggestion(confidence: 0.0);
  }

  static const _emojiMap = {
    'food': '🍱',
    'cafe': '☕',
    'transport': '🚃',
    'shopping': '🛒',
    'medical': '💊',
    'entertainment': '🎮',
    'other': '📎',
  };

  static const _labelMap = {
    'food': '食費',
    'cafe': 'カフェ・外食',
    'transport': '交通費',
    'shopping': '日用品・買物',
    'medical': '医療費',
    'entertainment': '趣味・娯楽',
    'other': 'その他',
  };

  /// Keyword → category mapping.
  /// Key = categoryKey, Value = list of keywords to search for.
  static const _keywordMap = <String, List<String>>{
    'food': [
      // Supermarkets
      'イオン', 'AEON', 'イトーヨーカドー', 'ライフ', 'LIFE', 'サミット',
      'OK', 'OKストア', '西友', 'SEIYU', 'マルエツ', '業務スーパー',
      'ヤオコー', 'コープ', 'COOP', 'まいばすけっと', 'オーケー',
      'ベイシア', 'カスミ', 'ベルク', 'ヨークベニマル', 'バロー',
      'マックスバリュ', 'ダイエー', '東急ストア', '成城石井',
      // Convenience stores
      'セブンイレブン', 'セブン-イレブン', '7-ELEVEN', 'SEVEN',
      'ファミリーマート', 'ファミマ', 'FamilyMart',
      'ローソン', 'LAWSON', 'ミニストップ', 'デイリーヤマザキ',
      'ナチュラルローソン', 'ポプラ', 'セイコーマート',
      // Keywords
      'スーパー', '食品', '青果', '鮮魚', '精肉', 'ベーカリー', 'パン屋',
    ],
    'cafe': [
      // Restaurants/Cafes
      'マクドナルド', 'マック', "McDonald's",
      'スターバックス', 'スタバ', 'STARBUCKS',
      'ドトール', 'DOUTOR', 'タリーズ', "TULLY'S",
      'サイゼリヤ', 'ガスト', 'ジョナサン', 'デニーズ', "Denny's",
      '吉野家', '松屋', 'すき家', 'なか卯',
      'CoCo壱', 'ココイチ', '丸亀製麺', 'はなまるうどん',
      'はま寿司', 'スシロー', 'くら寿司', 'かっぱ寿司',
      'モスバーガー', 'バーガーキング', 'ケンタッキー', 'KFC',
      'ミスタードーナツ', 'ミスド', 'コメダ珈琲', 'コメダ',
      '大戸屋', 'やよい軒', 'てんや', 'リンガーハット',
      'サブウェイ', 'SUBWAY', 'ピザーラ', 'ドミノ',
      // Keywords
      'レストラン', 'RESTAURANT', '食堂', '居酒屋', 'ラーメン',
      'カフェ', 'CAFE', '焼肉', '寿司', 'すし', '蕎麦', 'うどん',
      'ピザ', '弁当', 'デリバリー', 'Uber Eats', '出前館',
    ],
    'transport': [
      // IC cards / Transit
      'SUICA', 'Suica', 'PASMO', 'Pasmo', 'ICOCA',
      'チャージ', 'JR', '東京メトロ', '都営', '小田急', '京王',
      '東急', '西武', '京急', '相鉄', '東武', '近鉄', '阪急', '阪神',
      'バス', 'タクシー', 'TAXI',
      // Parking / Gas
      '駐車場', 'パーキング', 'コインパーキング', 'Times',
      'ガソリン', 'ENEOS', '出光', 'コスモ', 'Shell', 'シェル',
      'エッソ', 'GS',
      // Keywords
      '交通', '運賃', '乗車', '定期',
    ],
    'shopping': [
      // Drug stores
      'ドラッグストア', 'マツモトキヨシ', 'マツキヨ', 'ウエルシア',
      'ツルハ', 'サンドラッグ', 'ココカラファイン', 'スギ薬局',
      'トモズ', 'Tomod',
      // 100 yen shops / Household
      'DAISO', 'ダイソー', 'セリア', 'Seria', 'キャンドゥ', 'Can Do',
      '100均', 'ワッツ', 'Watts',
      // Home centers
      'ニトリ', 'NITORI', 'IKEA', 'イケア', '無印良品', 'MUJI',
      'カインズ', 'コーナン', 'DCM', 'ホームセンター',
      // Apparel
      'ユニクロ', 'UNIQLO', 'GU', 'ZARA', 'H&M',
      'しまむら', 'WEGO', 'ABC-MART', '靴',
      // Keywords
      '日用品', '洗剤', 'シャンプー', 'ティッシュ',
    ],
    'medical': [
      '病院', 'クリニック', '薬局', '調剤', '医院',
      '歯科', '眼科', '皮膚科', '内科', '外科', '耳鼻科',
      '整形外科', '小児科', '産婦人科',
      '処方', '診療',
    ],
    'entertainment': [
      // Books / Media
      '本屋', '書店', '紀伊國屋', 'TSUTAYA', 'ブックオフ', 'BOOKOFF',
      '丸善', 'ジュンク堂',
      // Games / Cinema
      'ゲーム', 'GAME', '映画', 'シネマ', 'TOHOシネマズ', 'イオンシネマ',
      // Electronics
      'ビックカメラ', 'ヨドバシ', 'ヤマダ電機', 'ケーズデンキ',
      'エディオン', 'ノジマ', 'ジョーシン', 'Apple Store',
      // Beauty
      '美容室', '美容院', 'ヘアサロン', '理容', '床屋',
      'ネイル', 'エステ',
      // Leisure
      'カラオケ', 'ボウリング', 'ジム', 'フィットネス',
      'スポーツ', 'ゴルフ',
    ],
  };
}
