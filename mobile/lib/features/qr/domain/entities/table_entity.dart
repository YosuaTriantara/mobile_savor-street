/// Data meja hasil validasi token QR dari backend
/// (`GET /tables/validate?token=`).
class TableEntity {
  final int idMeja;
  final String nomorMeja;
  final String status;

  const TableEntity({
    required this.idMeja,
    required this.nomorMeja,
    required this.status,
  });

  factory TableEntity.fromJson(Map<String, dynamic> json) {
    return TableEntity(
      idMeja: json['id_meja'] as int,
      nomorMeja: json['nomor_meja'] as String,
      status: json['status'] as String,
    );
  }
}
