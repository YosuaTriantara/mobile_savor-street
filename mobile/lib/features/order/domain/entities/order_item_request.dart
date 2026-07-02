class OrderItemRequest {
  final int idMenu;
  final int jumlah;
  final String catatan;
  final List<int> opsi;

  const OrderItemRequest({
    required this.idMenu,
    required this.jumlah,
    this.catatan = '',
    this.opsi = const [],
  });

  Map<String, dynamic> toJson() => {
        'id_menu': idMenu,
        'jumlah': jumlah,
        'catatan': catatan,
        'opsi': opsi,
      };
}
