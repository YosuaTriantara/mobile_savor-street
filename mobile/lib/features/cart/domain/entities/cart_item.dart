import 'menu_entity.dart';
import 'opsi_entity.dart';

class CartItem {
  final String id;
  final MenuEntity menu;
  final int jumlah;
  final String catatan;
  final List<OpsiEntity> selectedOpsi;

  const CartItem({
    required this.id,
    required this.menu,
    required this.jumlah,
    this.catatan = '',
    this.selectedOpsi = const [],
  });

  int get hargaSatuan =>
      menu.harga + selectedOpsi.fold(0, (sum, o) => sum + o.hargaTambahan);

  int get subtotal => hargaSatuan * jumlah;

  String get customLabel => selectedOpsi.isNotEmpty
      ? selectedOpsi.map((o) => o.namaOpsi).join(', ')
      : catatan;

  CartItem copyWith({
    int? jumlah,
    String? catatan,
    List<OpsiEntity>? selectedOpsi,
  }) {
    return CartItem(
      id: id,
      menu: menu,
      jumlah: jumlah ?? this.jumlah,
      catatan: catatan ?? this.catatan,
      selectedOpsi: selectedOpsi ?? this.selectedOpsi,
    );
  }
}
