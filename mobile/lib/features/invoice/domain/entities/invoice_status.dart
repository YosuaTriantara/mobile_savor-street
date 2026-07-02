enum InvoiceStatus {
  requested,
  paid,
  cancelled;

  static InvoiceStatus fromApi(String value) {
    switch (value) {
      case 'requested':
        return InvoiceStatus.requested;
      case 'paid':
        return InvoiceStatus.paid;
      case 'cancelled':
        return InvoiceStatus.cancelled;
      default:
        throw ArgumentError('Unknown InvoiceStatus: $value');
    }
  }
}
