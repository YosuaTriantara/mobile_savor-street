/// Entitas resmi untuk satu opsi kustomisasi (mis. "Level Pedas: Sedang",
/// atau salah satu topping).
///
/// Menggantikan stub sementara di
/// `features/cart/domain/entities/opsi_entity.dart` (lihat komentar di file
/// itu — stub tersebut sengaja dibuat identik field-nya supaya nanti tinggal
/// diganti). Field & `fromJson` mengikuti
/// `backend/app/schemas/menu.py::MenuOptionItem` persis.
class OpsiEntity {
  final int idOpsi;
  final String namaOpsi;
  final int hargaTambahan;

  const OpsiEntity({
    required this.idOpsi,
    required this.namaOpsi,
    required this.hargaTambahan,
  });

  factory OpsiEntity.fromJson(Map<String, dynamic> json) {
    return OpsiEntity(
      idOpsi: json['id_opsi'] as int,
      namaOpsi: json['nama_opsi'] as String,
      hargaTambahan: json['harga_tambahan'] as int,
    );
  }
}