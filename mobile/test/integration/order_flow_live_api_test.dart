import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/config/env_config.dart';
import 'package:mobile/features/invoice/data/repositories/invoice_repository.dart';
import 'package:mobile/features/invoice/domain/entities/invoice_status.dart';
import 'package:mobile/features/order/data/repositories/order_repository.dart';
import 'package:mobile/features/order/domain/entities/order_item_request.dart';
import 'package:mobile/features/order/domain/entities/order_status.dart';

/// Hits the real deployed backend (EnvConfig.baseUrl) instead of a mock, so
/// this only runs when explicitly requested:
/// `flutter test test/integration/order_flow_live_api_test.dart`
void main() {
  final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
  final orderRepository = OrderRepository(dio);
  final invoiceRepository = InvoiceRepository(dio);

  test('create order -> request bill -> fetch invoice against live backend', () async {
    final created = await orderRepository.createOrder(
      idMeja: 1,
      namaPelanggan: 'Flutter Integration Test',
      items: const [
        OrderItemRequest(idMenu: 1, jumlah: 1, catatan: 'Tidak pedas', opsi: []),
      ],
    );
    expect(created.status, OrderStatus.ordered);

    final detail = await orderRepository.getOrderDetail(created.idPemesanan);
    expect(detail.idPemesanan, created.idPemesanan);
    expect(detail.items, isNotEmpty);
    expect(detail.items.first.namaMenu, 'Tomato Onion Fried Rice');

    final bill = await orderRepository.requestBill(created.idPemesanan);
    expect(bill.idInvoice, greaterThan(0));

    final invoice = await invoiceRepository.getInvoiceDetail(bill.idInvoice);
    expect(invoice.idPemesanan, created.idPemesanan);
    expect(invoice.status, InvoiceStatus.requested);
    expect(invoice.totalHarga, detail.items.fold<int>(0, (sum, i) => sum + i.subtotal));
  });
}
