import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  // Se estiver no emulador Android, use 10.0.2.2. Se for iOS/Web, use localhost.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.18:8080/api',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      print("Enviando login para: ${_dio.options.baseUrl}/auth/login");
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        String token = data['token'];

        await _storage.write(key: 'auth_token', value: token);

        _dio.options.headers['Authorization'] = 'Bearer $token';

        print("Token salvo com sucesso!");
        return data;
      }
    } on DioException catch (e) {
      // Aqui você trata erros de validação do Laravel (422)
      print("Erro no login: ${e.response?.data['message']}");
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
