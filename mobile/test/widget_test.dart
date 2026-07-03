import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/core/session/table_session.dart';
import 'package:mobile/features/cart/cart.dart';

void main() {
  // Di aplikasi asli session dibuat oleh QR scan; di widget test CartScreen
  // dipompa langsung tanpa router, jadi session di-override manual.
  const testSession = TableSession(idMeja: 1, nomorMeja: '01');

  testWidgets('CartScreen shows empty state when cart has no items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tableSessionProvider.overrideWithValue(testSession)],
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });

  testWidgets('CartScreen lists items added to CartNotifier',
      (WidgetTester tester) async {
    final container = ProviderContainer(
      overrides: [tableSessionProvider.overrideWithValue(testSession)],
    );
    addTearDown(container.dispose);

    container.read(cartItemsProvider.notifier).addItem(
          menu: const MenuEntity(
            idMenu: 1,
            namaMenu: 'Nasi Goreng',
            harga: 25000,
            kategori: 'Rice',
            status: 'available',
          ),
          jumlah: 2,
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
