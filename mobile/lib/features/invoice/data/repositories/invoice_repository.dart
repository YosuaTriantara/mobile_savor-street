import 'package:dio/dio.dart';

import '../../domain/entities/invoice_detail.dart';

class InvoiceRepository {
  final Dio _dio;

  InvoiceRepository(this._dio);

  Future<InvoiceDetail> getInvoiceDetail(int idInvoice) async {
    final response = await _dio.get('/invoices/$idInvoice');
    return InvoiceDetail.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
