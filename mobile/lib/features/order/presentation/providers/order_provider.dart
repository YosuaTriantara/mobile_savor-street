import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/session/table_session.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../data/repositories/order_repository.dart';
import '../../domain/entities/order_create_result.dart';
import '../../domain/entities/order_item_request.dart';
import '../../domain/entities/request_bill_result.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(ref.read(dioProvider));
});

class OrderState {
  final OrderCreateResult? currentOrder;
  final List<CartItem> submittedItems;
  final String? namaPelanggan;
  final bool isSubmitting;
  final String? submitError;
  final RequestBillResult? billResult;
  final bool isRequestingBill;
  final String? billError;

  const OrderState({
    this.currentOrder,
    this.submittedItems = const [],
    this.namaPelanggan,
    this.isSubmitting = false,
    this.submitError,
    this.billResult,
    this.isRequestingBill = false,
    this.billError,
  });
}

class OrderNotifier extends Notifier<OrderState> {
  @override
  OrderState build() => const OrderState();

  Future<void> submitOrder({String? namaPelanggan}) async {
    final cartItems = ref.read(cartItemsProvider);
    if (cartItems.isEmpty) return;

    state = OrderState(
      submittedItems: state.submittedItems,
      namaPelanggan: namaPelanggan,
      isSubmitting: true,
    );

    try {
      final table = ref.read(tableSessionProvider);
      final items = cartItems
          .map((c) => OrderItemRequest(
                idMenu: c.menu.idMenu,
                jumlah: c.jumlah,
                catatan: c.catatan,
                opsi: c.selectedOpsi.map((o) => o.idOpsi).toList(),
              ))
          .toList();
      final result = await ref.read(orderRepositoryProvider).createOrder(
            idMeja: table.idMeja,
            namaPelanggan: namaPelanggan,
            items: items,
          );
      state = OrderState(
        currentOrder: result,
        submittedItems: cartItems,
        namaPelanggan: namaPelanggan,
      );
      ref.read(cartItemsProvider.notifier).clear();
    } on DioException catch (e) {
      state = OrderState(
        submittedItems: state.submittedItems,
        namaPelanggan: namaPelanggan,
        submitError: _mapError(e),
      );
    }
  }

  Future<void> requestBill() async {
    final order = state.currentOrder;
    if (order == null) return;

    state = OrderState(
      currentOrder: state.currentOrder,
      submittedItems: state.submittedItems,
      namaPelanggan: state.namaPelanggan,
      isRequestingBill: true,
    );

    try {
      final result = await ref.read(orderRepositoryProvider).requestBill(order.idPemesanan);
      state = OrderState(
        currentOrder: state.currentOrder,
        submittedItems: state.submittedItems,
        namaPelanggan: state.namaPelanggan,
        billResult: result,
      );
    } on DioException catch (e) {
      state = OrderState(
        currentOrder: state.currentOrder,
        submittedItems: state.submittedItems,
        namaPelanggan: state.namaPelanggan,
        billError: _mapError(e),
      );
    }
  }

  void startNewOrder() => state = const OrderState();

  String _mapError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) return data['message'] as String;
    return 'Terjadi kesalahan, coba lagi.';
  }
}

final orderProvider = NotifierProvider<OrderNotifier, OrderState>(OrderNotifier.new);
