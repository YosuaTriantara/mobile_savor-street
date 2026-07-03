import 'package:dio/dio.dart';

enum AppExceptionType {
  network, // tidak ada koneksi internet
  timeout, // request timeout
  badRequest, // 400/422 - validasi
  notFound, // 404
  server, // 5xx
  unknown,
}

/// Representasi error yang seragam untuk seluruh aplikasi.
/// Semua fitur sebaiknya berhenti menulis `_mapError(DioException e)`
/// sendiri-sendiri dan pakai `AppException.fromDioException(e)`.
class AppException implements Exception {
  final String message;
  final AppExceptionType type;
  final int? statusCode;
  final dynamic errors;

  const AppException({
    required this.message,
    required this.type,
    this.statusCode,
    this.errors,
  });

  factory AppException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout: 
        return const AppException(
          message: 'Koneksi timeout, coba lagi.',
          type: AppExceptionType.timeout,
        );

      case DioExceptionType.connectionError:
        return const AppException(
          message: 'Tidak ada koneksi internet.',
          type: AppExceptionType.network,
        );

      case DioExceptionType.badResponse:
        return _fromResponse(e);

      case DioExceptionType.cancel:
        return const AppException(
          message: 'Permintaan dibatalkan.',
          type: AppExceptionType.unknown,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return AppException(
          message: 'Terjadi kesalahan, coba lagi.',
          type: AppExceptionType.unknown,
          errors: e.message,
        );
    }
  }

  static AppException _fromResponse(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;

    String message = 'Terjadi kesalahan, coba lagi.';
    dynamic errors;
    if (data is Map && data['message'] is String) {
      message = data['message'] as String;
    }
    if (data is Map && data.containsKey('errors')) {
      errors = data['errors'];
    }

    final type = switch (statusCode) {
      404 => AppExceptionType.notFound,
      400 || 422 => AppExceptionType.badRequest,
      >= 500 => AppExceptionType.server,
      _ => AppExceptionType.unknown,
    };

    if (type == AppExceptionType.server) {
      message = 'Server sedang bermasalah, coba lagi nanti.';
    }

    return AppException(
      message: message,
      type: type,
      statusCode: statusCode,
      errors: errors,
    );
  }
}
