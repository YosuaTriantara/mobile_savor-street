import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../../../shared/widgets/base_button.dart';
import '../../../../shared/widgets/error_state_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/quantity_stepper.dart';
import '../../../cart/domain/entities/menu_entity.dart' as cart_menu_stub;
import '../../../cart/domain/entities/opsi_entity.dart' as cart_opsi_stub;
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../menu/domain/entities/menu_entity.dart' as menu_domain;
import '../../../menu/presentation/providers/menu_detail_provider.dart';
import '../../domain/entities/opsi_entity.dart' as customization_domain;
import '../providers/customization_provider.dart';
import '../widgets/option_group_section.dart';

// ============================================================================
// CATATAN TECHNICAL DEBT (item #4 di rencana perbaikan):
// `cartItemsProvider.notifier.addItem()` menerima `MenuEntity`/`OpsiEntity`
// versi STUB dari `features/cart/domain/entities/` — bukan entity resmi dari
// `features/menu` & `features/customization` yang dipakai di layar ini.
// Keduanya field-nya identik tapi secara tipe Dart adalah class yang
// berbeda, jadi tidak bisa dioper langsung. Konversi kecil di bawah
// (`_toCartStubMenu` / `_toCartStubOpsi`) menjembatani itu SEMENTARA, tanpa
// menyentuh file punya rekan cart. Begitu stub itu dihapus & cart_item.dart
// direpoint ke entity resmi, fungsi konversi ini & import "as" di atas bisa
// dibuang.
// ============================================================================

class CustomizationPage extends ConsumerWidget {
  final int idMenu;

  const CustomizationPage({super.key, required this.idMenu});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(menuDetailProvider(idMenu));
    final customizationState = ref.watch(customizationProvider(idMenu));

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: Text('Kustomisasi', style: AppTextStyles.screenTitle),
      ),
      body: SafeArea(
        child: _buildBody(context, ref, detailState, customizationState),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MenuDetailState detailState,
    CustomizationState customizationState,
  ) {
    // Perlu detail menu (nama/harga/gambar) DAN daftar grup opsi sebelum
    // layar ini berguna, jadi loading/error keduanya digabung.
    final isLoading =
        (detailState.isLoading && detailState.menu == null) ||
        (customizationState.isLoading && customizationState.groups.isEmpty);
    if (isLoading) {
      return const LoadingWidget(message: 'Menyiapkan kustomisasi...');
    }

    final loadError = detailState.error ?? customizationState.error;
    if (loadError != null && detailState.menu == null) {
      return ErrorStateWidget(
        message: loadError,
        onRetry: () {
          ref.read(menuDetailProvider(idMenu).notifier).retry(idMenu);
          ref.read(customizationProvider(idMenu).notifier).retry(idMenu);
        },
      );
    }

    final menu = detailState.menu!;
    final imageUrl = (menu.gambarMenu != null && menu.gambarMenu!.isNotEmpty)
        ? ImageUrlHelper.build(menu.gambarMenu!)
        : null;
    final unitPrice = menu.harga + customizationState.extraPricePerUnit;
    final totalPrice = unitPrice * customizationState.quantity;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: imageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    _imagePlaceholder(),
                              )
                            : _imagePlaceholder(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(menu.namaMenu, style: AppTextStyles.itemName),
                          const SizedBox(height: 4),
                          Text(
                            PriceFormatter.formatWithPrefix(menu.harga),
                            style: AppTextStyles.price,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (customizationState.error != null &&
                    customizationState.groups.isEmpty)
                  // Detail menu berhasil dimuat, tapi fetch opsi gagal —
                  // tampilkan error di sini saja, jangan blok seluruh
                  // layar (harga & tombol tetap berfungsi tanpa opsi).
                  GestureDetector(
                    onTap: () => ref
                        .read(customizationProvider(idMenu).notifier)
                        .retry(idMenu),
                    child: Text(
                      '${customizationState.error} Tap untuk coba lagi.',
                      style: AppTextStyles.body.copyWith(color: AppColors.danger),
                    ),
                  )
                else if (customizationState.groups.isEmpty)
                  Text(
                    'Menu ini tidak punya opsi kustomisasi.',
                    style: AppTextStyles.body,
                  )
                else
                  ...customizationState.groups.map(
                    (group) => OptionGroupSection(
                      group: group,
                      selected:
                          customizationState.selected[group.grupOpsi] ??
                              const [],
                      onToggle: (opsi) => ref
                          .read(customizationProvider(idMenu).notifier)
                          .toggleOption(group, opsi),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jumlah', style: AppTextStyles.sectionTitle),
                    QuantityStepper(
                      quantity: customizationState.quantity,
                      onChanged: (qty) => ref
                          .read(customizationProvider(idMenu).notifier)
                          .setQuantity(qty),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _BottomBar(
          totalPrice: totalPrice,
          isValid: customizationState.isValid,
          onAddToCart: () => _addToCart(context, ref, menu, customizationState),
        ),
      ],
    );
  }

  void _addToCart(
    BuildContext context,
    WidgetRef ref,
    menu_domain.MenuEntity menu,
    CustomizationState customizationState,
  ) {
    ref.read(cartItemsProvider.notifier).addItem(
          menu: _toCartStubMenu(menu),
          jumlah: customizationState.quantity,
          selectedOpsi:
              customizationState.selectedFlat.map(_toCartStubOpsi).toList(),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${menu.namaMenu} ditambahkan ke keranjang')),
    );
    context.goNamed(AppRoutes.menuName);
  }

  Widget _imagePlaceholder() => Container(
        color: AppColors.creamHeader,
        alignment: Alignment.center,
        child: const Icon(Icons.restaurant_menu, color: AppColors.gold),
      );
}

/// Lihat catatan technical debt di kepala file: menjembatani entity resmi
/// (features/menu, features/customization) ke stub yang masih dipakai
/// `cartItemsProvider` (features/cart), tanpa mengubah file cart.
cart_menu_stub.MenuEntity _toCartStubMenu(menu_domain.MenuEntity menu) =>
    cart_menu_stub.MenuEntity(
      idMenu: menu.idMenu,
      namaMenu: menu.namaMenu,
      harga: menu.harga,
      kategori: menu.kategori,
      gambarMenu: menu.gambarMenu,
      status: menu.status,
    );

cart_opsi_stub.OpsiEntity _toCartStubOpsi(
  customization_domain.OpsiEntity opsi,
) =>
    cart_opsi_stub.OpsiEntity(
      idOpsi: opsi.idOpsi,
      namaOpsi: opsi.namaOpsi,
      hargaTambahan: opsi.hargaTambahan,
    );

class _BottomBar extends StatelessWidget {
  final int totalPrice;
  final bool isValid;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.totalPrice,
    required this.isValid,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Total', style: AppTextStyles.body),
                  Text(
                    PriceFormatter.formatWithPrefix(totalPrice),
                    style: AppTextStyles.price.copyWith(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BaseButton(
                label: 'Tambah ke Keranjang',
                onPressed: isValid ? onAddToCart : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}