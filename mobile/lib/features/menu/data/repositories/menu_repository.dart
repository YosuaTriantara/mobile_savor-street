import 'package:dio/dio.dart';

import '../../domain/entities/menu_detail_entity.dart';
import '../../domain/entities/menu_entity.dart';

/// Data layer untuk fitur Menu.
///
/// Mengikuti pola yang sama dengan OrderRepository/InvoiceRepository:
/// menerima Dio lewat constructor, langsung memanggil endpoint, dan
/// mengembalikan Entity hasil parsing `response.data['data']`.
/// Error (DioException) sengaja TIDAK ditangkap di sini — biarkan
/// mengalir ke provider layer, sama seperti OrderNotifier menangani
/// DioException di features/order/presentation/providers/order_provider.dart.
class MenuRepository {
  final Dio _dio;

  MenuRepository(this._dio);

  /// GET /menus/categories
  Future<List<String>> getCategories() async {
    final response = await _dio.get('/menus/categories');
    return (response.data['data'] as List<dynamic>).cast<String>();
  }

  /// GET /menus?category=&search=&sort=
  ///
  /// `sort` valid: price_asc, price_desc, name_asc, name_desc
  /// (lihat backend/app/services/menu_service.py::SORT_MAP).
  Future<List<MenuEntity>> getMenus({
    String? category,
    String? search,
    String? sort,
  }) async {
    final response = await _dio.get('/menus', queryParameters: {
      if (category != null && category.isNotEmpty) 'category': category,
      if (search != null && search.isNotEmpty) 'search': search,
      if (sort != null) 'sort': sort,
    });
    return (response.data['data'] as List<dynamic>)
        .map((item) => MenuEntity.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// GET /menus/{id_menu}
  Future<MenuDetailEntity> getMenuDetail(int idMenu) async {
    final response = await _dio.get('/menus/$idMenu');
    return MenuDetailEntity.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
