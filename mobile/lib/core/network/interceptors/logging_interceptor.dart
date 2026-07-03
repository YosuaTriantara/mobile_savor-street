import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging ringan, hanya aktif saat debug build.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️  ${options.method} ${options.uri}');
      if (options.data != null) debugPrint('    body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅ ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌ ${err.response?.statusCode} ${err.requestOptions.uri}');
      debugPrint('    ${err.response?.data ?? err.message}');
    }
    handler.next(err);
  }
}