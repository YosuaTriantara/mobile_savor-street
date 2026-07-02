/// Temporary stub matching backend/app/schemas/menu.py::MenuListItem.
/// Anggota 3 will publish the real MenuEntity under
/// features/menu/domain/entities/ — once that lands, delete this file and
/// repoint the import in cart_item.dart. Field names must stay identical.
class MenuEntity {
  final int idMenu;
  final String namaMenu;
  final int harga;
  final String kategori;
  final String? gambarMenu;
  final String status;

  const MenuEntity({
    required this.idMenu,
    required this.namaMenu,
    required this.harga,
    required this.kategori,
    this.gambarMenu,
    required this.status,
  });
}
