/// Entitas resmi untuk item menu (list item).
///
/// PENTING: Field & nama ini menggantikan stub sementara di
/// features/cart/domain/entities/menu_entity.dart. Jangan ubah nama/urutan
/// field di bawah tanpa koordinasi ke pemegang fitur Cart — CartItem
/// bergantung pada bentuk MenuEntity ini persis seperti ini.
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

  /// Parsing dari response backend (snake_case) sesuai
  /// backend/app/schemas/menu.py::MenuListItem.
  factory MenuEntity.fromJson(Map<String, dynamic> json) {
    return MenuEntity(
      idMenu: json['id_menu'] as int,
      namaMenu: json['nama_menu'] as String,
      harga: json['harga'] as int,
      kategori: json['kategori'] as String,
      gambarMenu: json['gambar_menu'] as String?,
      status: json['status'] as String,
    );
  }

  /// true jika status backend == "available".
  bool get isAvailable => status == 'available';
}