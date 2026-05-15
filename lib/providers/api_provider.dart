import 'package:dio/dio.dart';
import 'package:flutter_finance_web/services/auth_service.dart';
import 'package:flutter_finance_web/services/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Provider do Dio com Interceptor
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.18:8080/api',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  const storage = FlutterSecureStorage();

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
});

// Provider do AuthService injetando o Dio
final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthService(dio);
});

// Provider do TransactionService injetando o mesmo Dio
final transactionServiceProvider = Provider<TransactionService>((ref) {
  final dio = ref.watch(dioProvider);
  return TransactionService(dio);
});