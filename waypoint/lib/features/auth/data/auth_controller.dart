import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../models/user_model.dart';
import 'auth_repository.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() async {
    // Listen to Supabase auth state changes
    ref.watch(authStateChangesProvider);
    
    // Attempt to load current user on initialization
    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUserModel();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).signIn(
        email: email,
        password: password,
      );
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(authRepositoryProvider).signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: role,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(null);
  }
}
