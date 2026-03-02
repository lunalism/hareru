import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/config/revenue_cat_config.dart';
import 'package:hareru/core/services/revenue_cat_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

enum SubscriptionTier { free, clear, clearPro }

class SubscriptionState {
  const SubscriptionState({
    this.tier = SubscriptionTier.free,
    this.isLoading = false,
    this.error,
    this.expirationDate,
    this.willRenew = false,
  });

  final SubscriptionTier tier;
  final bool isLoading;
  final String? error;
  final DateTime? expirationDate;
  final bool willRenew;

  SubscriptionState copyWith({
    SubscriptionTier? tier,
    bool? isLoading,
    String? error,
    DateTime? expirationDate,
    bool? willRenew,
  }) {
    return SubscriptionState(
      tier: tier ?? this.tier,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      expirationDate: expirationDate ?? this.expirationDate,
      willRenew: willRenew ?? this.willRenew,
    );
  }
}

extension SubscriptionCheck on SubscriptionState {
  bool get isFree => tier == SubscriptionTier.free;
  bool get isClear =>
      tier == SubscriptionTier.clear || tier == SubscriptionTier.clearPro;
  bool get isClearPro => tier == SubscriptionTier.clearPro;
  bool get canUseAiInsight => isClear;
  bool get canUseAiCoaching => isClearPro;
  bool get canExportPdf => isClearPro;
  bool get canExportCsv => isClear;
  bool get showAds => isFree;
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true);
    try {
      final info = await RevenueCatService.getCustomerInfo();
      _updateFromCustomerInfo(info);
    } catch (e) {
      debugPrint('[Subscription] load error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _updateFromCustomerInfo(CustomerInfo info) {
    SubscriptionTier tier;
    if (info.entitlements.active
        .containsKey(RevenueCatConfig.clearProEntitlement)) {
      tier = SubscriptionTier.clearPro;
    } else if (info.entitlements.active
        .containsKey(RevenueCatConfig.clearEntitlement)) {
      tier = SubscriptionTier.clear;
    } else {
      tier = SubscriptionTier.free;
    }

    DateTime? expirationDate;
    bool willRenew = false;

    final activeEntitlement = info.entitlements.active.values.firstOrNull;
    if (activeEntitlement != null) {
      final expStr = activeEntitlement.expirationDate;
      if (expStr != null) {
        expirationDate = DateTime.tryParse(expStr);
      }
      willRenew = activeEntitlement.willRenew;
    }

    state = SubscriptionState(
      tier: tier,
      expirationDate: expirationDate,
      willRenew: willRenew,
    );
  }

  Future<void> purchase(Package package) async {
    state = state.copyWith(isLoading: true);
    try {
      final info = await RevenueCatService.purchasePackage(package);
      _updateFromCustomerInfo(info);
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        state = state.copyWith(isLoading: false);
        return;
      }
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }

  Future<void> restore() async {
    state = state.copyWith(isLoading: true);
    try {
      final info = await RevenueCatService.restorePurchases();
      _updateFromCustomerInfo(info);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> refresh() async {
    try {
      final info = await RevenueCatService.getCustomerInfo();
      _updateFromCustomerInfo(info);
    } catch (e) {
      debugPrint('[Subscription] refresh error: $e');
    }
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(),
);
