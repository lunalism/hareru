import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../repositories/transaction_repository.dart';
import 'firestore_service.dart';

class MigrationService {
  MigrationService(this._firestoreService, this._transactionRepo);

  final FirestoreService _firestoreService;
  final TransactionRepository _transactionRepo;

  Box get _settingsBox => Hive.box('settings');

  bool get hasMigrated => _settingsBox.get('hasMigrated', defaultValue: false) as bool;

  Future<void> migrateAll({required void Function(String) onProgress}) async {
    if (hasMigrated) return;

    // Migrate transactions
    final transactions = _transactionRepo.getAll();
    if (transactions.isNotEmpty) {
      onProgress('${transactions.length}');
      await _firestoreService.batchWriteTransactions(transactions);
    }

    // Migrate settings
    final settingsBox = _settingsBox;
    final settingsData = <String, dynamic>{};
    for (final key in settingsBox.keys) {
      if (key == 'hasSeenLogin' || key == 'hasMigrated') continue;
      settingsData[key as String] = settingsBox.get(key);
    }
    if (settingsData.isNotEmpty) {
      await _firestoreService.saveSettings(settingsData);
    }

    // Mark as migrated
    await _settingsBox.put('hasMigrated', true);
  }
}

final migrationServiceProvider = Provider<MigrationService>((ref) {
  return MigrationService(
    ref.watch(firestoreServiceProvider),
    ref.watch(transactionRepositoryProvider),
  );
});
