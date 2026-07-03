import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableSession {
  final int idMeja;
  final String nomorMeja;

  const TableSession({required this.idMeja, required this.nomorMeja});
}

/// Sumber kebenaran session meja hasil scan QR.
/// `null` berarti customer belum scan; router guard di app_router.dart
/// memakai state ini untuk memaksa semua halaman kembali ke QR scan.
class TableSessionNotifier extends Notifier<TableSession?> {
  @override
  TableSession? build() => null;

  void start({required int idMeja, required String nomorMeja}) {
    state = TableSession(idMeja: idMeja, nomorMeja: nomorMeja);
  }

  void clear() => state = null;
}

final tableSessionStateProvider =
    NotifierProvider<TableSessionNotifier, TableSession?>(
        TableSessionNotifier.new);

/// Session meja yang dijamin ada. Fitur cart/order/invoice tetap memakai
/// provider ini tanpa menangani kasus null, karena router guard menjamin
/// halaman mereka hanya bisa dibuka setelah QR tervalidasi.
/// Pada widget test, override provider ini dengan TableSession dummy:
/// `tableSessionProvider.overrideWithValue(TableSession(idMeja: 1, nomorMeja: '01'))`.
final tableSessionProvider = Provider<TableSession>((ref) {
  final session = ref.watch(tableSessionStateProvider);
  if (session == null) {
    throw StateError(
      'TableSession belum tersedia. Halaman ini seharusnya hanya bisa '
      'diakses setelah scan QR berhasil (lihat redirect di app_router.dart).',
    );
  }
  return session;
});
