class CartSummary {
  final int totalItem;
  final int totalHarga;

  const CartSummary({required this.totalItem, required this.totalHarga});

  bool get isEmpty => totalItem == 0;
}
