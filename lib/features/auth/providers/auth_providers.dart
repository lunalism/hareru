import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull != null;
});

final userProfileProvider =
    Provider<({String? displayName, String? email, String? photoUrl, String? providerId})>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) {
    return (displayName: null, email: null, photoUrl: null, providerId: null);
  }
  final providerData = user.providerData;
  final providerId = providerData.isNotEmpty ? providerData.first.providerId : null;
  return (
    displayName: user.displayName,
    email: user.email,
    photoUrl: user.photoURL,
    providerId: providerId,
  );
});
