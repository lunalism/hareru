import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import 'firestore_service.dart';

class SyncService {
  SyncService(this._repo, this._firestoreService);

  final TransactionRepository _repo;
  final FirestoreService _firestoreService;

  bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

  Future<void> add(Transaction t) async {
    await _repo.add(t);
    if (_isLoggedIn) {
      await _firestoreService.saveTransaction(t);
    }
  }

  Future<void> update(Transaction t) async {
    await _repo.update(t);
    if (_isLoggedIn) {
      await _firestoreService.saveTransaction(t);
    }
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    if (_isLoggedIn) {
      await _firestoreService.deleteTransaction(id);
    }
  }

  List<Transaction> getAll() => _repo.getAll();
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref.watch(transactionRepositoryProvider),
    ref.watch(firestoreServiceProvider),
  );
});
