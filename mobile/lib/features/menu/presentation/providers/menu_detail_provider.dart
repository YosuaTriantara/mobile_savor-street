import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/menu_detail_entity.dart';
import 'menu_provider.dart' show menuRepositoryProvider;

class MenuDetailState {
  final MenuDetailEntity? menu;
  final bool isLoading;
  final String? error;

  const MenuDetailState({this.menu, this.isLoading = false, this.error});
}

/// Satu notifier per idMenu (family) untuk layar Menu Detail (route
/// `/menu/:idMenu`). Reuse `menuRepositoryProvider` yang sudah ada di
/// menu_provider.dart, jadi tidak ada Dio/repository baru di sini.
class MenuDetailNotifier extends FamilyNotifier<MenuDetailState, int> {
  @override
  MenuDetailState build(int idMenu) {
    Future.microtask(() => _fetch(idMenu));
    return const MenuDetailState(isLoading: true);
  }

  Future<void> _fetch(int idMenu) async {
    state = const MenuDetailState(isLoading: true);
    try {
      final repo = ref.read(menuRepositoryProvider);
      final menu = await repo.getMenuDetail(idMenu);
      state = MenuDetailState(menu: menu);
    } on DioException catch (_) {
      state = const MenuDetailState(error: 'Gagal memuat detail menu.');
    }
  }

  Future<void> retry(int idMenu) => _fetch(idMenu);
}

final menuDetailProvider =
    NotifierProvider.family<MenuDetailNotifier, MenuDetailState, int>(
  MenuDetailNotifier.new,
);