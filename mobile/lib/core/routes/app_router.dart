import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/customization/presentation/screens/customization_page.dart';
import '../../features/invoice/presentation/screens/invoice_screen.dart';
import '../../features/menu/presentation/screens/menu_detail_page.dart';
import '../../features/menu/presentation/screens/menu_list_page.dart';
import '../../features/order/presentation/screens/order_success_screen.dart';
import '../../features/qr/presentation/screens/qr_scan_screen.dart';
import '../constants/app_routes.dart';
import '../session/table_session.dart';

/// Router utama aplikasi. Setiap anggota yang menyelesaikan screen fitur
/// (qr, menu, customization) tinggal ganti _ComingSoonScreen di bawah
/// dengan screen aslinya.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.qrScan,
    debugLogDiagnostics: true,
    // Guard: seluruh halaman selain QR scan butuh table session hasil scan.
    // Tanpa ini, order bisa terkirim tanpa meja yang valid.
    redirect: (context, state) {
      final hasSession = ref.read(tableSessionStateProvider) != null;
      final isQrScanRoute = state.matchedLocation == AppRoutes.qrScan;
      if (!hasSession && !isQrScanRoute) return AppRoutes.qrScan;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.qrScan,
        name: AppRoutes.qrScanName,
        builder: (context, state) => const QrScanScreen(),
      ),
      GoRoute(
        path: AppRoutes.menu,
        name: AppRoutes.menuName,
        builder: (context, state) => const MenuListPage(),
      ),
      GoRoute(
        path: AppRoutes.menuDetail,
        name: AppRoutes.menuDetailName,
        builder: (context, state) {
          final idMenu = int.parse(state.pathParameters['idMenu']!);
          return MenuDetailPage(idMenu: idMenu);
        },
      ),
      GoRoute(
        path: AppRoutes.customization,
        name: AppRoutes.customizationName,
        builder: (context, state) {
          final idMenu = int.parse(state.pathParameters['idMenu']!);
          return CustomizationPage(idMenu: idMenu);
        },
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