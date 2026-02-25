import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _key = 'transfer_accounts_v2';

enum AccountType { checking, savings, investment }

class UserAccount {
  final String id;
  final String name;
  final AccountType type;

  const UserAccount({
    required this.id,
    required this.name,
    required this.type,
  });

  String get displayLabel => '$name ${_typeLabel(type)}';

  static String _typeLabel(AccountType t) => switch (t) {
        AccountType.checking => '普通',
        AccountType.savings => '貯金',
        AccountType.investment => '証券',
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'] as String,
        name: json['name'] as String,
        type: AccountType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => AccountType.checking,
        ),
      );
}

class TransferAccountNotifier extends StateNotifier<List<UserAccount>> {
  TransferAccountNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    final saved = box.get(_key) as String?;
    if (saved != null) {
      final list = (jsonDecode(saved) as List<dynamic>)
          .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
    }
  }

  Future<void> addAccount(String name, AccountType type) async {
    if (name.trim().isEmpty) return;
    final account = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      type: type,
    );
    final updated = [...state, account];
    state = updated;
    await _persist(updated);
  }

  Future<void> removeAccount(String id) async {
    final updated = state.where((a) => a.id != id).toList();
    state = updated;
    await _persist(updated);
  }

  Future<void> _persist(List<UserAccount> accounts) async {
    final box = await Hive.openBox<dynamic>(_boxName);
    await box.put(_key, jsonEncode(accounts.map((a) => a.toJson()).toList()));
  }
}

final transferAccountProvider =
    StateNotifierProvider<TransferAccountNotifier, List<UserAccount>>(
  (ref) => TransferAccountNotifier(),
);
