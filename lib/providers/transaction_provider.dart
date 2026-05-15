import 'package:flutter_finance_web/providers/api_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

@riverpod
Future<List<Map<String, dynamic>>> getTransactions(Ref ref) async {
  final transactionService = ref.watch(transactionServiceProvider);
  final response = await transactionService.getTransactions();
  return response.cast<Map<String, dynamic>>();
}
