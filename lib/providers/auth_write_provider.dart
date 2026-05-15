import 'package:flutter_finance_web/providers/api_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_finance_web/providers/auth_provider.dart';

part 'auth_write_provider.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  // Ação de Login
  Future<bool> login(String email, String password) async {
    final authService = ref.read(authServiceProvider);
    state = const AsyncValue.loading();
    try {
      final result = await authService.login(email, password);
      ref.invalidate(fetchUserProvider); // Limpa o cache do usuário antigo
      state = const AsyncValue.data(null);
      return result != null;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  // Ação de Cadastro
  Future<bool> register(String name, String email, String password) async {
    final authService = ref.read(authServiceProvider);
    state = const AsyncValue.loading();
    try {
      await authService.register(name, email, password);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  // Ação de Esqueci Senha
  Future<void> recoverPassword(String email) async {
    final authService = ref.read(authServiceProvider);
    state = const AsyncValue.loading();
    try {
      await authService.forgotPassword(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
