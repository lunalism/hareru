import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BankProduct {
  final int id;
  final String bankName;
  final String? bankNameKo;
  final String? bankNameEn;
  final String? bankIcon;
  final String productType;
  final double interestRate;
  final int? minAmount;
  final String? periodMin;
  final String? periodMax;
  final String? features;
  final String? featuresKo;
  final String? featuresEn;
  final String? recommendedFor;
  final String? recommendedForKo;
  final String? recommendedForEn;
  final int displayOrder;
  final String dataAsOf;

  BankProduct({
    required this.id,
    required this.bankName,
    this.bankNameKo,
    this.bankNameEn,
    this.bankIcon,
    required this.productType,
    required this.interestRate,
    this.minAmount,
    this.periodMin,
    this.periodMax,
    this.features,
    this.featuresKo,
    this.featuresEn,
    this.recommendedFor,
    this.recommendedForKo,
    this.recommendedForEn,
    this.displayOrder = 0,
    required this.dataAsOf,
  });

  factory BankProduct.fromJson(Map<String, dynamic> json) {
    return BankProduct(
      id: json['id'],
      bankName: json['bank_name'],
      bankNameKo: json['bank_name_ko'],
      bankNameEn: json['bank_name_en'],
      bankIcon: json['bank_icon'],
      productType: json['product_type'],
      interestRate: (json['interest_rate'] as num).toDouble(),
      minAmount: json['min_amount'],
      periodMin: json['period_min'],
      periodMax: json['period_max'],
      features: json['features'],
      featuresKo: json['features_ko'],
      featuresEn: json['features_en'],
      recommendedFor: json['recommended_for'],
      recommendedForKo: json['recommended_for_ko'],
      recommendedForEn: json['recommended_for_en'],
      displayOrder: json['display_order'] ?? 0,
      dataAsOf: json['data_as_of'],
    );
  }

  String getLocalizedName(String locale) {
    switch (locale) {
      case 'ko':
        return bankNameKo ?? bankName;
      case 'en':
        return bankNameEn ?? bankName;
      default:
        return bankName;
    }
  }

  String getLocalizedFeatures(String locale) {
    switch (locale) {
      case 'ko':
        return featuresKo ?? features ?? '';
      case 'en':
        return featuresEn ?? features ?? '';
      default:
        return features ?? '';
    }
  }

  String getLocalizedRecommendedFor(String locale) {
    switch (locale) {
      case 'ko':
        return recommendedForKo ?? recommendedFor ?? '';
      case 'en':
        return recommendedForEn ?? recommendedFor ?? '';
      default:
        return recommendedFor ?? '';
    }
  }
}

final bankProductsProvider = FutureProvider<List<BankProduct>>((ref) async {
  final response = await Supabase.instance.client
      .from('bank_products')
      .select()
      .eq('is_active', true)
      .order('display_order', ascending: true);

  return (response as List)
      .map((json) => BankProduct.fromJson(json))
      .toList();
});
