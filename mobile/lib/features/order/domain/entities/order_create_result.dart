import 'order_status.dart';

class OrderCreateResult {
  final int idPemesanan;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderCreateResult({
    required this.idPemesanan,
    required this.status,
    required this.createdAt,
  });

  factory OrderCreateResult.fromJson(Map<String, dynamic> json) {
    return OrderCreateResult(
      idPemesanan: json['id_pemesanan'] as int,
      status: OrderStatus.fromApi(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
