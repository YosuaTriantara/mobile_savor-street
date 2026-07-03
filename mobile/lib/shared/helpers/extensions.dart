import 'package:flutter/material.dart';
import 'date_formatter.dart';
import 'price_formatter.dart';

/// Extension pemendek akses tema/ukuran layar dari BuildContext.
extension BuildContextX on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

/// Extension format harga langsung dari int, misal `75000.toRupiah()`.
extension IntPriceX on int {
  String toRupiah() => PriceFormatter.formatWithPrefix(this);
}

/// Extension format tanggal langsung dari DateTime.
extension DateTimeX on DateTime {
  String toDateString() => DateFormatter.date(this);
  String toTimeString() => DateFormatter.time(this);
  String toDateTimeString() => DateFormatter.dateTime(this);
  String toRelativeString() => DateFormatter.relative(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

/// Extension kecil untuk String, misal validasi kosong & capitalize.
extension StringX on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank;

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}