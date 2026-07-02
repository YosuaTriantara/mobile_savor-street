import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/table_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../../invoice/presentation/screens/invoice_screen.dart';
import '../providers/order_provider.dart';

class OrderSuccessScreen extends ConsumerWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final table = ref.watch(tableSessionProvider);
    final order = orderState.currentOrder;

    ref.listen(orderProvider, (previous, next) {
      if (next.billResult != null && previous?.billResult != next.billResult) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => InvoiceScreen(idInvoice: next.billResult!.idInvoice),
          ),
        );
      }
      if (next.billError != null && previous?.billError != next.billError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.billError!)),
        );
      }
    });

    if (order == null) {
      return const Scaffold(body: Center(child: Text('Belum ada pesanan')));
    }

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Order successful!', textAlign: TextAlign.center, style: AppTextStyles.screenTitle),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 56),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoColumn(label: 'Name', value: orderState.namaPelanggan?.isNotEmpty == true
                      ? orderState.namaPelanggan!
                      : '-'),
                  _InfoColumn(label: 'Table', value: table.nomorMeja),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Pesananmu berhasil sampai ke resto kami.\nSelamat menikmati!',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: orderState.isRequestingBill || orderState.billResult != null
                      ? null
                      : () => ref.read(orderProvider.notifier).requestBill(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  icon: orderState.isRequestingBill
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.edit_note, color: Colors.white),
                  label: Text('Request Bill', style: AppTextStyles.buttonLabel),
                ),
              ),
              const SizedBox(height: 8),
              Text('or pay at the cashier', textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(fontStyle: FontStyle.italic)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Invoice', style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 8),
                    ...orderState.submittedItems.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${item.jumlah}x', style: AppTextStyles.itemName),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.menu.namaMenu, style: AppTextStyles.itemName),
                                    if (item.customLabel.isNotEmpty)
                                      Text('Custom : ${item.customLabel}', style: AppTextStyles.body),
                                  ],
                                ),
                              ),
                              Text(PriceFormatter.formatWithPrefix(item.subtotal), style: AppTextStyles.price),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  ref.read(orderProvider.notifier).startNewOrder();
                  Navigator.of(context).pop();
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                ),
                child: Text('Order', style: AppTextStyles.buttonLabel.copyWith(color: AppColors.primaryGreen)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.itemName.copyWith(color: AppColors.primaryGreen, fontSize: 18)),
      ],
    );
  }
}
