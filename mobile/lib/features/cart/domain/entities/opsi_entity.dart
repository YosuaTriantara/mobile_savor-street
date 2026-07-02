/// Temporary stub matching backend/app/schemas/menu.py::MenuOptionItem.
/// Anggota 3 owns the real OpsiEntity under features/customization/ — once
/// that lands, delete this file and repoint the import in cart_item.dart.
class OpsiEntity {
  final int idOpsi;
  final String namaOpsi;
  final int hargaTambahan;

  const OpsiEntity({
    required this.idOpsi,
    required this.namaOpsi,
    required this.hargaTambahan,
  });
}
