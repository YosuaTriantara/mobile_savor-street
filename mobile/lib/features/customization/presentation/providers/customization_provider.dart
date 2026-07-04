import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/customization_repository.dart';
import '../../domain/entities/opsi_entity.dart';
import '../../domain/entities/opsi_group_entity.dart';

final customizationRepositoryProvider =
    Provider<CustomizationRepository>((ref) {
  return CustomizationRepository(ref.read(dioProvider));
});

class CustomizationState {
  final List<OpsiGroupEntity> groups;

  /// Opsi terpilih per grup, key-nya `grupOpsi`. List karena grup
  /// `multiple: true` (topping) bisa punya lebih dari satu opsi aktif.
  final Map<String, List<OpsiEntity>> selected;
  final int quantity;
  final String catatan;
  final bool isLoading;
  final String? error;

  const CustomizationState({
    this.groups = const [],
    this.selected = const {},
    this.quantity = 1,
    this.catatan = '',
    this.isLoading = false,
    this.error,
  });

  CustomizationState copyWith({
    List<OpsiGroupEntity>? groups,
    Map<String, List<OpsiEntity>>? selected,
    int? quantity,
    String? catatan,
    bool? isLoading,
    String? error,
  }) {
    return CustomizationState(
      groups: groups ?? this.groups,
      selected: selected ?? this.selected,
      quantity: quantity ?? this.quantity,
      catatan: catatan ?? this.catatan,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<OpsiEntity> get selectedFlat =>
      selected.values.expand((opsiList) => opsiList).toList();

  int get extraPricePerUnit =>
      selectedFlat.fold(0, (sum, opsi) => sum + opsi.hargaTambahan);

  /// true kalau setiap grup yang `required == true` sudah punya minimal
  /// 1 opsi terpilih. Dipakai buat enable/disable tombol "Tambah ke
  /// Keranjang".
  bool get isValid => groups
      .where((group) => group.required)
      .every((group) => (selected[group.grupOpsi]?.isNotEmpty ?? false));
}

/// Satu notifier per idMenu (family) — supaya pilihan kustomisasi menu A
/// tidak nyampur ke menu B kalau user berpindah menu tanpa keluar total
/// dari alur customize.
class CustomizationNotifier extends FamilyNotifier<CustomizationState, int> {
  @override
  CustomizationState build(int idMenu) {
    Future.microtask(() => _fetchGroups(idMenu));
    return const CustomizationState(isLoading: true);
  }

  Future<void> _fetchGroups(int idMenu) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(customizationRepositoryProvider);
      final groups = await repo.getOptionGroups(idMenu);
      state = CustomizationState(groups: groups, quantity: state.quantity);
    } on DioException catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Gagal memuat opsi kustomisasi.',
      );
    }
  }

  Future<void> retry(int idMenu) => _fetchGroups(idMenu);

  /// Dipanggil saat user tap salah satu opsi di dalam [group].
  /// - `group.multiple == true` (topping): checkbox, toggle on/off, boleh
  ///   lebih dari satu opsi aktif dalam grup yang sama.
  /// - `group.multiple == false` (mis. level pedas/ukuran): radio, pilih
  ///   [opsi] langsung menggantikan pilihan sebelumnya di grup itu.
  void toggleOption(OpsiGroupEntity group, OpsiEntity opsi) {
    final current =
        List<OpsiEntity>.from(state.selected[group.grupOpsi] ?? const []);
    final List<OpsiEntity> updatedForGroup;

    if (group.multiple) {
      final alreadySelected = current.any((o) => o.idOpsi == opsi.idOpsi);
      updatedForGroup = alreadySelected
          ? current.where((o) => o.idOpsi != opsi.idOpsi).toList()
          : [...current, opsi];
    } else {
      updatedForGroup = [opsi];
    }

    final updatedSelected = Map<String, List<OpsiEntity>>.from(state.selected)
      ..[group.grupOpsi] = updatedForGroup;
    state = state.copyWith(selected: updatedSelected);
  }

  void setQuantity(int quantity) {
    if (quantity < 1) return;
    state = state.copyWith(quantity: quantity);
  }

  void setCatatan(String value) {
    state = state.copyWith(catatan: value);
  }
}

final customizationProvider =
    NotifierProvider.family<CustomizationNotifier, CustomizationState, int>(
  CustomizationNotifier.new,
);