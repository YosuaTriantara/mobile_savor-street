import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableSession {
  final int idMeja;
  final String nomorMeja;

  const TableSession({required this.idMeja, required this.nomorMeja});
}

/// Temporary stub — Anggota 5 owns features/qr/ and will replace this with
/// the real session produced by GET /tables/validate?token=. Until then,
/// cart/order/invoice assume table 01 (id_meja: 1) so the checkout flow can
/// be built and tested end-to-end against the live API.
final tableSessionProvider = Provider<TableSession>((ref) {
  return const TableSession(idMeja: 1, nomorMeja: '01');
});
