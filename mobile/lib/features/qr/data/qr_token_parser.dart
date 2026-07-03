/// Mengambil `qr_token` dari isi mentah QR code.
///
/// QR produksi (di-generate `generate_meja.py`) berisi URL berbentuk
/// `http://localhost:8000?table=<token>`, tetapi parser ini sengaja toleran
/// terhadap tiga bentuk agar tidak rapuh jika format QR berubah:
///
/// 1. URL dengan query param `table` (format produksi saat ini)
/// 2. URL dengan query param `token` (format lama di docs)
/// 3. Raw token langsung (dipakai juga oleh input manual)
///
/// Return `null` jika isi QR tidak dikenali sebagai QR Savor Street.
String? extractQrToken(String rawValue) {
  final value = rawValue.trim();
  if (value.isEmpty) return null;

  final uri = Uri.tryParse(value);
  if (uri != null && (uri.hasScheme || value.contains('?'))) {
    final fromTable = uri.queryParameters['table'];
    if (fromTable != null && fromTable.isNotEmpty) return fromTable.trim();

    final fromToken = uri.queryParameters['token'];
    if (fromToken != null && fromToken.isNotEmpty) return fromToken.trim();

    // Berbentuk URL tapi tidak membawa param yang dikenal → bukan QR meja.
    if (uri.hasScheme) return null;
  }

  // Raw token: hasil secrets.token_urlsafe → huruf, angka, `-`, `_`.
  final rawTokenPattern = RegExp(r'^[A-Za-z0-9_-]+$');
  if (rawTokenPattern.hasMatch(value)) return value;

  return null;
}
