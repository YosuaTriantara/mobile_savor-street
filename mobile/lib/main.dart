import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/cart/domain/entities/menu_entity.dart';
import 'features/cart/domain/entities/opsi_entity.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/cart/presentation/screens/cart_screen.dart';

void main() {
  runApp(const ProviderScope(child: SavorStreetApp()));
}

class SavorStreetApp extends ConsumerWidget {
  const SavorStreetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Savor Street',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}

/// Dev-only seeder: seeds sample cart items on first frame so CartScreen is
/// visible without waiting for the Menu feature. Remove once Menu/checkout
/// flow wires real navigation into CartScreen.
class _CartPreviewSeeder extends ConsumerStatefulWidget {
  const _CartPreviewSeeder();

  @override
  ConsumerState<_CartPreviewSeeder> createState() => _CartPreviewSeederState();
}

class _CartPreviewSeederState extends ConsumerState<_CartPreviewSeeder> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _seed());
  }

  void _seed() {
    final notifier = ref.read(cartItemsProvider.notifier);
    if (ref.read(cartItemsProvider).isNotEmpty) return;

    notifier.addItem(
      menu: const MenuEntity(
        idMenu: 1,
        namaMenu: 'Tomato Onion Fried Rice',
        harga: 75000,
        kategori: 'Rice',
        gambarMenu: '/menu/tomato-onion-fried-rice.jpg',
        status: 'available',
      ),
      jumlah: 2,
      selectedOpsi: const [
        OpsiEntity(idOpsi: 1, namaOpsi: 'Extra Spicy', hargaTambahan: 0),
      ],
    );
    notifier.addItem(
      menu: const MenuEntity(
        idMenu: 1,
        namaMenu: 'Tomato Onion Fried Rice',
        harga: 75000,
        kategori: 'Rice',
        gambarMenu: '/menu/tomato-onion-fried-rice.jpg',
        status: 'available',
      ),
      jumlah: 1,
      selectedOpsi: const [
        OpsiEntity(idOpsi: 2, namaOpsi: 'Not Spicy', hargaTambahan: 0),
      ],
    );
    notifier.addItem(
      menu: const MenuEntity(
        idMenu: 2,
        namaMenu: 'Orange Squash',
        harga: 10500,
        kategori: 'Beverage',
        gambarMenu: '/menu/orange-squash.jpg',
        status: 'available',
      ),
      jumlah: 1,
      selectedOpsi: const [
        OpsiEntity(idOpsi: 3, namaOpsi: 'Less Ice', hargaTambahan: 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => const CartScreen();
}
