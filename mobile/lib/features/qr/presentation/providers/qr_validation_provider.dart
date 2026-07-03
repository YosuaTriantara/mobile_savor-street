import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/session/table_session.dart';
import '../../data/datasources/qr_remote_datasource.dart';
import '../../data/repositories/qr_repository.dart';

final qrRemoteDatasourceProvider = Provider<QrRemoteDatasource>((ref) {
  return QrRemoteDatasource(ref.read(dioProvider));
});

final qrRepositoryProvider = Provider<QrRepository>((ref) {
  return QrRepository(ref.read(qrRemoteDatasourceProvider));
});

class QrValidationState {
  final bool isValidating;
  final String? errorMessage;

  const QrValidationState({this.isValidating = false, this.errorMessage});
}

class QrValidationNotifier extends Notifier<QrValidationState> {
  @override
  QrValidationState build() => const QrValidationState();

  /// Validasi token ke backend. Jika valid, table session dibuat dan
  /// return true supaya screen bisa lanjut navigasi ke menu.
  Future<bool> validate(String token) async {
    if (state.isValidating) return false;
    state = const QrValidationState(isValidating: true);

    try {
      final table = await ref.read(qrRepositoryProvider).validateToken(token);
      ref.read(tableSessionStateProvider.notifier).start(
            idMeja: table.idMeja,
            nomorMeja: table.nomorMeja,
          );
      state = const QrValidationState();
      return true;
    } on DioException catch (e) {
      final appException = e.error;
      state = QrValidationState(
        errorMessage: appException is AppException
            ? appException.message
            : 'Terjadi kesalahan, coba lagi.',
      );
      return false;
    }
  }

  /// Dipanggil saat isi QR tidak bisa di-parse menjadi token.
  void markInvalidQr() {
    state = const QrValidationState(
      errorMessage: 'QR tidak dikenali. Pastikan scan QR resmi Savor Street.',
    );
  }

  void reset() => state = const QrValidationState();
}

final qrValidationProvider =
    NotifierProvider<QrValidationNotifier, QrValidationState>(
        QrValidationNotifier.new);
