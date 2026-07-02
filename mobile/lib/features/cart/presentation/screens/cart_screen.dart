import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/table_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../order/presentation/providers/order_provider.dart';
import '../../../order/presentation/screens/order_success_screen.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary_bar.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartItemsProvider);
    final summary = ref.watch(cartSummaryProvider);
    final notifier = ref.read(cartItemsProvider.notifier);
    final table = ref.watch(tableSessionProvider);
    final orderState = ref.watch(orderProvider);

    Future<void> submitOrder() async {
      await ref.read(orderProvider.notifier).submitOrder();
      if (!context.mounted) return;
      final result = ref.read(orderProvider);
      if (result.submitError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.submitError!)),
        );
      } else if (result.currentOrder != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text('Cart', style: AppTextStyles.screenTitle),
      ),
      body: SafeArea(
        child: items.isEmpty
            ? const _EmptyCart()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderMetaHeader(
                      nomorPesanan: orderState.currentOrder != null
                          ? '#${orderState.currentOrder!.idPemesanan}'
                          : '-',
                      nomorMeja: table.nomorMeja,
                    ),
                    const SizedBox(height: 16),
                    Text('Invoice', style: AppTextStyles.sectionTitle),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: items.length,
                          separatorBuilder: (_, _) =>
                              const Divider(color: AppColors.border, height: 1),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return CartItemTile(
                              item: item,
                              onQuantityChanged: (qty) =>
                                  notifier.updateQuantity(item.id, qty),
                              onEdit: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Edit kustomisasi belum tersedia (menunggu fitur Customization)',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CartSummaryBar(summary: summary),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '*Termasuk pajak & service',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: (summary.isEmpty || orderState.isSubmitting)
                            ? null
                            : submitOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: orderState.isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : Text('Kirim Orderan', style: AppTextStyles.buttonLabel),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
    );
  }
}

class _OrderMetaHeader extends StatelessWidget {
  final String nomorPesanan;
  final String nomorMeja;

  const _OrderMetaHeader({required this.nomorPesanan, required this.nomorMeja});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(child: _MetaItem(label: 'Nomor Pesanan', value: nomorPesanan)),
          Container(width: 1, height: 32, color: AppColors.border),
          Expanded(child: _MetaItem(label: 'Nomor Meja', value: nomorMeja)),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetaItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 12)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.itemName.copyWith(color: AppColors.primaryGreen),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.border),
          const SizedBox(height: 12),
          Text('Keranjang masih kosong', style: AppTextStyles.body),
        ],
      ),
    );
  }
}
