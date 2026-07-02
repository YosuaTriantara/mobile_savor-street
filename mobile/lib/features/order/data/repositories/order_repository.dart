import 'package:dio/dio.dart';

import '../../domain/entities/order_create_result.dart';
import '../../domain/entities/order_detail.dart';
import '../../domain/entities/order_item_request.dart';
import '../../domain/entities/request_bill_result.dart';

class OrderRepository {
  final Dio _dio;

  OrderRepository(this._dio);

  Future<OrderCreateResult> createOrder({
    required int idMeja,
    String? namaPelanggan,
    required List<OrderItemRequest> items,
  }) async {
    final response = await _dio.post('/orders', data: {
      'id_meja': idMeja,
      'nama_pelanggan': namaPelanggan,
      'items': items.map((item) => item.toJson()).toList(),
    });
    return OrderCreateResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<OrderDetail> getOrderDetail(int idPemesanan) async {
    final response = await _dio.get('/orders/$idPemesanan');
    return OrderDetail.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<RequestBillResult> requestBill(int idPemesanan) async {
    final response = await _dio.post('/orders/$idPemesanan/request-bill');
    return RequestBillResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
