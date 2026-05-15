import 'package:flutter_finance_web/providers/api_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> fetchUser(Ref ref) async {
  final authService = ref.watch(authServiceProvider);
  final response = await authService.getUser();
  return response!;
}
