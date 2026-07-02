import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../domain/entities/invoice_detail.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.read(dioProvider));
});

final invoiceDetailProvider =
    FutureProvider.family<InvoiceDetail, int>((ref, idInvoice) {
  return ref.read(invoiceRepositoryProvider).getInvoiceDetail(idInvoice);
});
