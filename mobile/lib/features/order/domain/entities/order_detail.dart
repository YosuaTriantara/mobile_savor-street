import 'order_item_detail.dart';
import 'order_status.dart';

class OrderDetail {
  final int idPemesanan;
  final String nomorMeja;
  final String? namaPelanggan;
  final OrderStatus status;
  final DateTime tanggalPemesanan;
  final List<OrderItemDetail> items;

  const OrderDetail({
    required this.idPemesanan,
    required this.nomorMeja,
    this.namaPelanggan,
    required this.status,
    required this.tanggalPemesanan,
    required this.items,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      idPemesanan: json['id_pemesanan'] as int,
      nomorMeja: json['nomor_meja'] as String,
      namaPelanggan: json['nama_pelanggan'] as String?,
      status: OrderStatus.fromApi(json['status'] as String),
      tanggalPemesanan: DateTime.parse(json['tanggal_pemesanan'] as String),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
