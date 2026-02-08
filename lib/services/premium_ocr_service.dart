import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ReceiptItem {
  const ReceiptItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  final String name;
  final int price;
  final int quantity;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class PremiumOcrResult {
  const PremiumOcrResult({
    required this.amount,
    required this.storeName,
    required this.date,
    required this.category,
    required this.categoryConfidence,
    required this.items,
    required this.tax,
    required this.discount,
    this.paymentMethod,
    this.memo,
  });

  final int amount;
  final String storeName;
  final String date;
  final String category;
  final double categoryConfidence;
  final List<ReceiptItem> items;
  final int tax;
  final int discount;
  final String? paymentMethod;
  final String? memo;

  factory PremiumOcrResult.fromJson(Map<String, dynamic> json) {
    return PremiumOcrResult(
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      storeName: json['storeName'] as String? ?? '',
      date: json['date'] as String? ?? '',
      category: json['category'] as String? ?? 'other',
      categoryConfidence: (json['categoryConfidence'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ReceiptItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tax: (json['tax'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toInt() ?? 0,
      paymentMethod: json['paymentMethod'] as String?,
      memo: json['memo'] as String?,
    );
  }
}

class PremiumOcrService {
  /// Calls the Cloud Functions parseReceipt endpoint.
  /// Returns null on any error (caller should fall back to local result).
  Future<PremiumOcrResult?> parseReceipt(String rawText, String locale) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final idToken = await user.getIdToken();
      if (idToken == null) return null;

      final response = await http
          .post(
            Uri.parse(ApiConfig.parseReceiptUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
            },
            body: jsonEncode({
              'rawText': rawText,
              'locale': locale,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        debugPrint('Premium OCR failed: ${response.statusCode} ${response.body}');
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PremiumOcrResult.fromJson(json);
    } catch (e) {
      debugPrint('Premium OCR error: $e');
      return null;
    }
  }
}
