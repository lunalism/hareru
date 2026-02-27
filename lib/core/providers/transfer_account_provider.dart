import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const _boxName = 'settings';
const _key = 'transfer_accounts_v3';
const _legacyKey = 'transfer_accounts_v2';

class UserAccount {
  final String id;
  final String nickname;
  final String emoji;

  const UserAccount({
    required this.id,
    required this.nickname,
    required this.emoji,
  });

  String get displayLabel => '$emoji $nickname';

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'emoji': emoji,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    // Support legacy format: {name, type} → {nickname, emoji}
    if (json.containsKey('name') && !json.containsKey('nickname')) {
      final legacyType = json['type'] as String? ?? 'checking';
      final legacyEmoji = switch (legacyType) {
        'savings' => '💰',
        'investment' => '📈',
        _ => '🏦',
      };
      return UserAccount(
        id: json['id'] as String,
        nickname: json['name'] as String,
        emoji: legacyEmoji,
      );
    }
    return UserAccount(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      emoji: json['emoji'] as String,
    );
  }
}

class TransferAccountNotifier extends StateNotifier<List<UserAccount>> {
  TransferAccountNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final box = await Hive.openBox<dynamic>(_boxName);
    // Try new key first, fall back to legacy
    var saved = box.get(_key) as String?;
    if (saved == null) {
      saved = box.get(_legacyKey) as String?;
    }
    if (saved != null) {
      final list = (jsonDecode(saved) as List<dynamic>)
          .map((e) => UserAccount.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
      // Persist to new key format
      await _persist(list);
    }
  }

  Future<void> addAccount(String nickname, String emoji) async {
    if (nickname.trim().isEmpty) return;
    final account = UserAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nickname: nickname.trim(),
      emoji: emoji,
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
