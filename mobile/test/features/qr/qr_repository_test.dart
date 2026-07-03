import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mobile/features/qr/data/datasources/qr_remote_datasource.dart';
import 'package:mobile/features/qr/data/repositories/qr_repository.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('QrRepository.validateToken', () {
    test('mem-parse response backend menjadi TableEntity', () async {
      final dio = MockDio();
      when(() => dio.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tables/validate'),
          statusCode: 200,
          data: {
            'success': true,
            'message': 'QR berhasil divalidasi',
            'data': {'id_meja': 1, 'nomor_meja': '01', 'status': 'active'},
          },
        ),
      );

      final repository = QrRepository(QrRemoteDatasource(dio));
      final table = await repository.validateToken('tok-123');

      expect(table.idMeja, 1);
      expect(table.nomorMeja, '01');
      expect(table.status, 'active');
      verify(() => dio.get('/tables/validate?token=tok-123')).called(1);
    });

    test('meneruskan DioException saat token tidak valid', () async {
      final dio = MockDio();
      when(() => dio.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tables/validate'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/tables/validate'),
            statusCode: 404,
            data: {
              'success': false,
              'message': 'QR meja tidak ditemukan',
              'errors': {},
            },
          ),
        ),
      );

      final repository = QrRepository(QrRemoteDatasource(dio));

      expect(
        () => repository.validateToken('token-salah'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
