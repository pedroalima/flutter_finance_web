import 'package:dio/dio.dart';

class TransactionService {
  final Dio _dio;

  TransactionService(this._dio);

  Future<List<dynamic>> getTransactions() async {
    try {
      final response = await _dio.get('/transactions');
      return response.data['data'];
    } catch (e) {
      rethrow;
    }
  }
}
