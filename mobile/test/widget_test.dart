import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/features/cart/cart.dart';

void main() {
  testWidgets('CartScreen shows empty state when cart has no items',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CartScreen()),
      ),
    );

    expect(find.text('Keranjang masih kosong'), findsOneWidget);
  });

  testWidgets('CartScreen lists items added to CartNotifier',
      (WidgetTester tester) async {
    final container = ProviderContainer();
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
