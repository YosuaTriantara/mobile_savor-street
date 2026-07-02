import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/helpers/price_formatter.dart';
import '../../../order/domain/entities/order_item_detail.dart';
import '../../domain/entities/invoice_detail.dart';
import '../../domain/entities/invoice_status.dart';
import '../providers/invoice_provider.dart';

class InvoiceScreen extends ConsumerWidget {
  final int idInvoice;

  const InvoiceScreen({super.key, required this.idInvoice});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(idInvoice));

    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: AppColors.creamBackground,
        elevation: 0,
        title: Text('Invoice', style: AppTextStyles.screenTitle),
      ),
      body: SafeArea(
        child: invoiceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('Gagal memuat invoice', style: AppTextStyles.body),
          ),
          data: (invoice) => _InvoiceBody(invoice: invoice),
        ),
      ),
    );
  }
}

class _InvoiceBody extends StatelessWidget {
  final InvoiceDetail invoice;

  const _InvoiceBody({required this.invoice});

  String get _statusLabel {
    switch (invoice.status) {
      case InvoiceStatus.requested:
        return 'Menunggu pembayaran di kasir';
      case InvoiceStatus.paid:
        return 'Sudah dibayar';
      case InvoiceStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meja ${invoice.nomorMeja} · Pesanan #${invoice.idPemesanan}',
              style: AppTextStyles.body),
          const SizedBox(height: 4),
          Text(_statusLabel, style: AppTextStyles.link.copyWith(decoration: null)),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
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
                itemCount: invoice.items.length,
                separatorBuilder: (_, _) =>
                    const Divider(color: AppColors.border, height: 1),
                itemBuilder: (context, index) => _InvoiceItemRow(item: invoice.items[index]),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                Text(
                  PriceFormatter.formatWithPrefix(invoice.totalHarga),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceItemRow extends StatelessWidget {
  final OrderItemDetail item;

  const _InvoiceItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final customLabel = item.opsi.isNotEmpty
        ? item.opsi.map((o) => o.namaOpsi).join(', ')
        : item.catatan;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${item.jumlah}x', style: AppTextStyles.itemName),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.namaMenu, style: AppTextStyles.itemName),
                if (customLabel.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text('Custom : $customLabel', style: AppTextStyles.body),
                ],
              ],
            ),
          ),
          Text(PriceFormatter.formatWithPrefix(item.subtotal), style: AppTextStyles.price),
        ],
      ),
    );
  }
}
