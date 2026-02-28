import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hareru/features/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authServiceProvider = Provider((ref) {
  return AuthService(Supabase.instance.client);
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.read(authServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return Supabase.instance.client.auth.currentUser != null;
});
