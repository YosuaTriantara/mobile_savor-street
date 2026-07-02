class OrderOptionDetail {
  final String namaOpsi;
  final int hargaTambahan;

  const OrderOptionDetail({required this.namaOpsi, required this.hargaTambahan});

  factory OrderOptionDetail.fromJson(Map<String, dynamic> json) {
    return OrderOptionDetail(
      namaOpsi: json['nama_opsi'] as String,
      hargaTambahan: json['harga_tambahan'] as int,
    );
  }
}

class OrderItemDetail {
  final String namaMenu;
  final int jumlah;
  final int hargaSatuan;
  final int subtotal;
  final String catatan;
  final List<OrderOptionDetail> opsi;

  const OrderItemDetail({
    required this.namaMenu,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
    this.catatan = '',
    this.opsi = const [],
  });

  factory OrderItemDetail.fromJson(Map<String, dynamic> json) {
    return OrderItemDetail(
      namaMenu: json['nama_menu'] as String,
      jumlah: json['jumlah'] as int,
      hargaSatuan: json['harga_satuan'] as int,
      subtotal: json['subtotal'] as int,
      catatan: (json['catatan'] as String?) ?? '',
      opsi: (json['opsi'] as List<dynamic>? ?? [])
          .map((e) => OrderOptionDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
