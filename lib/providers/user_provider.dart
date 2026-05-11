import 'package:flutter_finance_web/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> fetchUser(Ref ref) async {
  final authService = AuthService();
  final response = await authService.getUser();
  return response!;
}
