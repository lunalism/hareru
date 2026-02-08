import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart' as app;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  DocumentReference? get _userDoc {
    final uid = _uid;
    if (uid == null) return null;
    return _db.collection('users').doc(uid);
  }

  Future<void> saveProfile(Map<String, dynamic> data) async {
    final doc = _userDoc;
    if (doc == null) return;
    await doc.collection('profile').doc('main').set(data, SetOptions(merge: true));
  }

  Future<void> saveTransaction(app.Transaction t) async {
    final doc = _userDoc;
    if (doc == null) return;
    await doc.collection('transactions').doc(t.id).set(t.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    final doc = _userDoc;
    if (doc == null) return;
    await doc.collection('transactions').doc(id).delete();
  }

  Future<void> batchWriteTransactions(List<app.Transaction> txs) async {
    final doc = _userDoc;
    if (doc == null) return;

    // Firestore batch limit is 500, use 400 for safety
    const batchSize = 400;
    for (var i = 0; i < txs.length; i += batchSize) {
      final batch = _db.batch();
      final chunk = txs.sublist(
        i,
        i + batchSize > txs.length ? txs.length : i + batchSize,
      );
      for (final tx in chunk) {
        final ref = doc.collection('transactions').doc(tx.id);
        batch.set(ref, tx.toMap());
      }
      await batch.commit();
    }
  }

  Future<void> saveSettings(Map<String, dynamic> data) async {
    final doc = _userDoc;
    if (doc == null) return;
    await doc.collection('settings').doc('main').set(data, SetOptions(merge: true));
  }

  Future<void> deleteUserData() async {
    final doc = _userDoc;
    if (doc == null) return;

    // Delete subcollections
    for (final sub in ['transactions', 'settings', 'profile']) {
      final snapshot = await doc.collection(sub).get();
      final batch = _db.batch();
      for (final d in snapshot.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
  }
}

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
