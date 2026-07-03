import 'package:dio/dio.dart';
import '../app_exception.dart';

/// Mengubah setiap DioException jadi AppException dan menempelkannya
/// ke `error` field, TANPA mengubah tipe exception yang dilempar.
/// Jadi kode lama yang masih `on DioException catch (e)` tetap jalan,
/// tinggal baca `e.error as AppException` untuk pesan yang sudah rapi.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = AppException.fromDioException(err);
    handler.next(err.copyWith(error: appException));
  }
}