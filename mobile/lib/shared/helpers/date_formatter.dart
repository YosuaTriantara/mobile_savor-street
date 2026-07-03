/// Formatter tanggal, tanpa dependency intl — konsisten dengan
/// PriceFormatter yang sudah ada.
class DateFormatter {
  DateFormatter._();

  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');

  /// Contoh: "3 Jul 2026"
  static String date(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  /// Contoh: "14:05"
  static String time(DateTime date) {
    return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  /// Contoh: "3 Jul 2026, 14:05"
  static String dateTime(DateTime date) {
    return '${DateFormatter.date(date)}, ${time(date)}';
  }

  /// Contoh: "baru saja", "5 menit lalu", "2 jam lalu", "3 hari lalu"
  /// Cocok dipakai untuk status order/invoice.
  static String relative(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormatter.date(date);
  }
}