import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';

class QrRemoteDatasource {
  final Dio _dio;

  QrRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> validateToken(String token) async {
    final response = await _dio.get(ApiEndpoints.tableValidate(token));
    return response.data['data'] as Map<String, dynamic>;
  }
}
