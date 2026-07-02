import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/cart_repository.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_summary.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/opsi_entity.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) => CartRepository());

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => ref.read(cartRepositoryProvider).getItems();

  void addItem({
    required MenuEntity menu,
    required int jumlah,
    String catatan = '',
    List<OpsiEntity> selectedOpsi = const [],
  }) {
    final repo = ref.read(cartRepositoryProvider);
    repo.addItem(
      menu: menu,
      jumlah: jumlah,
      catatan: catatan,
      selectedOpsi: selectedOpsi,
    );
    state = repo.getItems();
  }

  void removeItem(String cartItemId) {
    final repo = ref.read(cartRepositoryProvider);
    repo.removeItem(cartItemId);
    state = repo.getItems();
  }

  void updateQuantity(String cartItemId, int jumlah) {
    final repo = ref.read(cartRepositoryProvider);
    repo.updateQuantity(cartItemId, jumlah);
    state = repo.getItems();
  }

  void clear() {
    ref.read(cartRepositoryProvider).clear();
    state = [];
  }
}

final cartItemsProvider = NotifierProvider<CartNotifier, List<CartItem>>(CartNotifier.new);

final cartSummaryProvider = Provider<CartSummary>((ref) {
  final items = ref.watch(cartItemsProvider);
  final totalItem = items.fold<int>(0, (sum, item) => sum + item.jumlah);
  final totalHarga = items.fold<int>(0, (sum, item) => sum + item.subtotal);
  return CartSummary(totalItem: totalItem, totalHarga: totalHarga);
});
