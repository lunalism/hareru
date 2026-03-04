import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hareru/config/revenue_cat_config.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  RevenueCatService._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    final apiKey =
        Platform.isIOS ? RevenueCatConfig.appleApiKey : RevenueCatConfig.googleApiKey;

    final configuration = PurchasesConfiguration(apiKey);
    await Purchases.configure(configuration);
    _initialized = true;

    final appUserId = await Purchases.appUserID;
    debugPrint('[RevenueCat] initialized');
    debugPrint('[RevenueCat] appUserID: $appUserId');
  }

  static Future<void> login(String userId) async {
    try {
      final info = await Purchases.getCustomerInfo();
      if (info.originalAppUserId == userId) return;
      await Purchases.logIn(userId);
      debugPrint('[RevenueCat] logged in as $userId');
    } catch (e) {
      debugPrint('[RevenueCat] login error: $e');
    }
  }

  static Future<void> logout() async {
    try {
      final isAnonymous = await Purchases.isAnonymous;
      if (isAnonymous) return;
      await Purchases.logOut();
      debugPrint('[RevenueCat] logged out');
    } catch (e) {
      debugPrint('[RevenueCat] logout error: $e');
    }
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    return Purchases.getCustomerInfo();
  }

  static Future<CustomerInfo> purchasePackage(Package package) async {
    return Purchases.purchasePackage(package);
  }

  static Future<CustomerInfo> restorePurchases() async {
    return Purchases.restorePurchases();
  }

  static Future<Offerings> getOfferings() async {
    return Purchases.getOfferings();
  }
}
