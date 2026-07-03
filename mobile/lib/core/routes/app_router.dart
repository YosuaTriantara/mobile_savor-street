import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/invoice/presentation/screens/invoice_screen.dart';
import '../../features/order/presentation/screens/order_success_screen.dart';
import '../constants/app_routes.dart';

/// Router utama aplikasi. Setiap anggota yang menyelesaikan screen fitur
/// (qr, menu, customization) tinggal ganti _ComingSoonScreen di bawah
/// dengan screen aslinya.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.qrScan,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.qrScan,
        name: AppRoutes.qrScanName,
        builder: (context, state) =>
            const _ComingSoonScreen(title: 'QR Scan'),
      ),
      GoRoute(
        path: AppRoutes.menu,
        name: AppRoutes.menuName,
        builder: (context, state) => const _ComingSoonScreen(title: 'Menu'),
      ),
      GoRoute(
        path: AppRoutes.menuDetail,
        name: AppRoutes.menuDetailName,
        builder: (context, state) =>
            const _ComingSoonScreen(title: 'Menu Detail'),
      ),
      GoRoute(
        path: AppRoutes.customization,
        name: AppRoutes.customizationName,
        builder: (context, state) =>
            const _ComingSoonScreen(title: 'Customization'),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: AppRoutes.cartName,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        name: AppRoutes.orderSuccessName,
        builder: (context, state) => const OrderSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.invoice,
        name: AppRoutes.invoiceName,
        builder: (context, state) {
          final idInvoice =
              int.parse(state.pathParameters['idInvoice']!);
          return InvoiceScreen(idInvoice: idInvoice);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan: ${state.uri}')),
    ),
  );
});

class _ComingSoonScreen extends StatelessWidget {
  final String title;
  const _ComingSoonScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — belum dikerjakan')),
    );
  }
}