import 'menu_entity.dart';

/// Entitas untuk layar Menu Detail (route `/menu/:id`).
///
/// Memperluas [MenuEntity] dengan `deskripsi`, sesuai
/// backend/app/schemas/menu.py::MenuDetail.
///
/// Catatan desain: response GET /menus/{id_menu} dari backend sebenarnya
/// juga membawa field "options" (opsi kustomisasi), tapi entity ini
/// SENGAJA tidak memparsingnya. Opsi kustomisasi adalah tanggung jawab
/// domain features/customization (lihat OpsiEntity di sana), yang akan
/// memanggil endpoint yang sama secara independen untuk menjaga batas
/// antar-feature tetap bersih. Konsekuensinya: layar yang menampilkan
/// detail + kustomisasi sekaligus (Gambar 6) akan melakukan 2x network
/// call ke endpoint yang sama — trade-off yang sudah didiskusikan ke tim,
/// bisa dioptimasi belakangan kalau perlu.
class MenuDetailEntity extends MenuEntity {
  final String? deskripsi;

  const MenuDetailEntity({
    required super.idMenu,
    required super.namaMenu,
    required super.harga,
    required super.kategori,
    super.gambarMenu,
    required super.status,
    this.deskripsi,
  });

  factory MenuDetailEntity.fromJson(Map<String, dynamic> json) {
    return MenuDetailEntity(
      idMenu: json['id_menu'] as int,
      namaMenu: json['nama_menu'] as String,
      harga: json['harga'] as int,
      kategori: json['kategori'] as String,
      gambarMenu: json['gambar_menu'] as String?,
      status: json['status'] as String,
      deskripsi: json['deskripsi'] as String?,
    );
  }
}
