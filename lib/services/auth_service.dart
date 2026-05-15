import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final Dio _dio;

  AuthService(this._dio);

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        String token = data['token'];
        await _storage.write(key: 'auth_token', value: token);
        return data;
      }
    } on DioException catch (e) {
      // Aqui você trata erros de validação do Laravel (422)
      print("Erro no login: ${e.response?.data['message']}");
      rethrow;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUser() async {
    try {
      final response = await _dio.get('/user/me');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Erro ao buscar usuário: ${e.response?.data['message']}");
      rethrow;
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _dio.options.headers.remove('Authorization');
  }

  Future<Map<String, dynamic>?> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/users', // No Laravel, a rota de criação geralmente é POST /users
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioException catch (e) {
      print("Erro no cadastro: ${e.response?.data}");
      rethrow;
    }
    return null;
  }

  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        '/auth/forgot-password', // Crie esta rota no seu api.php
        data: {'email': email},
      );
      return response.data['message'];
    } on DioException catch (e) {
      String error =
          e.response?.data['message'] ?? "Erro ao processar solicitação";
      throw error;
    }
  }
}
