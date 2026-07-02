class RequestBillResult {
  final int idInvoice;
  final String status;

  const RequestBillResult({required this.idInvoice, required this.status});

  factory RequestBillResult.fromJson(Map<String, dynamic> json) {
    return RequestBillResult(
      idInvoice: json['id_invoice'] as int,
      status: json['status'] as String,
    );
  }
}
