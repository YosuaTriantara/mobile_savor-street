import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_entity.dart';
import '../../domain/entities/opsi_entity.dart';

/// cart/ has no API datasource — it's pure in-memory local state, held here
/// instead of a datasource layer since there is nothing to fetch from.
class CartRepository {
  final List<CartItem> _items = [];

  List<CartItem> getItems() => List.unmodifiable(_items);

  void addItem({
    required MenuEntity menu,
    required int jumlah,
    String catatan = '',
    List<OpsiEntity> selectedOpsi = const [],
  }) {
    final id = '${menu.idMenu}-${DateTime.now().microsecondsSinceEpoch}';
    _items.add(CartItem(
      id: id,
      menu: menu,
      jumlah: jumlah,
      catatan: catatan,
      selectedOpsi: selectedOpsi,
    ));
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.id == cartItemId);
  }

  void updateQuantity(String cartItemId, int jumlah) {
    final index = _items.indexWhere((item) => item.id == cartItemId);
    if (index == -1) return;
    if (jumlah <= 0) {
      _items.removeAt(index);
      return;
    }
    _items[index] = _items[index].copyWith(jumlah: jumlah);
  }

  void clear() => _items.clear();
}
