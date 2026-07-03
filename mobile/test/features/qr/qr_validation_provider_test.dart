import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/core/network/app_exception.dart';
import 'package:mobile/core/session/table_session.dart';
import 'package:mobile/features/qr/data/repositories/qr_repository.dart';
import 'package:mobile/features/qr/domain/entities/table_entity.dart';
import 'package:mobile/features/qr/presentation/providers/qr_validation_provider.dart';

class MockQrRepository extends Mock implements QrRepository {}

void main() {
  ProviderContainer makeContainer(QrRepository repository) {
    final container = ProviderContainer(
      overrides: [qrRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('QrValidationNotifier', () {
    test('validate sukses → table session dibuat, tanpa error', () async {
      final repository = MockQrRepository();
      when(() => repository.validateToken('tok')).thenAnswer(
        (_) async =>
            const TableEntity(idMeja: 2, nomorMeja: '02', status: 'active'),
      );
      final container = makeContainer(repository);

      final success =
          await container.read(qrValidationProvider.notifier).validate('tok');

      expect(success, true);
      expect(container.read(tableSessionStateProvider)?.idMeja, 2);
      expect(container.read(tableSessionStateProvider)?.nomorMeja, '02');
      expect(container.read(qrValidationProvider).errorMessage, null);
      expect(container.read(qrValidationProvider).isValidating, false);
    });

    test('validate gagal (404) → pesan error dari backend, session tetap null',
        () async {
      final repository = MockQrRepository();
      when(() => repository.validateToken('bad')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tables/validate'),
          error: const AppException(
            message: 'QR meja tidak ditemukan',
            type: AppExceptionType.notFound,
            statusCode: 404,
          ),
        ),
      );
      final container = makeContainer(repository);

      final success =
          await container.read(qrValidationProvider.notifier).validate('bad');

      expect(success, false);
      expect(container.read(tableSessionStateProvider), null);
      expect(
        container.read(qrValidationProvider).errorMessage,
        'QR meja tidak ditemukan',
      );
    });

    test('markInvalidQr → pesan QR tidak dikenali', () {
      final container = makeContainer(MockQrRepository());

      container.read(qrValidationProvider.notifier).markInvalidQr();

      expect(
        container.read(qrValidationProvider).errorMessage,
        contains('QR tidak dikenali'),
      );
    });
  });

  group('tableSessionProvider (derived)', () {
    test('melempar StateError sebelum scan QR', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(() => container.read(tableSessionProvider), throwsStateError);
    });

    test('mengembalikan session setelah notifier di-start', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(tableSessionStateProvider.notifier)
          .start(idMeja: 3, nomorMeja: '03');

      expect(container.read(tableSessionProvider).idMeja, 3);
      expect(container.read(tableSessionProvider).nomorMeja, '03');
    });
  });
}
