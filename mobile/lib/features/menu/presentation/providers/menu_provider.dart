import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/menu_repository.dart';
import '../../domain/entities/menu_entity.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  return MenuRepository(ref.read(dioProvider));
});

class MenuState {
  final List<MenuEntity> menus;
  final String? category;
  final String searchQuery;
  final bool isLoading;
  final String? error;

  const MenuState({
    this.menus = const [],
    this.category,
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });
}

/// Mengelola daftar menu untuk Menu List Screen (Gambar 4 & 5).
///
/// Sengaja TIDAK melakukan fetch otomatis di `build()`. Pemuatan awal
/// dipicu oleh CategoryNotifier begitu kategori pertama berhasil diambil
/// dan dipilih (lihat category_provider.dart) — supaya tidak terjadi
/// double-fetch (sekali unfiltered saat init, lalu sekali lagi ter-filter
/// begitu kategori default terpilih).
class MenuNotifier extends Notifier<MenuState> {
  @override
  MenuState build() => const MenuState(isLoading: true);

  /// Dipanggil oleh CategoryNotifier saat kategori aktif berubah
  /// (termasuk pemilihan kategori default pertama kali).
  Future<void> filterByCategory(String category) async {
    state = MenuState(
      menus: state.menus,
      category: category,
      searchQuery: state.searchQuery,
      isLoading: true,
    );
    await _fetch();
  }

  /// Dipanggil oleh UI saat user mengetik di search bar.
  /// Sebaiknya widget pemanggil melakukan debounce (±300-500ms) sebelum
  /// memanggil method ini, supaya tidak request API di setiap keystroke.
  Future<void> search(String query) async {
    state = MenuState(
      menus: state.menus,
      category: state.category,
      searchQuery: query,
      isLoading: true,
    );
    await _fetch();
  }

  Future<void> _fetch() async {
    try {
      final repo = ref.read(menuRepositoryProvider);
      final menus = await repo.getMenus(
        category: state.category,
        search: state.searchQuery,
      );
      state = MenuState(
        menus: menus,
        category: state.category,
        searchQuery: state.searchQuery,
      );
    } on DioException catch (e) {
      state = MenuState(
        menus: state.menus,
        category: state.category,
        searchQuery: state.searchQuery,
        error: _mapError(e),
      );
    }
  }

  String _mapError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'Gagal memuat menu, coba lagi.';
  }
}

final menuProvider = NotifierProvider<MenuNotifier, MenuState>(MenuNotifier.new);