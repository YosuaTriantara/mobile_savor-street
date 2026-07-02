import '../../../order/domain/entities/order_item_detail.dart';
import 'invoice_status.dart';

class InvoiceDetail {
  final int idInvoice;
  final int idPemesanan;
  final String nomorMeja;
  final String? namaPelanggan;
  final InvoiceStatus status;
  final int totalHarga;
  final List<OrderItemDetail> items;
  final DateTime createdAt;

  const InvoiceDetail({
    required this.idInvoice,
    required this.idPemesanan,
    required this.nomorMeja,
    this.namaPelanggan,
    required this.status,
    required this.totalHarga,
    required this.items,
    required this.createdAt,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceDetail(
      idInvoice: json['id_invoice'] as int,
      idPemesanan: json['id_pemesanan'] as int,
      nomorMeja: json['nomor_meja'] as String,
      namaPelanggan: json['nama_pelanggan'] as String?,
      status: InvoiceStatus.fromApi(json['status'] as String),
      totalHarga: json['total_harga'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
