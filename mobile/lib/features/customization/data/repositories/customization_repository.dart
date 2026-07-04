import 'package:dio/dio.dart';

import '../../domain/entities/opsi_group_entity.dart';

/// Data layer untuk opsi kustomisasi.
///
/// SENGAJA memanggil endpoint yang sama dengan
/// `MenuRepository.getMenuDetail` (`GET /menus/{id_menu}`) secara
/// independen, alih-alih menerima data dari features/menu — supaya batas
/// antar-feature tetap bersih (lihat catatan desain di
/// `features/menu/domain/entities/menu_detail_entity.dart`).
///
/// Konsekuensinya: saat user buka Detail lalu lanjut ke Customization,
/// terjadi 2x network call ke endpoint yang sama. Ini trade-off yang
/// sudah didiskusikan tim, bisa dioptimasi belakangan (mis. cache
/// berdasarkan idMenu) kalau memang jadi masalah performa nyata.
///
/// Error (DioException) sengaja TIDAK ditangkap di sini, mengikuti pola
/// MenuRepository — dibiarkan mengalir ke provider layer.
class CustomizationRepository {
  final Dio _dio;

  CustomizationRepository(this._dio);

  Future<List<OpsiGroupEntity>> getOptionGroups(int idMenu) async {
    final response = await _dio.get('/menus/$idMenu');
    final data = response.data['data'] as Map<String, dynamic>;
    final options = data['options'] as List<dynamic>? ?? [];
    return options
        .map((item) => OpsiGroupEntity.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}