enum OrderStatus {
  ordered,
  billRequested,
  completed,
  cancelled;

  static OrderStatus fromApi(String value) {
    switch (value) {
      case 'ordered':
        return OrderStatus.ordered;
      case 'bill_requested':
        return OrderStatus.billRequested;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        throw ArgumentError('Unknown OrderStatus: $value');
    }
  }
}
