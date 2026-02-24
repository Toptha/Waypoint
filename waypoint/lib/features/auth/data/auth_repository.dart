import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/user_model.dart';
import '../../../core/utils/supabase_provider.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  
  // Current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Sign Up
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    // 1. Create auth user
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Failed to sign up');
    }

    final userId = response.user!.id;

    // 2. Insert into public.users table (triggering RLS and assigning role)
    final userData = {
      'id': userId,
      'full_name': fullName,
      'role': role,
    };

    final userResponse = await _supabase
        .from('users')
        .insert(userData)
        .select()
        .single();

    return UserModel.fromJson(userResponse);
  }

  // Sign In
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Failed to sign in');
    }

    return await getCurrentUserModel();
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get User Profile
  Future<UserModel> getCurrentUserModel() async {
    final userId = currentUserId;
    if (userId == null) {
      throw Exception('Not authenticated');
    }

    final response = await _supabase
        .from('users')
        .select()
        .eq('id', userId)
        .single();

    return UserModel.fromJson(response);
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}
