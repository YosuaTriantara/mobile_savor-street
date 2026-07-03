import '../../domain/entities/table_entity.dart';
import '../datasources/qr_remote_datasource.dart';

class QrRepository {
  final QrRemoteDatasource _datasource;

  QrRepository(this._datasource);

  /// Validasi token QR ke backend. Melempar DioException (dengan
  /// AppException di field `error`, lihat ErrorInterceptor) saat token
  /// tidak ditemukan (404) atau meja nonaktif (400).
  Future<TableEntity> validateToken(String token) async {
    final data = await _datasource.validateToken(token);
    return TableEntity.fromJson(data);
  }
}
